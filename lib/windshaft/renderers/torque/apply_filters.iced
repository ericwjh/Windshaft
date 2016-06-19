CategoryFilter = require 'camshaft/lib/filter/category.js'
rangeFilter = require 'camshaft/lib/filter/range.js'

module.exports = (layer_sql, filters)->
	# console.log('layer_sql, filters', layer_sql, JSON.stringify(filters))
	return layer_sql unless filters
	for key, filter of filters
		column = filter.column
		params = filter.params
		switch filter.type
			when 'range'
				if params.column_type is 'date'
					column = "date_part('epoch', #{column})"

				if Number.isFinite(params.min) and Number.isFinite(params.max)
					sql = "select * from (#{layer_sql}) patch_filter where #{column} between #{params.min} and #{params.max}"
				else if Number.isFinite(params.min)
					sql = "select * from (#{layer_sql}) patch_filter where #{column} >= #{params.min}"
				else
					sql = "select * from (#{layer_sql}) patch_filter where #{column} <= #{params.max}"

			when 'category'
				sql = new CategoryFilter(column, params).sql(layer_sql)

			else
				sql = layer_sql

	sql
