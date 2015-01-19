package com.tailor.entities

import org.springframework.transaction.annotation.Transactional;

import com.tailor.SecUser;

@Transactional
class TSMessageService {
	
    def serviceMethod() {

    }
	
	/**
	 * 发送通知信息-角色
	 * @param role 目标角色(TSRole)
	 * @param sender 发送者(String)
	 * @param msgHead 标题(String)
	 * @param msgBody 内容(String)
	 * @param msgLink 相关链接(String)
	 * @return
	 */
	def sendMessageToRole(TSRole role, String sender, String msgHead, String msgBody, String msgLink) {
		
		def users=SecUser.findAllByUserRole(role);
		users.each { user->
			sendMessageToUser(user, sender, msgHead, msgBody, msgLink);
		}
	}
	
	/**
	 * 发送通知信息－用户
	 * @param user
	 * @param sender
	 * @param msgHead
	 * @param msgBody
	 * @param msgLink
	 * @return
	 */
	def sendMessageToUser(SecUser user, String sender, String msgHead, String msgBody, String msgLink) {
		def message = new TSMessage(messageType:'system',
			messageSender: sender, messageOwner:user,
			messageHead:msgHead, messageBody: msgBody,
			messageLink: msgLink,
			messageDate:new Date(System.currentTimeMillis()));
		
		message?.save();
	}
	
	
}
