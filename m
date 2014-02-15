From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID6 dead on the water after Controller failure
Date: Sat, 15 Feb 2014 10:12:49 -0500
Message-ID: <52FF83F1.3030904@turmel.org>
References: <7A417EAE-106E-4541-941F-1002696F8735@gmail.com> <52FE7E2D.8020308@turmel.org> <5269CCC7-A0A7-479E-9738-88C74CB19435@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5269CCC7-A0A7-479E-9738-88C74CB19435@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Florian Lampel <florian.lampel@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good morning Florian,

On 02/15/2014 07:31 AM, Florian Lampel wrote:
> Greetings,
> 
> first of all - thanks to Phil Turmel for pointing me in the right direction. I checked all the cables and true enough, the System SSD's cable's shielding was halfway peeled off.

Very good.

> Anyway, the current state is as follows:
> 
> *) The missing HDDs came up right after the reboot, and I had to use the "bootdegraded=true" kernel option.
> *) All 12 drives are functional.
> 
> Here is a link to the requested output of 
> 
> --- mdadm -E /dev/sd[abcd]1 ---
> --- for x in /dev/sd[a-z] ; do echo $x : ; smartctl -x $x ; done ----
> 
> as well as
> 
> ---- mdadm --examine /dev/sd[abcdefghijklmnop]1 ------
> 
> Link:
> h__p://pastebin.com/v6yzn3KX

Device order has changed, summary:

/dev/sda1: WD-WMC300595440 Device #4 @442
/dev/sdb1: WD-WMC300595880 Device #5 @442
/dev/sdc1: WD-WMC1T1521826 Device #6 @442
/dev/sdd1: WD-WMC300314126 spare
/dev/sde1: WD-WMC300595645 Device #8 @435
/dev/sdf1: WD-WMC300314217 Device #9 @435
/dev/sdg1: WD-WMC300595957 Device #10 @435
/dev/sdh1: WD-WMC300313432 Device #11 @435
/dev/sdj1: WD-WMC300312702 Device #0 @442
/dev/sdk1: WD-WMC300248734 Device #1 @442
/dev/sdl1: WD-WMC300314248 Device #2 @442
/dev/sdm1: WD-WMC300585843 Device #3 @442

and your SSD is now /dev/sdi.

> My findings:
> The Event count does differ, but not by much. As my next step, I would follow Phil Turmel's advice and reassemble the Array using the --force option, to be precise:
> 
> mdadm -Afv /dev/md0 /dev/sd[abcdefgjklm]1

Not quite.  What was 'h' is now 'd'.  Use:

mdadm -Afv /dev/md0 /dev/sd[abcefghjklm]1

> Could you please advise me wether this next step is all right to do now that we have new logs etc.?

Yes.  You may also need "mdadm --stop /dev/md0" first if your boot
process partially assembled the array already.

After assembly, your array will be single-degraded but fully functional.
 That would be a good time to backup any critical data that isn't
already in a backup.

Then you can add /dev/sdd1 back into the array and let it rebuild.

> Thanks in advance,
> Florian Lampel
> 
> PS: Thanks again to Phil for pointing out that --create would be madness.--

One more thing:  your drives report never having a self-test run.  You
should have a cron job that triggers a long background self-test on a
regular basis.  Weekly, perhaps.

Similarly, you should have a cron job trigger an occasional "check"
scrub on the array, too.  Not at the same time as the self-tests,
though.  (I understand some distributions have this already.)

HTH,

Phil
