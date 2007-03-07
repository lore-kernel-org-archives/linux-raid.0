From: berk walker <berk@panix.com>
Subject: Re: detecting/correcting _slightly_ flaky disks
Date: Wed, 07 Mar 2007 08:57:31 -0500
Message-ID: <45EEC4CB.1070804@panix.com>
References: <bb145bd20703040322g1e5e8784i93a933c0c61b43f6@mail.gmail.com> <17898.45673.573800.56474@notabene.brown> <45EB3867.8050907@eyal.emu.id.au> <17899.18568.523543.478792@notabene.brown> <45EBCA83.40106@eyal.emu.id.au> <45EC2F89.2070703@pobox.com> <Pine.LNX.4.64.0703051008190.14012@p34.internal.lan> <45EC4CFD.3050106@pobox.com> <45EE03E2.5000309@tmr.com> <45EE1775.7020906@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45EE1775.7020906@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: mjstumpf@pobox.com
Cc: Bill Davidsen <davidsen@tmr.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Michael Stumpf wrote:
> Bill Davidsen wrote:
>> Michael Stumpf wrote:
>>> This is the drive I think is most suspect.  What isn't obvious, 
>>> because it isn't listed in the self test log, is between #1 and #2 
>>> there was an aborted, hung test.   The #4 short test that was 
>>> aborted was also a hung test that I eventually, manually 
>>> aborted--heard clicking from drives at that time, can't swear it was 
>>> from this drive though.
>>>
>>> Not sure I fully understand the nuances of this report.  If anything 
>>> jumps out at you, I'd appreciate a tip on how you read it.  (to me, 
>>> looks mostly healthy)
>>>
>> For what it's worth, if you are getting hung tests, either your drive 
>> or power supply should be redeployed as a paperweight. My opinion...
>>
> I don't disagree but I'd like to find something more concrete or 
> repeatable, especially given that these give an audible click when 
> failing.  The problem I'm having is that I can't nail down precisely 
> where the problem is, although your suggestion makes a lot of sense.
>
> After running Justin's suggested badblocks test, I'm kind-of-disturbed 
> to see that all these drives are passing with flying colors.
>
> Firmware issue?  WD had it in the past.
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
One nice thing, if your cables are OK, and your power is OK, then you 
can trash the electronics and transplant from a similar drive with bad 
sectors.
-

"load head
seek spindle
unload head"
is not a nice thing for the hardware.

b-

