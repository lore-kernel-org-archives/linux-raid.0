From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Time to  deprecate old RAID formats?
Date: Wed, 24 Oct 2007 16:22:08 -0400
Message-ID: <471FA970.6070209@tmr.com>
References: <18200.49267.763509.924873@stoffel.org>	 <Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>	 <18200.53593.687483.120827@stoffel.org>	 <1192810534.1666.68.camel@firewall.xsintricity.com>	 <471A0C02.4030407@msgid.tls.msk.ru> <18202.5687.672431.295590@stoffel.org>	 <471A47CC.1070508@msgid.tls.msk.ru>  <18205.2688.952701.567195@stoffel.org> <1193186569.10336.30.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1193186569.10336.30.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: John Stoffel <john@stoffel.org>, Michael Tokarev <mjt@tls.msk.ru>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Doug Ledford wrote:
> On Mon, 2007-10-22 at 16:39 -0400, John Stoffel wrote:
>
>   
>> I don't agree completely.  I think the superblock location is a key
>> issue, because if you have a superblock location which moves depending
>> the filesystem or LVM you use to look at the partition (or full disk)
>> then you need to be even more careful about how to poke at things.
>>     
>
> This is the heart of the matter.  When you consider that each file
> system and each volume management stack has a superblock, and they some
> store their superblocks at the end of devices and some at the beginning,
> and they can be stacked, then it becomes next to impossible to make sure
> a stacked setup is never recognized incorrectly under any circumstance.
> It might be possible if you use static device names, but our users
> *long* ago complained very loudly when adding a new disk or removing a
> bad disk caused their setup to fail to boot.  So, along came mount by
> label and auto scans for superblocks.  Once you do that, you *really*
> need all the superblocks at the same end of a device so when you stack
> things, it always works properly.
Let me be devil's advocate, I noted in another post that location might 
be raid level dependent. For raid-1 putting the superblock at the end 
allows the BIOS to treat a single partition as a bootable unit. For all 
other arrangements the end location puts the superblock where it is 
slightly more likely to be overwritten, and where it must be moved if 
the partition grows or whatever.

There really may be no "right" answer.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

