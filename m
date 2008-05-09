From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: mdadm feature suggestion
Date: Fri, 09 May 2008 11:06:57 -0400
Message-ID: <48246891.7030501@tmr.com>
References: <481EF5A5.3030501@serverleih.de> <18463.50756.193011.129733@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18463.50756.193011.129733@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Denis Klimek <denis@serverleih.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Monday May 5, denis@serverleih.de wrote:
>   
>> Hello,
>>
>> I've written a "mdadm2sms", which sends me SMS to my mobilephone when 
>> something happens to raid.
>> Yesterday I've got a sms / also written into syslog (standard), that a 
>> rebuild has been started, just for data-checking. My suggestion is now, 
>> it is possible to add 3 more Events just for this DataCheck event? Like 
>> DataCheckStarted, CheckStarted, CheckedFinished and Check20-100 or 
>> something? Cause the problem is, you can't trigger a regulary 
>> mdadm-datacheck without using syslog. It would be very nice, when it 
>> would be possible to trigger a Datacheck with a event command.
>>
>>     
>
> I'm sorry, but I don't understand what you are asking for.
>
> When a data-check is run, it should generate events just like when a
> resync or recovery is run.  These will be passed to any --program that
> you give to mdadm --monitor.
> In that program you can differentiate between
> data-check/resync/recovery by looking in /proc/mdstat.
>
> Do you want the events to be different for the different types of
> 'resync' (check/sync/recover)??  So you can get an SMS on a resync
> start but not on a data-check start?  Is that it?
>
> I don't understand
>   "It would be very nice, when it would be possible to trigger a
>   Datacheck with a event command. "
> at all.  How would an event command trigger a Datacheck???
>   

I would handle this by configuring syslog to write to a fifo, then 
running a daemon to read the messages and send whatever SMS you like. I 
do this on my mail server and firewall systems, both do adaptive 
configuration of the iptables firewall based on behavior of connected hosts.

See syslog.conf, the "|" feature. My daemon is a perl script which just 
sucks on the fifo (see mkdev) for the information to process.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


