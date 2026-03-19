import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

enum GenericTableSelectionMode { none, single, multiple }

enum GenericTableCellKind { text, status, chip, link, action, custom }

enum GenericTableStatusTone { neutral, success, warning, danger }

enum GenericColumnSize { s, m, l }

class GenericTableCellData {
  const GenericTableCellData._({
    required this.kind,
    this.label,
    this.onPressed,
    this.icon,
    this.customBuilder,
    this.statusTone = GenericTableStatusTone.neutral,
    this.usePrimaryAction = false,
  });

  final GenericTableCellKind kind;
  final String? label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final WidgetBuilder? customBuilder;
  final GenericTableStatusTone statusTone;
  final bool usePrimaryAction;

  factory GenericTableCellData.text(String label) =>
      GenericTableCellData._(kind: GenericTableCellKind.text, label: label);

  factory GenericTableCellData.status(
    String label, {
    GenericTableStatusTone tone = GenericTableStatusTone.neutral,
  }) {
    return GenericTableCellData._(
      kind: GenericTableCellKind.status,
      label: label,
      statusTone: tone,
    );
  }

  factory GenericTableCellData.chip(String label, {IconData? icon}) {
    return GenericTableCellData._(
      kind: GenericTableCellKind.chip,
      label: label,
      icon: icon,
    );
  }

  factory GenericTableCellData.link(
    String label, {
    required VoidCallback onPressed,
  }) {
    return GenericTableCellData._(
      kind: GenericTableCellKind.link,
      label: label,
      onPressed: onPressed,
    );
  }

  factory GenericTableCellData.action(
    String label, {
    required VoidCallback onPressed,
    IconData? icon,
    bool primary = false,
  }) {
    return GenericTableCellData._(
      kind: GenericTableCellKind.action,
      label: label,
      onPressed: onPressed,
      icon: icon,
      usePrimaryAction: primary,
    );
  }

  factory GenericTableCellData.custom(WidgetBuilder builder) {
    return GenericTableCellData._(
      kind: GenericTableCellKind.custom,
      customBuilder: builder,
    );
  }
}

class GenericTableColumn<T> {
  const GenericTableColumn({
    required this.id,
    required this.title,
    this.width,
    this.fixedWidth,
    this.minWidth = 90,
    this.maxWidth = 420,
    this.size = GenericColumnSize.m,
    this.pinned = false,
    this.sortable = true,
    this.sortValueBuilder,
    this.cellBuilder,
    this.cellDataBuilder,
    this.textValueBuilder,
    this.alignment = Alignment.centerLeft,
  });

  final String id;
  final String title;
  final TableSize? width;
  final double? fixedWidth;
  final double minWidth;
  final double maxWidth;
  final GenericColumnSize size;
  final bool pinned;
  final bool sortable;
  final Object? Function(T row)? sortValueBuilder;
  final Widget Function(BuildContext context, T row)? cellBuilder;
  final GenericTableCellData Function(T row)? cellDataBuilder;
  final String Function(T row)? textValueBuilder;
  final Alignment alignment;
}

class GenericTableWidget<T> extends StatefulWidget {
  const GenericTableWidget({
    super.key,
    required this.rows,
    required this.columns,
    required this.rowIdBuilder,
    this.selectionMode = GenericTableSelectionMode.none,
    this.showCheckboxColumn = true,
    this.selectedRowIds,
    this.onSelectedRowIdsChanged,
    this.pinnedColumnIds = const <String>{},
    this.pinnedRowIds = const <String>{},
    this.freezeHeader = true,
    this.height = 360,
    this.defaultColumnWidth = const FixedTableSize(180),
    this.estimatedFlexColumnWidth = 180,
    this.headerHeight = 48,
    this.rowHeight = 52,
    this.enableRowTapSelection = false,
    this.showScrollSliders = false,
    this.enableQuickSearch = true,
    this.quickSearchHint = 'Quick search...',
    this.enableSorting = true,
    this.enablePagination = true,
    this.rowsPerPage = 10,
    this.availableRowsPerPage = const <int>[10, 15, 20, 30, 40, 50],
    this.minWidth,
    this.smRatio = 0.67,
    this.lmRatio = 1.2,
    this.minTableWidth,
    this.maxTableWidth,
    this.tableTheme,
  });

