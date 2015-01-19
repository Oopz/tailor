package com.tailor.entities

import grails.plugins.springsecurity.Secured;

class TSPieceController {
	
	@Secured(['ROLE_PIECE','ROLE_SUPER'])
    def index() { }
	
	@Secured(['ROLE_PIECE','ROLE_SUPER'])
	def dataSaveStockIO() {
		def piece=TSPiece.get(params.long('logPiece'));
		
		TSPieceLog.withTransaction { status ->
			try{
				piece.pieceStock =  piece.pieceStock + (params.logType=='in' ? 1 : -1) * params.float('logWeight');
				piece.save();
				
				def pieceLog=new TSPieceLog();
				bindData(pieceLog, params, [exclude: ['logPiece']]);
				
				pieceLog.logPiece=piece;
				pieceLog.logDate=new Date(System.currentTimeMillis());
				pieceLog?.save();
	
				["out": [
					"state":"success",
					"data": piece
				]];
			}catch(Exception e) {
				status.setRollbackOnly();
	
				["out": [
					"state":"failure",
					"message": e.toString()
				]];
			
				throw e;
			}
		}
	}
	
	@Secured(['ROLE_PIECE','ROLE_SUPER'])
	def dataSavePieceInfo() {
		try {
			def piece=TSPiece.get(params.id) ?: new TSPiece();
			bindData(piece, params);//Reference: http://grails.org/doc/2.2.1/guide/single.html#dataBinding
			piece?.save();
			
			["out": [
				"state":"success",
				"data": piece
			]];
		}catch(e) {
			["out": [
				"state":"failure",
				"message": e.toString()
			]];
		
			throw e;
		}
	}
	
	@Secured(['ROLE_PIECE','ROLE_SUPER'])
	def dataDelPieceInfo() {
		try{
			def piece=TSPiece.get(params.id);
			piece?.entityDeleted=true;
			piece?.save();
			
			["out": [
				"state":"success",
				"data": piece
			]];
		}catch(e) {
			["out": [
				"state":"failure",
				"message": e.toString()
			]];
		
			throw e;
		}
	}
	
	@Secured(['ROLE_PIECE','ROLE_SUPER'])
	def dataListPieces() {
		def max = params.int('rows') ?: 10;
		def offset = ((params.int('page') ?: 1) - 1) * max;
		
		def criteria = TSPiece.createCriteria();
		def result = criteria.list(max: max, offset: offset) {
			and {
				eq('entityDeleted', false)
				
				ilike('pieceNumber', "%${params.pieceNumber}%")
				ilike('pieceColor', "%${params.pieceColor}%")
				ilike('pieceType', "%${params.pieceType}%")
				ilike('pieceMaterial', "%${params.pieceMaterial}%")
				ilike('pieceFactory', "%${params.pieceFactory}%")
			}
		};
	
		
		["out": [
			"rows": result,
			"total": result.totalCount
		]];
	}
	
	@Secured(['ROLE_PIECE','ROLE_SUPER'])
	def dataListPieceLogs() {
		def max = params.int('rows') ?: 10;
		def offset = ((params.int('page') ?: 1) - 1) * max;
		
		def criteria = TSPieceLog.createCriteria();
		def result = criteria.list(max: max, offset: offset) {
			and {
				eq('entityDeleted', false)
				logPiece {
					eq('id', params.id as long)
				}
			}
			order 'logDate', 'desc'
		};
	
		
		["out": [
			"rows": result,
			"total": result.totalCount
		]];
	}
}
	
