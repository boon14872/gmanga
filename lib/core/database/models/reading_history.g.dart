// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_history.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetReadingHistoryCollection on Isar {
  IsarCollection<ReadingHistory> get readingHistorys => this.collection();
}

const ReadingHistorySchema = CollectionSchema(
  name: r'ReadingHistory',
  id: 1167775608031651640,
  properties: {
    r'chapterId': PropertySchema(
      id: 0,
      name: r'chapterId',
      type: IsarType.string,
    ),
    r'chapterTitle': PropertySchema(
      id: 1,
      name: r'chapterTitle',
      type: IsarType.string,
    ),
    r'currentPage': PropertySchema(
      id: 2,
      name: r'currentPage',
      type: IsarType.long,
    ),
    r'isCompleted': PropertySchema(
      id: 3,
      name: r'isCompleted',
      type: IsarType.bool,
    ),
    r'lastReadAt': PropertySchema(
      id: 4,
      name: r'lastReadAt',
      type: IsarType.dateTime,
    ),
    r'mangaId': PropertySchema(
      id: 5,
      name: r'mangaId',
      type: IsarType.string,
    ),
    r'mangaTitle': PropertySchema(
      id: 6,
      name: r'mangaTitle',
      type: IsarType.string,
    ),
    r'progressPercentage': PropertySchema(
      id: 7,
      name: r'progressPercentage',
      type: IsarType.double,
    ),
    r'totalPages': PropertySchema(
      id: 8,
      name: r'totalPages',
      type: IsarType.long,
    )
  },
  estimateSize: _readingHistoryEstimateSize,
  serialize: _readingHistorySerialize,
  deserialize: _readingHistoryDeserialize,
  deserializeProp: _readingHistoryDeserializeProp,
  idName: r'id',
  indexes: {
    r'mangaId': IndexSchema(
      id: 7466570075891278896,
      name: r'mangaId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'mangaId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'chapterId': IndexSchema(
      id: -1917949875430644359,
      name: r'chapterId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'chapterId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'lastReadAt': IndexSchema(
      id: 1842310439171066335,
      name: r'lastReadAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'lastReadAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _readingHistoryGetId,
  getLinks: _readingHistoryGetLinks,
  attach: _readingHistoryAttach,
  version: '3.1.0+1',
);

int _readingHistoryEstimateSize(
  ReadingHistory object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.chapterId.length * 3;
  bytesCount += 3 + object.chapterTitle.length * 3;
  bytesCount += 3 + object.mangaId.length * 3;
  bytesCount += 3 + object.mangaTitle.length * 3;
  return bytesCount;
}

void _readingHistorySerialize(
  ReadingHistory object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.chapterId);
  writer.writeString(offsets[1], object.chapterTitle);
  writer.writeLong(offsets[2], object.currentPage);
  writer.writeBool(offsets[3], object.isCompleted);
  writer.writeDateTime(offsets[4], object.lastReadAt);
  writer.writeString(offsets[5], object.mangaId);
  writer.writeString(offsets[6], object.mangaTitle);
  writer.writeDouble(offsets[7], object.progressPercentage);
  writer.writeLong(offsets[8], object.totalPages);
}

ReadingHistory _readingHistoryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ReadingHistory();
  object.chapterId = reader.readString(offsets[0]);
  object.chapterTitle = reader.readString(offsets[1]);
  object.currentPage = reader.readLong(offsets[2]);
  object.id = id;
  object.lastReadAt = reader.readDateTime(offsets[4]);
  object.mangaId = reader.readString(offsets[5]);
  object.mangaTitle = reader.readString(offsets[6]);
  object.totalPages = reader.readLong(offsets[8]);
  return object;
}

P _readingHistoryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _readingHistoryGetId(ReadingHistory object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _readingHistoryGetLinks(ReadingHistory object) {
  return [];
}

void _readingHistoryAttach(
    IsarCollection<dynamic> col, Id id, ReadingHistory object) {
  object.id = id;
}

extension ReadingHistoryQueryWhereSort
    on QueryBuilder<ReadingHistory, ReadingHistory, QWhere> {
  QueryBuilder<ReadingHistory, ReadingHistory, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterWhere> anyLastReadAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'lastReadAt'),
      );
    });
  }
}