  final List<T> rows;
  final List<GenericTableColumn<T>> columns;
  final String Function(T row) rowIdBuilder;
  final GenericTableSelectionMode selectionMode;
  final bool showCheckboxColumn;
  final Set<String>? selectedRowIds;
  final ValueChanged<Set<String>>? onSelectedRowIdsChanged;
  final Set<String> pinnedColumnIds;
  final Set<String> pinnedRowIds;
  final bool freezeHeader;
  final double height;
  final TableSize defaultColumnWidth;
  final double estimatedFlexColumnWidth;
  final double headerHeight;
  final double rowHeight;
  final bool enableRowTapSelection;
  final bool showScrollSliders;
  final bool enableQuickSearch;
  final String quickSearchHint;
  final bool enableSorting;
  final bool enablePagination;
  final int rowsPerPage;
  final List<int> availableRowsPerPage;
  final double? minWidth;
  final double smRatio;
  final double lmRatio;
  final double? minTableWidth;
  final double? maxTableWidth;
  final TableTheme? tableTheme;

  @override
  State<GenericTableWidget<T>> createState() => _GenericTableWidgetState<T>();
}

class _GenericTableWidgetState<T> extends State<GenericTableWidget<T>> {
  late Set<String> _selectedRowIds;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _sortColumnId;
  bool _sortAscending = true;
  var _currentPage = 0;
  late int _rowsPerPage;
  var _revisionTick = 0;

  bool get _isSelectionEnabled =>
      widget.selectionMode != GenericTableSelectionMode.none;

  bool get _showCheckboxColumn =>
      _isSelectionEnabled && widget.showCheckboxColumn;

  // Set<String> get _effectiveSelectedRowIds =>
  //     widget.selectedRowIds ?? _selectedRowIds;

  @override
  void initState() {
    super.initState();
    _selectedRowIds = Set<String>.from(
      widget.selectedRowIds ?? const <String>{},
    );
    _rowsPerPage = _normalizedRowsPerPage(widget.rowsPerPage);
  }

