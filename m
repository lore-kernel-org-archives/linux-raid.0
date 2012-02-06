From: Asdo <asdo@shiftmail.org>
Subject: Re: Some md/mdadm bugs
Date: Mon, 06 Feb 2012 19:47:33 +0100
Message-ID: <4F302045.2090300@shiftmail.org>
References: <4F2ADF45.4040103@shiftmail.org>
 <20120203081717.195bfec8@notabene.brown> <4F2B1519.5010500@shiftmail.org>
 <loom.20120206T175724-186@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <loom.20120206T175724-186@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Joel <jdy@cryregarder.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/06/12 17:59, Joel wrote:
> Asdo<asdo<at>  shiftmail.org>  writes:
>
>> Neil say:
>>> ACTION=="remove", RUN+="/sbin/mdadm -If $name"
>>>
>>> in /etc/udev/rules.d/something.rules
>>>
>>> will make that happen.
>> Oh great!
>>
>> Will use that.
>>
>> --incremental --fail ! I would never have thought of combining those.
> I don't think the -If is --incremental --fail.  It is --incremental --force.
> Doesn't incremental automagically add a device if it is new and remove a device
> if it is old?
>

No, it is really --incremental --fail :
it behaves like --incremental --fail, while --incremental --force is an 
illegal combination for mdadm (I just tried)

