From: Turbo Fredriksson <turbo@bayour.com>
Subject: Re: RAID-6 ...
Date: Mon, 17 Jan 2005 09:04:07 +0100
Message-ID: <877jmcwkg8.fsf@pumba.bayour.com>
References: <200501101713.j0AHDx922062@www.watkins-home.com>
	<Pine.LNX.4.56.0501121020490.21510@lion.drogon.net>
	<16869.55531.489452.193862@cse.unsw.edu.au>
	<Pine.LNX.4.56.0501130941190.21510@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0501130941190.21510@lion.drogon.net> (Gordon
 Henderson's message of "Sat, 15 Jan 2005 16:12:12 +0000 (GMT)")
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Gordon" == Gordon Henderson <gordon@drogon.net> writes:

    Gordon> On Thu, 13 Jan 2005, Neil Brown wrote:
    >> There is no current support for raid6 in any 2.4 kernel and I
    >> am not aware of anyone planning such support.  Assume it is 2.6
    >> only.

    Gordon> How "real-life" tested is RAID-6 so-far? Anyone using it
    Gordon> in anger on a production server?

I've been using it for a couple of months (3 or 4 if I'm not mistaken)
on my SPARC64 (Sun Blade 1000 - 2xSPARC III/750) with (four+two)*9Gb
disks which gives me 16Gb disks pace.

With this setup (I had a few 9Gb disks that I couldn't/wouldn't use for
anything else) four (4!) disks can fail without it matter...

Have worked flawlessly even though the disks are OLD - 'smartctl' shows
that almost all of the disks have had more than 28000 hours 'uptime'
(i.e. 'powered on'). That's more than 3 years (POWERED ON mind you!).


Granted, I've been 'fortunate' (?!) to have had NO disk crashes etc, but
I did simulate a few when I sat the system up and it worked just fine...

Kernel 2.6.8.1 (with a couple of patches to get it to boot/work on SPARC64).

If it works this great on a SPARC64 (with which the kernel have problems
with), then it should work just FINE on a ia32...

    Gordon> Can it be considered more or less stable than RAID-5?

For me (NOTE!!) I'd say "just as stable". But naturally this (should/could)
depend on the exact kernel version in use... If a kernel version works
this/that good, stick with it...

    Gordon> Should I stick to my RAID-5 on-top of RAID-1 pairs?

In theory, that would be "more secure/safe" since both RAID5 and RAID1 is
better tested, but...
-- 
Soviet genetic SEAL Team 6 FSF nitrate Honduras $400 million in gold
bullion Albanian Kennedy Ft. Meade DES fissionable Uzi quiche kibo
[See http://www.aclu.org/echelonwatch/index.html for more about this]