  @override
  void didUpdateWidget(covariant GenericTableWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedRowIds != null &&
        !setEquals(widget.selectedRowIds!, _selectedRowIds)) {
      _selectedRowIds = Set<String>.from(widget.selectedRowIds!);
      _revisionTick += 1;
    }
    if (widget.rowsPerPage != oldWidget.rowsPerPage ||
        !listEquals(
          widget.availableRowsPerPage,
          oldWidget.availableRowsPerPage,
        )) {
      _rowsPerPage = _normalizedRowsPerPage(widget.rowsPerPage);
      _currentPage = 0;
      _revisionTick += 1;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderedColumns = _orderedColumns([...widget.columns]);
    final filteredRows = _applyQuickSearch([...widget.rows], orderedColumns);
    final sortedRows = _applySorting(filteredRows, orderedColumns);
    final orderedRows = _sortColumnId == null
        ? _orderedRows(sortedRows)
        : sortedRows;
    return LayoutBuilder(
      builder: (context, constraints) {
        final searchBarHeight = widget.enableQuickSearch ? 48.0 : 0.0;
        final paginationBarHeight = widget.enablePagination ? 44.0 : 0.0;
        final viewportHeight = math.max(
          120.0,
          widget.height - searchBarHeight - paginationBarHeight,
        );
        final totalRows = orderedRows.length;
        final effectivePage = _effectivePage(totalRows);
        final visibleRows = widget.enablePagination
            ? _rowsForPage(orderedRows, effectivePage)
            : orderedRows;
        final deviceWidth = MediaQuery.sizeOf(context).width;
        final availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : deviceWidth;
        final defaultDeviceMinWidth = deviceWidth < 600
            ? deviceWidth
            : deviceWidth < 1100
            ? 640.0
            : 860.0;
        final requestedMin =
            widget.minWidth ?? widget.minTableWidth ?? defaultDeviceMinWidth;
        final requestedMax = widget.maxTableWidth ?? availableWidth;
        final normalizedMin = math.min(requestedMin, requestedMax);
        final normalizedMax = math.max(requestedMin, requestedMax);
        final tableWidth = availableWidth
            .clamp(normalizedMin, normalizedMax)
            .toDouble();
        final columnWidths = _buildColumnWidths(orderedColumns, tableWidth);
        final selectionRevision = _selectionRevisionKey();
        final tableRevision = Object.hashAll([
          selectionRevision,
          _searchQuery,
          _sortColumnId,
          _sortAscending,
          orderedRows.length,
          visibleRows.length,
          _showCheckboxColumn,
          widget.enablePagination,
          effectivePage,
          _rowsPerPage,
          _revisionTick,
        ]);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.enableQuickSearch) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      placeholder: Text(widget.quickSearchHint),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value.trim();
                        });
                      },
                    ),
                  ),
                  if (_searchQuery.isNotEmpty) ...[
                    const Gap(8),
                    OutlineButton(
                      density: ButtonDensity.compact,
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                      child: const Text('Clear'),
                    ),
                  ],
                ],
              ),
              const Gap(8),
            ],
            ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.trackpad,
                },
                // Disable overscroll glow and bouncing to keep the table steady.
                overscroll: false,
              ),
              child: SizedBox(
                height: viewportHeight,
                child: OutlinedContainer(
                  child: ScrollableClient(
                    key: ValueKey('scrollable_client_$tableRevision'),
                    diagonalDragBehavior: DiagonalDragBehavior.free,
                    builder: (context, offset, viewportSize, child) {
                      return Table(
                        key: ValueKey('table_$tableRevision'),
                        theme: widget.tableTheme,
                        rows: _buildRows(
                          context: context,
                          orderedColumns: orderedColumns,
                          orderedRows: visibleRows,
                        ),
                        defaultColumnWidth: widget.defaultColumnWidth,
                        columnWidths: columnWidths,
                        rowHeights: _buildRowHeights(visibleRows.length),
                        frozenCells: _buildFrozenCells(
                          orderedColumns,
                          visibleRows,
                        ),
                        horizontalOffset: offset.dx,
                        verticalOffset: offset.dy,
                        viewportSize: viewportSize,
                      );
                    },
                    child: SizedBox.expand(
                      key: ValueKey('scroll_client_child_$tableRevision'),
                    ),
                  ),
                ),
              ),
            ),
            if (widget.enablePagination) ...[
              const Gap(8),
              _buildPaginationBar(totalRows, effectivePage),
            ],
          ],
        );
      },
    );
  }

  List<GenericTableColumn<T>> _orderedColumns(
    List<GenericTableColumn<T>> columns,
  ) {
    final safeColumns =
        (columns as Iterable<GenericTableColumn<T>>?)?.toList() ??
        <GenericTableColumn<T>>[];
    final pinnedColumnIds =
        (widget.pinnedColumnIds as Set<String>?) ?? const <String>{};
    final pinned = safeColumns
        .where((column) => column.pinned || pinnedColumnIds.contains(column.id))
        .toList();
    final others = safeColumns
        .where(
          (column) => !column.pinned && !pinnedColumnIds.contains(column.id),
        )
        .toList();
    return [...pinned, ...others];
  }

  List<T> _orderedRows(List<T> rows) {
    final safeRows = (rows as Iterable<T>?)?.toList() ?? <T>[];
    final pinnedRowIds =
        (widget.pinnedRowIds as Set<String>?) ?? const <String>{};
    final pinned = safeRows
        .where((row) => pinnedRowIds.contains(widget.rowIdBuilder(row)))
        .toList();
    final others = safeRows
        .where((row) => !pinnedRowIds.contains(widget.rowIdBuilder(row)))
        .toList();
    return [...pinned, ...others];
  }

  Map<int, TableSize> _buildColumnWidths(
    List<GenericTableColumn<T>> columns,
    double tableWidth,
  ) {
    final widths = <int, TableSize>{};
    var tableIndex = 0;
    var fixedOccupied = 0.0;

    if (_showCheckboxColumn) {
      widths[tableIndex] = const FixedTableSize(52);
      fixedOccupied += 52;
      tableIndex += 1;
    }

    final ratioColumns = <int, GenericTableColumn<T>>{};
    for (final column in columns) {
      if (column.width != null) {
        widths[tableIndex] = column.width!;
        if (column.width is FixedTableSize) {
          fixedOccupied += (column.width as FixedTableSize).value;
        }
        tableIndex += 1;
        continue;
      }

      if (column.fixedWidth != null) {
        final normalized = column.fixedWidth!
            .clamp(column.minWidth, column.maxWidth)
            .toDouble();
        widths[tableIndex] = FixedTableSize(normalized);
        fixedOccupied += normalized;
        tableIndex += 1;
        continue;
      }

      ratioColumns[tableIndex] = column;
      tableIndex += 1;
    }

    if (ratioColumns.isNotEmpty) {
      final remaining = math.max(120.0, tableWidth - fixedOccupied);
      var weightTotal = 0.0;
      final columnWeights = <int, double>{};
      for (final entry in ratioColumns.entries) {
        final weight = switch (entry.value.size) {
          GenericColumnSize.s => widget.smRatio,
          GenericColumnSize.m => 1.0,
          GenericColumnSize.l => widget.lmRatio,
        };
        columnWeights[entry.key] = weight;
        weightTotal += weight;
      }

      for (final entry in ratioColumns.entries) {
        final weight = columnWeights[entry.key] ?? 1.0;
        final raw = weightTotal <= 0
            ? remaining / ratioColumns.length
            : remaining * (weight / weightTotal);
        final normalized = raw
            .clamp(entry.value.minWidth, entry.value.maxWidth)
            .toDouble();
        widths[entry.key] = FixedTableSize(normalized);
      }
    }

    return widths;
  }

  Map<int, TableSize> _buildRowHeights(int rowCount) {
    return <int, TableSize>{
      0: FixedTableSize(widget.headerHeight),
      for (var i = 1; i <= rowCount; i++) i: FixedTableSize(widget.rowHeight),
    };
  }

  FrozenTableData _buildFrozenCells(
    List<GenericTableColumn<T>> columns,
    List<T> rows,
  ) {
    final safeColumns =
        (columns as Iterable<GenericTableColumn<T>>?)?.toList() ??
        <GenericTableColumn<T>>[];
    final safeRows = (rows as Iterable<T>?)?.toList() ?? <T>[];
    final pinnedColumnIds =
        (widget.pinnedColumnIds as Set<String>?) ?? const <String>{};
    final pinnedRowIds =
        (widget.pinnedRowIds as Set<String>?) ?? const <String>{};

    final pinnedColumnCount = safeColumns
        .where((column) => column.pinned || pinnedColumnIds.contains(column.id))
        .length;
    final totalPinnedColumns = _showCheckboxColumn
        ? pinnedColumnCount + 1
        : pinnedColumnCount;
    final pinnedRowCount = safeRows
        .where((row) => pinnedRowIds.contains(widget.rowIdBuilder(row)))
        .length;

    final frozenRows = <TableRef>[
      if (widget.freezeHeader) const TableRef(0),
      if (pinnedRowCount > 0) TableRef(1, pinnedRowCount),
    ];
    final frozenColumns = <TableRef>[
      if (totalPinnedColumns > 0) TableRef(0, totalPinnedColumns),
    ];

    return FrozenTableData(
      frozenRows: frozenRows,
      frozenColumns: frozenColumns,
    );
  }

  List<TableRow> _buildRows({
    required BuildContext context,
    required List<GenericTableColumn<T>> orderedColumns,
    required List<T> orderedRows,
  }) {
    final rows = <TableRow>[
      TableHeader(cells: _buildHeaderCells(orderedRows, orderedColumns)),
    ];

    for (final row in orderedRows) {
      final rowId = widget.rowIdBuilder(row);
      final selected = _selectedRowIds.contains(rowId);
      rows.add(
        TableRow(
          selected: selected,
          cells: _buildDataCells(context, row, orderedColumns),
        ),
      );
    }
    return rows;
  }

  List<TableCell> _buildHeaderCells(
    List<T> orderedRows,
    List<GenericTableColumn<T>> orderedColumns,
  ) {
    final cells = <TableCell>[];
    if (_showCheckboxColumn) {
      cells.add(
        TableCell(
          child: Center(
            child: Checkbox(
              key: ValueKey(
                'header_checkbox_${_headerCheckboxState(orderedRows)}',
              ),
              state: _headerCheckboxState(orderedRows),
              tristate: true,
              onChanged:
                  widget.selectionMode == GenericTableSelectionMode.multiple
                  ? (_) => _toggleAllRows(orderedRows)
                  : null,
            ),
          ),
        ),
      );
    }

    for (final column in orderedColumns) {
      final isSorted = _sortColumnId == column.id;
      final canSort = widget.enableSorting && column.sortable;
      cells.add(
        TableCell(
          child: Align(
            alignment: column.alignment,
            child: canSort
                ? OutlineButton(
                    density: ButtonDensity.compact,
                    onPressed: () => _toggleSort(column.id),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(column.title).semiBold,
                        const Gap(4),
                        Icon(
                          isSorted
                              ? (_sortAscending
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down)
                              : Icons.unfold_more,
                          size: 14,
                        ),
                      ],
                    ),
                  )
                : Text(column.title).semiBold,
          ),
        ),
      );
    }
    return cells;
  }

  List<TableCell> _buildDataCells(
    BuildContext context,
    T row,
    List<GenericTableColumn<T>> orderedColumns,
  ) {
    final rowId = widget.rowIdBuilder(row);
    final cells = <TableCell>[];

    if (_showCheckboxColumn) {
      final checked = _selectedRowIds.contains(rowId);
      cells.add(
        TableCell(
          child: Center(
            child: Checkbox(
              key: ValueKey('row_checkbox_${rowId}_$checked'),
              state: checked ? CheckboxState.checked : CheckboxState.unchecked,
              onChanged: (_) => _toggleRowSelection(rowId),
            ),
          ),
        ),
      );
    }

    for (final column in orderedColumns) {
      final content = _buildCellContent(context, row, column);
      final canSelectWithTap =
          widget.enableRowTapSelection &&
          _isSelectionEnabled &&
          !_isInteractiveColumn(column, row);

      cells.add(
        TableCell(
          child: Align(
            alignment: column.alignment,
            child: canSelectWithTap
                ? GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _toggleRowSelection(rowId),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: content,
                    ),
                  )
                : content,
          ),
        ),
      );
    }

    return cells;
  }

  Widget _buildCellContent(
    BuildContext context,
    T row,
    GenericTableColumn<T> column,
  ) {
    if (column.cellBuilder != null) {
      return column.cellBuilder!(context, row);
    }

    if (column.cellDataBuilder != null) {
      final cellData = column.cellDataBuilder!(row);
      return _buildCellFromData(context, cellData);
    }

    final text = column.textValueBuilder?.call(row) ?? '';
    return Text(text);
  }

  bool _isInteractiveColumn(GenericTableColumn<T> column, T row) {
    if (column.cellBuilder != null) {
      return true;
    }
    final cellData = column.cellDataBuilder?.call(row);
    if (cellData == null) {
      return false;
    }
    return cellData.kind == GenericTableCellKind.link ||
        cellData.kind == GenericTableCellKind.action ||
        cellData.kind == GenericTableCellKind.custom;
  }

  Widget _buildCellFromData(BuildContext context, GenericTableCellData data) {
    switch (data.kind) {
      case GenericTableCellKind.text:
        return Text(data.label ?? '');
      case GenericTableCellKind.status:
        return _buildStatusBadge(data);
      case GenericTableCellKind.chip:
        return OutlineBadge(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (data.icon != null) ...[
                Icon(data.icon, size: 14),
                const Gap(6),
              ],
              Text(data.label ?? ''),
            ],
          ),
        );
      case GenericTableCellKind.link:
        return LinkButton(
          onPressed: data.onPressed,
          child: Text(data.label ?? 'Open'),
        );
      case GenericTableCellKind.action:
        return data.usePrimaryAction
            ? PrimaryButton(
                density: ButtonDensity.compact,
                onPressed: data.onPressed,
                child: Row(
                  children: [
                    if (data.icon != null) ...[
                      Icon(data.icon, size: 14),
                      const Gap(6),
                    ],
                    Text(data.label ?? 'Action'),
                  ],
                ),
              )
            : OutlineButton(
                density: ButtonDensity.compact,
                onPressed: data.onPressed,
                child: Row(
                  children: [
                    if (data.icon != null) ...[
                      Icon(data.icon, size: 14),
                      const Gap(6),
                    ],
                    Text(data.label ?? 'Action'),
                  ],
                ),
              );
      case GenericTableCellKind.custom:
        return data.customBuilder?.call(context) ?? const SizedBox.shrink();
    }
  }

  Widget _buildStatusBadge(GenericTableCellData data) {
    final label = Text(data.label ?? '');
    switch (data.statusTone) {
      case GenericTableStatusTone.success:
        return PrimaryBadge(child: label);
      case GenericTableStatusTone.warning:
        return OutlineBadge(child: label);
      case GenericTableStatusTone.danger:
        return DestructiveBadge(child: label);
      case GenericTableStatusTone.neutral:
        return SecondaryBadge(child: label);
    }
  }

  void _toggleSort(String columnId) {
    setState(() {
      if (_sortColumnId != columnId) {
        _sortColumnId = columnId;
        _sortAscending = true;
      } else if (_sortAscending) {
        _sortAscending = !_sortAscending;
      } else {
        _sortColumnId = null;
        _sortAscending = true;
      }
      _revisionTick += 1;
    });
  }

  List<T> _applyQuickSearch(
    List<T> rows,
    List<GenericTableColumn<T>> orderedColumns,
  ) {
    if (!widget.enableQuickSearch || _searchQuery.isEmpty) {
      return rows;
    }
    final safeRows = (rows as Iterable<T>?)?.toList() ?? <T>[];
    final query = _searchQuery.toLowerCase();
    return safeRows
        .where((row) => _rowSearchText(row, orderedColumns).contains(query))
        .toList();
  }

  String _rowSearchText(T row, List<GenericTableColumn<T>> columns) {
    final parts = <String>[];
    for (final column in columns) {
      final textValue = column.textValueBuilder?.call(row);
      if (textValue != null && textValue.isNotEmpty) {
        parts.add(textValue.toLowerCase());
        continue;
      }
      final cellData = column.cellDataBuilder?.call(row);
      if (cellData?.label != null && cellData!.label!.isNotEmpty) {
        parts.add(cellData.label!.toLowerCase());
      }
    }
    return parts.join(' ');
  }

  List<T> _applySorting(
    List<T> rows,
    List<GenericTableColumn<T>> orderedColumns,
  ) {
    if (!widget.enableSorting || _sortColumnId == null || rows.length <= 1) {
      return rows;
    }
    GenericTableColumn<T>? column;
    for (final col in orderedColumns) {
      if (col.id == _sortColumnId) {
        column = col;
        break;
      }
    }
    if (column == null || !column.sortable) {
      return rows;
    }
    final activeColumn = column;

    final sorted = List<T>.from(rows);
    sorted.sort((a, b) {
      final aValue = _sortValueForRow(a, activeColumn);
      final bValue = _sortValueForRow(b, activeColumn);
      final result = _compareValues(aValue, bValue);
      return _sortAscending ? result : -result;
    });
    return sorted;
  }

  Object? _sortValueForRow(T row, GenericTableColumn<T> column) {
    final explicit = column.sortValueBuilder?.call(row);
    if (explicit != null) {
      return explicit;
    }
    final text = column.textValueBuilder?.call(row);
    if (text != null) {
      return text;
    }
    final cellData = column.cellDataBuilder?.call(row);
    return cellData?.label;
  }

  int _compareValues(Object? a, Object? b) {
    if (identical(a, b)) {
      return 0;
    }
    if (a == null) {
      return -1;
    }
    if (b == null) {
      return 1;
    }
    if (a is num && b is num) {
      return a.compareTo(b);
    }
    if (a is DateTime && b is DateTime) {
      return a.compareTo(b);
    }
    if (a is bool && b is bool) {
      return (a ? 1 : 0).compareTo(b ? 1 : 0);
    }
    return a.toString().toLowerCase().compareTo(b.toString().toLowerCase());
  }

  String _selectionRevisionKey() {
    final selectedIds = _selectedRowIds;
    if (selectedIds.isEmpty) {
      return '';
    }
    final ids = selectedIds.toList()..sort();
    return ids.join('|');
  }

  CheckboxState _headerCheckboxState(List<T> orderedRows) {
    if (widget.selectionMode != GenericTableSelectionMode.multiple ||
        orderedRows.isEmpty) {
      return CheckboxState.unchecked;
    }
    final selectableIds = orderedRows.map(widget.rowIdBuilder).toSet();
    final selectedCount = selectableIds
        .where((id) => _selectedRowIds.contains(id))
        .length;
    if (selectedCount == 0) {
      return CheckboxState.unchecked;
    }
    if (selectedCount == selectableIds.length) {
      return CheckboxState.checked;
    }
    return CheckboxState.indeterminate;
  }

  void _toggleAllRows(List<T> rows) {
    if (widget.selectionMode != GenericTableSelectionMode.multiple) {
      return;
    }

    final rowIds = rows.map(widget.rowIdBuilder).toSet();
    final nextSelected = Set<String>.from(_selectedRowIds);
    final allSelected =
        rowIds.isNotEmpty &&
        rowIds.every((rowId) => nextSelected.contains(rowId));
    if (allSelected) {
      nextSelected.removeAll(rowIds);
    } else {
      nextSelected.addAll(rowIds);
    }
    _setSelectedRows(nextSelected);
  }

  void _toggleRowSelection(String rowId) {
    if (rowId.isEmpty) {
      return;
    }
    if (!_isSelectionEnabled) {
      return;
    }
    final selectedIds = _selectedRowIds;
    final next = Set<String>.from(selectedIds);
    if (widget.selectionMode == GenericTableSelectionMode.single) {
      if (selectedIds.contains(rowId)) {
        next.clear();
      } else {
        next
          ..clear()
          ..add(rowId);
      }
    } else {
      if (selectedIds.contains(rowId)) {
        next.remove(rowId);
      } else {
        next.add(rowId);
      }
    }
    _setSelectedRows(next);
  }

  void _setSelectedRows(Set<String> next) {
    if (widget.selectedRowIds == null) {
      setState(() {
        _selectedRowIds = next;
        _revisionTick += 1;
      });
    } else {
      setState(() {
        _selectedRowIds = Set<String>.from(next);
        _revisionTick += 1;
      });
    }
    widget.onSelectedRowIdsChanged?.call(Set<String>.from(next));
  }

  int _normalizedRowsPerPage(int value) {
    final options = widget.availableRowsPerPage.where((v) => v > 0).toList();
    if (options.isEmpty) {
      return value > 0 ? value : 10;
    }
    if (options.contains(value)) {
      return value;
    }
    return options.first;
  }

  int _effectivePage(int totalRows) {
    final maxPage = _maxPage(totalRows);
    return _currentPage.clamp(0, maxPage);
  }

  int _maxPage(int totalRows) {
    if (totalRows <= 0 || _rowsPerPage <= 0) {
      return 0;
    }
    return ((totalRows - 1) ~/ _rowsPerPage);
  }

  List<T> _rowsForPage(List<T> rows, int page) {
    if (rows.isEmpty || _rowsPerPage <= 0) {
      return rows;
    }
    final start = (page * _rowsPerPage).clamp(0, rows.length);
    final end = math.min(start + _rowsPerPage, rows.length);
    return rows.sublist(start, end);
  }

  Widget _buildPaginationBar(int totalRows, int effectivePage) {
    final start = totalRows == 0 ? 0 : (effectivePage * _rowsPerPage) + 1;
    final end = totalRows == 0
        ? 0
        : math.min((effectivePage * _rowsPerPage) + _rowsPerPage, totalRows);
    final maxPage = _maxPage(totalRows);
    final canGoPrevious = effectivePage > 0;
    final canGoNext = effectivePage < maxPage;

    return Row(
      children: [
        Text('Rows: $_rowsPerPage', style: TextStyle(color: Colors.gray)),
        const Gap(8),
        OutlineButton(
          density: ButtonDensity.compact,
          onPressed: () {
            showDropdown(
              context: context,
              builder: (context) {
                return DropdownMenu(
                  children: widget.availableRowsPerPage
                      .where((v) => v > 0)
                      .map(
                        (value) => MenuButton(
                          child: Text('$value / page'),
                          onPressed: (_) {
                            setState(() {
                              _rowsPerPage = value;
                              _currentPage = 0;
                              _revisionTick += 1;
                            });
                          },
                        ),
                      )
                      .toList(),
                );
              },
            );
          },
          child: const Icon(Icons.unfold_more, size: 14),
        ),
        const Spacer(),
        Text('$start-$end / $totalRows', style: TextStyle(color: Colors.gray)),
        const Gap(8),
        OutlineButton(
          density: ButtonDensity.icon,
          onPressed: canGoPrevious
              ? () {
                  setState(() {
                    _currentPage = 0;
                    _revisionTick += 1;
                  });
                }
              : null,
          child: const Icon(Icons.first_page, size: 16),
        ),
        const Gap(4),
        OutlineButton(
          density: ButtonDensity.icon,
          onPressed: canGoPrevious
              ? () {
                  setState(() {
                    _currentPage = math.max(0, effectivePage - 1);
                    _revisionTick += 1;
                  });
                }
              : null,
          child: const Icon(Icons.chevron_left, size: 16),
        ),
        const Gap(4),
        OutlineButton(
          density: ButtonDensity.icon,
          onPressed: canGoNext
              ? () {
                  setState(() {
                    _currentPage = math.min(maxPage, effectivePage + 1);
                    _revisionTick += 1;
                  });
                }
              : null,
          child: const Icon(Icons.chevron_right, size: 16),
        ),
        const Gap(4),
        OutlineButton(
          density: ButtonDensity.icon,
          onPressed: canGoNext
              ? () {
                  setState(() {
                    _currentPage = maxPage;
                    _revisionTick += 1;
                  });
                }
              : null,
          child: const Icon(Icons.last_page, size: 16),
        ),
      ],
    );
  }
}
