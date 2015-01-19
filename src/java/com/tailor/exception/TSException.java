package com.tailor.exception;

import grails.validation.Validateable;

@Validateable
public class TSException extends Exception{

	public TSException(String message) {
		super(message);
	}
}
