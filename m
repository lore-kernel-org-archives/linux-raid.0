From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Starting RAID 5
Date: Mon, 18 May 2009 11:13:17 -0400
Message-ID: <4A117B0D.5040804@tmr.com>
References: <20090515021521914.KSFT13751@cdptpa-omta01.mail.rr.com> <adb53d3552334dd6c949c4c029ae7135.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <adb53d3552334dd6c949c4c029ae7135.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: lrhorer@satx.rr.com, 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

NeilBrown wrote:
> On Fri, May 15, 2009 12:15 pm, Leslie Rhorer wrote:
>   
>> OK, I've torn down the LVM backup arraqy and am rebuilding it as a RAID 5.
>> I've had problems with this before, and I'm having them, again.  I created
>> the array with:
>>
>> mdadm --create /dev/md0 --raid-devices=7 --metadata=1.2 --chunk=256
>> --level=5 /dev/sd[a-g]
>>
>> whereupon it creates the array and then immediately removes /dev/sdg and
>> makes it a spare.  I think I may have read where this is normal behavior.
>>     
>
> Correct. Maybe you read it in the mdadm man page.
>
>
>   
While I know about that, I have never understood why that was desirable, 
or even acceptable, behavior. The array sits half created doing nothing 
until the system tries to use the array, at which time it's slow because 
it's finally getting around to actually getting the array into some 
sensible state. Is there some benefit to wasting time so the array can 
be slow when needed?
>> I can't get it to do an initial resync or promote the spare, however.
>>     
>
> So it doesn't start recovery straight away? That is odd...
> Maybe it is in read-auto mode.  I should probably get mdadm to poke
> it out of that.
>
> If it is just start creating the filesystem or whatever you want to
> do, that will prod it into action.
>
> If not (check /proc/mdstat), what kernel log messages are them from the
> time when you created the array.
>
> NeilBrown
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   


-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc

"You are disgraced professional losers. And by the way, give us our money back."
    - Representative Earl Pomeroy,  Democrat of North Dakota
on the A.I.G. executives who were paid bonuses  after a federal bailout.


