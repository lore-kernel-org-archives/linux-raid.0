From: Martin Hamrle <martin.hamrle@nangu.tv>
Subject: Re: sw raid5 hungs on resync and high IO load, 2.6.32.23
Date: Wed, 27 Oct 2010 12:48:13 +0200
Message-ID: <4CC8036D.5090605@nangu.tv>
References: <4CC7D635.6050000@nangu.tv> <20101027190117.5118fe0c@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101027190117.5118fe0c@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On 27.10.2010 10:01, Neil Brown wrote:
> On Wed, 27 Oct 2010 09:35:17 +0200
> Martin Hamrle<martin.hamrle@nangu.tv>  wrote:
>
>> Hi,
>>
>> I'm having this issue on several boxes with several configuration.
>> One of them is a box with 8 drives attached to ARC-1160 in pass through
>> mode and build sw raid5 from these drives. There is also one drive to OS.
>>
>> During resync or check and heavy IO load, process tscpd (tscpd is IO
>> load maker) hungs, the machine is still alive but there are many blocked
>> processes.
>> After tscpd hungs, IO load is generated only by resync. In traceback you
>> can see blocked processes (ps, htop cat) accessing tscpd cmdline in
>> proc. Some tscpd threads is blocked during writing files into fs on
>> raid5. Reading these files is also blocking, reading other files in
>> filesystem is fast as usual.  This state takes 110 minutes. After that
>> all blocked processes continue their work.
>>
>> I am not sure what is the reason of the end of the weird state. I think
>> the end was caused by starting copying kernel source into array.
>>
>> Note that this is first time when hung processes wake up I never wait so
>> long.
>>
>> I think that it is related to sw raid because I do not see this issue on
>> hw raid or on sw raid without resync.
>>
>> kern.log contains initial "INFO: task collectd:2577 blocked for more
>> than 120 seconds"
>>     and two dumps
>> echo w>  /proc/sysrq-trigger
>>
>> log is located http://files.nangu.tv/kernel/kern.log
>> Let me know if you need more info.
>>
> When I try to access your kern.log I get
>
> 403 - Forbidden
Sorry about that, it is fixed now

> Just include it in-line in the email.
>
> NeilBrown



