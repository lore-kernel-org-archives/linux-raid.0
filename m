From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: resync duration ?
Date: Thu, 28 May 2009 17:43:49 +0100
Message-ID: <4A1EBF45.1090402@anonymous.org.uk>
References: <9a9f58b3517ecbc3a076725c671f6cd1.squirrel@neil.brown.name>	<20090515050801951.MELG9927@cdptpa-omta04.mail.rr.com> <18957.58351.832772.646681@notabene.brown> <4A1177F2.30402@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A1177F2.30402@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 18/05/2009 16:00, Bill Davidsen wrote:
> Neil Brown wrote:
[...]
>> Maybe and option like
>>    mdadm --syncaction=check /dev/md0
>>
>> ??
> 
> That is a great idea, it puts the md administration in the mdadm program 
> (where it belongs) instead of counting on a script to do the right 
> thing. Well, if you do this at all, the other actions are probably 
> appropriate as well.

It would be nice if such a thing blocked until completion and reported 
the results of the sync action, instead of or as well as them going to 
the system log, so they can be emailed by cron or otherwise examined by 
the caller.

I know, I know, you accept patches :-) but my coding skills are way too 
rusty to attempt this.

Cheers,

John.

