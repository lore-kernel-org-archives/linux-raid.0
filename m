From: maarten van den Berg <maarten@ultratux.net>
Subject: Re: Problem with RAID-5 on SuSE 9.1 (cp hangs, high system load, cpu waits)
Date: Wed, 26 May 2004 23:21:36 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200405262321.36903.maarten@ultratux.net>
References: <S265614AbUEZPjm/20040526153943Z+292@vger.kernel.org> <20040526155142.M13344@liquid-nexus.net> <005701c44365$8d89c230$0201a8c0@windows>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <005701c44365$8d89c230$0201a8c0@windows>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday 26 May 2004 23:08, TJ Harrell wrote:
> > Oh and your motherboard is using a KT266A chipset - I personally won't
> touch > a VIA chipset since that whole PCI / Soundblaster fiasco (I still
> have
>
> > nightmares). AFAIK the KT266A has PCI issues which have some kind of
> > workaround in the Linux kernel, however it might be a factor in your
> situation.

I wasn't totally aware of these issues...  Is there any consensus on the newer 
VIA chipsets, like the KT400 and the KT600 ?  I have the KT600 here and have 
not seen issues with it, but it is not yet running raid, so...

Maarten

> I was about to say the same thing. Which Southbridge do you have?
> Particular VIA Southbridges have serious problems with transferring files.
> It was a peculiar problem; most cases I've read about said that the problem
> occurred when transferring files between the onboard controller and on
> add-on controller. You might try taking all drives off the built-in
> controllers and see if that helps the problem.

-- 
When I answered where I wanted to go today, they just hung up -- Unknown

