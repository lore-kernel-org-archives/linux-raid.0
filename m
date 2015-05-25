From: Abhijit Bhopatkar <abhopatk@cisco.com>
Subject: Re: [PATCH] md-cluster: avoid deadlock on MESSAGE lock resource
Date: Mon, 25 May 2015 19:56:02 +0530
Message-ID: <556330FA.1030200@cisco.com>
References: <554CB5DB.4020305@cisco.com> <554CB6B1.3030206@cisco.com> <5557AF81.30304@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5557AF81.30304@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-raid@vger.kernel.org, Lidong Zhong <lzhong@suse.com>
Cc: "Reese Faucette (rfaucett)" <rfaucett@cisco.com>
List-Id: linux-raid.ids

On 17/05/15 2:28 am, Goldwyn Rodrigues wrote:
> 
> 
> On 05/08/2015 08:14 AM, Abhijit Bhopatkar wrote:
>> On 08/05/15 6:40 pm, Abhijit Bhopatkar wrote:
>>>
>>> Every receiver has CR lock on MESSAGE while processing the message. When
>>> every receiver releases ACK lock and for some reason fails to grab EX on
>>> MESSAGE resource in time, a waiting sender could queue an EX on MESSAGE
>>> instead. Now when receiver queues its up convert request on MESSAGE it
>>> will end up in a deadlock situation.
>>>
>>> Setting NOQUEUE flag on MESSAGE lock resource while grabbing the EX on
>>> MESSAGE on sender will avoid this deadlock. If sender can not grab
>>> MESSAGE lock immediately it should retry until the lock is granted.
>>>
>>> Signed-off-by: Abhijit Bhopatkar <abhopatk@cisco.com>
>>> ---
>>> This has been minimally tested on a three node cluster.
>>>
>>
>> I have tested standard mdadm operations (create, assemble etc).
>> What more testing would you want me to do on this before its considered
>> ready?
> 
> I am not sure how using LKF_NOQUEUE will help in this situation here. LKF_NOQUEUE primarily means do not queue if you can't grant it right away. Besides, I don't like the idea of goto loop.
> 
> The sender can still creep in between the ack and the message locks. A situation would be where the "disrupting" sender is the lock owner of all the locks and hence will not have to pay communication costs and will manage to attain the locks faster.
> 
> Perhaps DLM_LKF_HEADQUEUE or DLM_LKF_NOORDER is what you are looking for, but that again is not the complete solution.
> 
> Another idea I could think of is for the sender to downconvert TOKEN to a shared lock such as CR  halfway in the communication (say after message CR), and all receivers take the TOKEN in CR mode and release it once the communication is finally over.
> 
> Regards,
> 
> 
I agree about the goto pollution and yes converting receivers to use DLM_LKF_HEADQUEUE will solve the problem gracefully. Will send the new patch shortly.

However I do not understand why this is incomplete solution. The "disruptive sender" as you have called it, is already "TOKEN" owner and otherwise it will compete for TOKEN lock as usual with other senders with equal priority. Not gaining any priority over others. The changes simply make sender stall for all _receivers_ to complete their serialization and wait till all receivers convert MESSAGE lock from CR to EX to NL, nothing else changes.

Regards,

>>
>> Regards,
>> Abhijit

<snip>
