From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: resync duration ?
Date: Mon, 18 May 2009 11:00:02 -0400
Message-ID: <4A1177F2.30402@tmr.com>
References: <9a9f58b3517ecbc3a076725c671f6cd1.squirrel@neil.brown.name>	<20090515050801951.MELG9927@cdptpa-omta04.mail.rr.com> <18957.58351.832772.646681@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18957.58351.832772.646681@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: lrhorer@satx.rr.com, 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:
> On Friday May 15, lrhorer@satx.rr.com wrote:
>   
>>>   echo check > /sys/block/mdX/md/sync_action.
>>>
>>> or "echo repair" to get it to fix anything it finds.
>>>       
>> Thanks.  Those are pretty easy, but it would be nice if they were in the MAN
>> page.  Better yet, have you considered adding both as command line options
>> for mdadm?
>>     
>
> Considered, yes.  But they are very low on my priority list.
> I accept patches.
> Maybe and option like
>    mdadm --syncaction=check /dev/md0
>
> ??
>   

That is a great idea, it puts the md administration in the mdadm program 
(where it belongs) instead of counting on a script to do the right 
thing. Well, if you do this at all, the other actions are probably 
appropriate as well.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc

"You are disgraced professional losers. And by the way, give us our money back."
    - Representative Earl Pomeroy,  Democrat of North Dakota
on the A.I.G. executives who were paid bonuses  after a federal bailout.


