From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: [PATCH] md-cluster: avoid deadlock on MESSAGE lock resource
Date: Sat, 16 May 2015 15:58:41 -0500
Message-ID: <5557AF81.30304@suse.de>
References: <554CB5DB.4020305@cisco.com> <554CB6B1.3030206@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <554CB6B1.3030206@cisco.com>
Sender: linux-raid-owner@vger.kernel.org
To: Abhijit Bhopatkar <abhopatk@cisco.com>, linux-raid@vger.kernel.org, Lidong Zhong <lzhong@suse.com>
Cc: "Reese Faucette (rfaucett)" <rfaucett@cisco.com>
List-Id: linux-raid.ids



On 05/08/2015 08:14 AM, Abhijit Bhopatkar wrote:
> On 08/05/15 6:40 pm, Abhijit Bhopatkar wrote:
>>
>> Every receiver has CR lock on MESSAGE while processing the message. When
>> every receiver releases ACK lock and for some reason fails to grab EX on
>> MESSAGE resource in time, a waiting sender could queue an EX on MESSAGE
>> instead. Now when receiver queues its up convert request on MESSAGE it
>> will end up in a deadlock situation.
>>
>> Setting NOQUEUE flag on MESSAGE lock resource while grabbing the EX on
>> MESSAGE on sender will avoid this deadlock. If sender can not grab
>> MESSAGE lock immediately it should retry until the lock is granted.
>>
>> Signed-off-by: Abhijit Bhopatkar <abhopatk@cisco.com>
>> ---
>> This has been minimally tested on a three node cluster.
>>
>
> I have tested standard mdadm operations (create, assemble etc).
> What more testing would you want me to do on this before its considered
> ready?

I am not sure how using LKF_NOQUEUE will help in this situation here. 
LKF_NOQUEUE primarily means do not queue if you can't grant it right 
away. Besides, I don't like the idea of goto loop.

The sender can still creep in between the ack and the message locks. A 
situation would be where the "disrupting" sender is the lock owner of 
all the locks and hence will not have to pay communication costs and 
will manage to attain the locks faster.

Perhaps DLM_LKF_HEADQUEUE or DLM_LKF_NOORDER is what you are looking 
for, but that again is not the complete solution.

Another idea I could think of is for the sender to downconvert TOKEN to 
a shared lock such as CR  halfway in the communication (say after 
message CR), and all receivers take the TOKEN in CR mode and release it 
once the communication is finally over.

Regards,


>
> Regards,
> Abhijit
>
>>   drivers/md/md-cluster.c | 14 ++++++++++++--
>>   1 file changed, 12 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
>> index fcfc4b9..04ac309 100644
>> --- a/drivers/md/md-cluster.c
>> +++ b/drivers/md/md-cluster.c
>> @@ -512,7 +512,10 @@ static void unlock_comm(struct md_cluster_info *cinfo)
>>    * This function performs the actual sending of the message. This function is
>>    * usually called after performing the encompassing operation
>>    * The function:
>> - * 1. Grabs the message lockresource in EX mode
>> + * 1. Grabs the message lockresource in EX. Do not queue the request if not granted
>> +      immediately. This avoids deadlock with receivers when receivers try to
>> +      upconvert CR to EX of message lockresource. The thread will retry until the
>> +      request is granted.
>>    * 2. Copies the message to the message LVB
>>    * 3. Downconverts message lockresource to CR
>>    * 4. Upconverts ack lock resource from CR to EX. This forces the BAST on other nodes
>> @@ -526,12 +529,19 @@ static int __sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg)
>>   	int slot = cinfo->slot_number - 1;
>>
>>   	cmsg->slot = cpu_to_le32(slot);
>> -	/*get EX on Message*/
>> +
>> +	/* get EX on Message with noqueue flag */
>> +	cinfo->message_lockres->flags |= DLM_LKF_NOQUEUE;
>> +
>> +retry:
>>   	error = dlm_lock_sync(cinfo->message_lockres, DLM_LOCK_EX);
>>   	if (error) {
>> +		if (error == -EAGAIN)
>> +			goto retry;
>>   		pr_err("md-cluster: failed to get EX on MESSAGE (%d)\n", error);
>>   		goto failed_message;
>>   	}
>> +	cinfo->message_lockres->flags &= ~DLM_LKF_NOQUEUE;
>>
>>   	memcpy(cinfo->message_lockres->lksb.sb_lvbptr, (void *)cmsg,
>>   			sizeof(struct cluster_msg));
>> -- 2.1.0
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>

-- 
Goldwyn
