From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Poor write performance with write-intent bitmap?
Date: Tue, 21 Apr 2009 12:00:23 -0400
Message-ID: <49EDED97.5010706@tmr.com>
References: <a5cd9eed0904201012o67503049laa50f4cb5b8d88de@mail.gmail.com>    <49ED096E.1000002@anonymous.org.uk>    <49ED16F7.3040906@anonymous.org.uk> <4081b80da35818efbc07723240f8ea36.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4081b80da35818efbc07723240f8ea36.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: John Robinson <john.robinson@anonymous.org.uk>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

NeilBrown wrote:
> On Tue, April 21, 2009 10:44 am, John Robinson wrote:
>   
>> That's more like it, and no more rattling. Can I tune settings for the
>> internal bitmap, or is this something which will have improved anyway
>> since my kernel (2.6.18-128.1.6.el5.centos.plusxen so essentially a
>> prominent North American Enterprise Linux vendor's EL5 codebase for
>> md/raid5)? I mean, I do want the bitmap, but I hadn't realised it was
>> quite so expensive (not that it matters much in this particular
>> application).
>>
>>     
>
> I don't think newer kernels make any different to bitmap related
> performance, though there might be some general raid5 improvements since
> then.
>
> There are two tunables for bitmaps.  Chuck size and delay (though the
> delay doesn't seem to be in the man page).
>   

It isn't in the man page, and
  mdadm --help | egrep 'bitmap|delay'
comes up empty as well. So then I looked at the strings:
  strings $(type -p mdadm) | less
and I not only found it, but found that you have a vast bunch of 
duplicate strings, including some which are saying the same thing but 
expressed in several ways. If I might quote my offspring, "That's ugly, 
dude!"

Anyway, setting "--delay N" (sec) does exactly what you predicted, not much.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc

"You are disgraced professional losers. And by the way, give us our money back."
    - Representative Earl Pomeroy,  Democrat of North Dakota
on the A.I.G. executives who were paid bonuses  after a federal bailout.