extension ReadingHistoryQueryWhere
    on QueryBuilder<ReadingHistory, ReadingHistory, QWhereClause> {
  QueryBuilder<ReadingHistory, ReadingHistory, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterWhereClause>
      mangaIdEqualTo(String mangaId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'mangaId',
        value: [mangaId],
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterWhereClause>
      mangaIdNotEqualTo(String mangaId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mangaId',
              lower: [],
              upper: [mangaId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mangaId',
              lower: [mangaId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mangaId',
              lower: [mangaId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mangaId',
              lower: [],
              upper: [mangaId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterWhereClause>
      chapterIdEqualTo(String chapterId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'chapterId',
        value: [chapterId],
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterWhereClause>
      chapterIdNotEqualTo(String chapterId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'chapterId',
              lower: [],
              upper: [chapterId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'chapterId',
              lower: [chapterId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'chapterId',
              lower: [chapterId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'chapterId',
              lower: [],
              upper: [chapterId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterWhereClause>
      lastReadAtEqualTo(DateTime lastReadAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'lastReadAt',
        value: [lastReadAt],
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterWhereClause>
      lastReadAtNotEqualTo(DateTime lastReadAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lastReadAt',
              lower: [],
              upper: [lastReadAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lastReadAt',
              lower: [lastReadAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lastReadAt',
              lower: [lastReadAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lastReadAt',
              lower: [],
              upper: [lastReadAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterWhereClause>
      lastReadAtGreaterThan(
    DateTime lastReadAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lastReadAt',
        lower: [lastReadAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterWhereClause>
      lastReadAtLessThan(
    DateTime lastReadAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lastReadAt',
        lower: [],
        upper: [lastReadAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterWhereClause>
      lastReadAtBetween(
    DateTime lowerLastReadAt,
    DateTime upperLastReadAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lastReadAt',
        lower: [lowerLastReadAt],
        includeLower: includeLower,
        upper: [upperLastReadAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ReadingHistoryQueryFilter
    on QueryBuilder<ReadingHistory, ReadingHistory, QFilterCondition> {
  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      chapterIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chapterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      chapterIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chapterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      chapterIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chapterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      chapterIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chapterId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      chapterIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'chapterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      chapterIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'chapterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      chapterIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'chapterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      chapterIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'chapterId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      chapterIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chapterId',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      chapterIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'chapterId',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      chapterTitleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chapterTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      chapterTitleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chapterTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      chapterTitleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chapterTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      chapterTitleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chapterTitle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      chapterTitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'chapterTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      chapterTitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'chapterTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      chapterTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'chapterTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      chapterTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'chapterTitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      chapterTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chapterTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      chapterTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'chapterTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      currentPageEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentPage',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      currentPageGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentPage',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      currentPageLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentPage',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      currentPageBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentPage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      isCompletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      lastReadAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastReadAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      lastReadAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastReadAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      lastReadAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastReadAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      lastReadAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastReadAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      mangaIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mangaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      mangaIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mangaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      mangaIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mangaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      mangaIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mangaId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      mangaIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mangaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      mangaIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mangaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      mangaIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mangaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      mangaIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mangaId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      mangaIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mangaId',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      mangaIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mangaId',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      mangaTitleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mangaTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      mangaTitleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mangaTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      mangaTitleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mangaTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      mangaTitleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mangaTitle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      mangaTitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mangaTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      mangaTitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mangaTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      mangaTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mangaTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      mangaTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mangaTitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      mangaTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mangaTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      mangaTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mangaTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      progressPercentageEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'progressPercentage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      progressPercentageGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'progressPercentage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      progressPercentageLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'progressPercentage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      progressPercentageBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'progressPercentage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      totalPagesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalPages',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      totalPagesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalPages',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      totalPagesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalPages',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterFilterCondition>
      totalPagesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalPages',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ReadingHistoryQueryObject
    on QueryBuilder<ReadingHistory, ReadingHistory, QFilterCondition> {}

extension ReadingHistoryQueryLinks
    on QueryBuilder<ReadingHistory, ReadingHistory, QFilterCondition> {}

extension ReadingHistoryQuerySortBy
    on QueryBuilder<ReadingHistory, ReadingHistory, QSortBy> {
  QueryBuilder<ReadingHistory, ReadingHistory, QAfterSortBy> sortByChapterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterId', Sort.asc);
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterSortBy>
      sortByChapterIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterId', Sort.desc);
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterSortBy>
      sortByChapterTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterTitle', Sort.asc);
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterSortBy>
      sortByChapterTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterTitle', Sort.desc);
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterSortBy>
      sortByCurrentPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPage', Sort.asc);
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterSortBy>
      sortByCurrentPageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPage', Sort.desc);
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterSortBy>
      sortByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.asc);
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterSortBy>
      sortByIsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.desc);
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterSortBy>
      sortByLastReadAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadAt', Sort.asc);
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterSortBy>
      sortByLastReadAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadAt', Sort.desc);
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterSortBy> sortByMangaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaId', Sort.asc);
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterSortBy>
      sortByMangaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaId', Sort.desc);
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterSortBy>
      sortByMangaTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaTitle', Sort.asc);
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterSortBy>
      sortByMangaTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaTitle', Sort.desc);
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterSortBy>
      sortByProgressPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressPercentage', Sort.asc);
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterSortBy>
      sortByProgressPercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressPercentage', Sort.desc);
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterSortBy>
      sortByTotalPages() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPages', Sort.asc);
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterSortBy>
      sortByTotalPagesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPages', Sort.desc);
    });
  }
}

extension ReadingHistoryQuerySortThenBy
    on QueryBuilder<ReadingHistory, ReadingHistory, QSortThenBy> {
  QueryBuilder<ReadingHistory, ReadingHistory, QAfterSortBy> thenByChapterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterId', Sort.asc);
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterSortBy>
      thenByChapterIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterId', Sort.desc);
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterSortBy>
      thenByChapterTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterTitle', Sort.asc);
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterSortBy>
      thenByChapterTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterTitle', Sort.desc);
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterSortBy>
      thenByCurrentPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPage', Sort.asc);
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterSortBy>
      thenByCurrentPageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPage', Sort.desc);
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterSortBy>
      thenByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.asc);
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterSortBy>
      thenByIsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.desc);
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterSortBy>
      thenByLastReadAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadAt', Sort.asc);
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterSortBy>
      thenByLastReadAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadAt', Sort.desc);
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterSortBy> thenByMangaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaId', Sort.asc);
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterSortBy>
      thenByMangaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaId', Sort.desc);
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterSortBy>
      thenByMangaTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaTitle', Sort.asc);
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterSortBy>
      thenByMangaTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaTitle', Sort.desc);
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterSortBy>
      thenByProgressPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressPercentage', Sort.asc);
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterSortBy>
      thenByProgressPercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressPercentage', Sort.desc);
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterSortBy>
      thenByTotalPages() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPages', Sort.asc);
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QAfterSortBy>
      thenByTotalPagesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPages', Sort.desc);
    });
  }
}

extension ReadingHistoryQueryWhereDistinct
    on QueryBuilder<ReadingHistory, ReadingHistory, QDistinct> {
  QueryBuilder<ReadingHistory, ReadingHistory, QDistinct> distinctByChapterId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chapterId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QDistinct>
      distinctByChapterTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chapterTitle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QDistinct>
      distinctByCurrentPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentPage');
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QDistinct>
      distinctByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCompleted');
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QDistinct>
      distinctByLastReadAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastReadAt');
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QDistinct> distinctByMangaId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mangaId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QDistinct> distinctByMangaTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mangaTitle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QDistinct>
      distinctByProgressPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'progressPercentage');
    });
  }

  QueryBuilder<ReadingHistory, ReadingHistory, QDistinct>
      distinctByTotalPages() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalPages');
    });
  }
}

extension ReadingHistoryQueryProperty
    on QueryBuilder<ReadingHistory, ReadingHistory, QQueryProperty> {
  QueryBuilder<ReadingHistory, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ReadingHistory, String, QQueryOperations> chapterIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chapterId');
    });
  }

  QueryBuilder<ReadingHistory, String, QQueryOperations>
      chapterTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chapterTitle');
    });
  }

  QueryBuilder<ReadingHistory, int, QQueryOperations> currentPageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentPage');
    });
  }

  QueryBuilder<ReadingHistory, bool, QQueryOperations> isCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCompleted');
    });
  }

  QueryBuilder<ReadingHistory, DateTime, QQueryOperations>
      lastReadAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastReadAt');
    });
  }

  QueryBuilder<ReadingHistory, String, QQueryOperations> mangaIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mangaId');
    });
  }

  QueryBuilder<ReadingHistory, String, QQueryOperations> mangaTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mangaTitle');
    });
  }

  QueryBuilder<ReadingHistory, double, QQueryOperations>
      progressPercentageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'progressPercentage');
    });
  }

  QueryBuilder<ReadingHistory, int, QQueryOperations> totalPagesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalPages');
    });
  }
}
