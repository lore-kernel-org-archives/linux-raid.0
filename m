From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: nonzero mismatch_cnt with no earlier error
Date: Sat, 24 Feb 2007 06:12:28 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0702240611320.31123@p34.internal.lan>
References: <45DF859B.2050108@eyal.emu.id.au>  <45DFE217.3020703@eyal.emu.id.au>
  <Pine.LNX.4.64.0702240413570.21012@p34.internal.lan>
 <Pine.LNX.4.64.0702240437070.21012@p34.internal.lan> <1172310529.4431.9.camel@merlin>
 <45E01D01.4080205@tls.msk.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45E01D01.4080205@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Jason Rainforest <l3mming@iinet.net.au>, Eyal Lebedinsky <eyal@eyal.emu.id.au>, linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On Sat, 24 Feb 2007, Michael Tokarev wrote:

> Jason Rainforest wrote:
>> I tried doing a check, found a mismatch_cnt of 8 (7*250Gb SW RAID5,
>> multiple controllers on Linux 2.6.19.2, SMP x86-64 on Athlon64 X2 4200
>> +).
>>
>> I then ordered a resync. The mismatch_cnt returned to 0 at the start of
>
> As pointed out later it was repair, not resync.
>
>> the resync, but around the same time that it went up to 8 with the
>> check, it went up to 8 in the resync. After the resync, it still is 8. I
>> haven't ordered a check since the resync completed.
>
> As far as I understand, repair will do the same as check does, but ALSO
> will try to fix the problems found.  So the number in mismatch_cnt after
> a repair will indicate the amount of mismatches found _and fixed_
>
> /mjt
>

That is what I thought too (I will have to wait until I get another 
mismatch to verify), but FYI--

Yesterday I had 512 mismatches for my swap partition (RAID1) after I ran 
the check.

I ran repair.

I catted the mismatch_cnt again, still 512.

I re-ran the check, back to 0.

Justin.
