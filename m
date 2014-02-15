From: Florian Lampel <florian.lampel@gmail.com>
Subject: Re: RAID6 dead on the water after Controller failure
Date: Sat, 15 Feb 2014 19:52:27 +0100
Message-ID: <8D85C29C-685E-457A-BA2A-5F9069122D88@gmail.com>
References: <7A417EAE-106E-4541-941F-1002696F8735@gmail.com> <52FE7E2D.8020308@turmel.org> <5269CCC7-A0A7-479E-9738-88C74CB19435@gmail.com> <52FF83F1.3030904@turmel.org>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52FF83F1.3030904@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am 15.02.2014 um 16:12 schrieb Phil Turmel <philip@turmel.org>:

> Good morning Florian,

Good Evening - it's 19:37 here in Austria.

> Device order has changed, summary:
> 
> /dev/sda1: WD-WMC300595440 Device #4 @442
> /dev/sdb1: WD-WMC300595880 Device #5 @442
> /dev/sdc1: WD-WMC1T1521826 Device #6 @442
> /dev/sdd1: WD-WMC300314126 spare
> /dev/sde1: WD-WMC300595645 Device #8 @435
> /dev/sdf1: WD-WMC300314217 Device #9 @435
> /dev/sdg1: WD-WMC300595957 Device #10 @435
> /dev/sdh1: WD-WMC300313432 Device #11 @435
> /dev/sdj1: WD-WMC300312702 Device #0 @442
> /dev/sdk1: WD-WMC300248734 Device #1 @442
> /dev/sdl1: WD-WMC300314248 Device #2 @442
> /dev/sdm1: WD-WMC300585843 Device #3 @442
> 
> and your SSD is now /dev/sdi.

Thank you again for going through all those logs and helping me. 

> Not quite.  What was 'h' is now 'd'.  Use:
> 
> mdadm -Afv /dev/md0 /dev/sd[abcefghjklm]1

Well, that did not went as well as I had hoped. Here is what happened:

root@Lserve:~# mdadm --stop /dev/md0
mdadm: stopped /dev/md0
root@Lserve:~# mdadm -Afv /dev/md0 /dev/sd[abcefghjklm]1
mdadm: looking for devices for /dev/md0
mdadm: /dev/sda1 is identified as a member of /dev/md0, slot 4.
mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 5.
mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 6.
mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 8.
mdadm: /dev/sdf1 is identified as a member of /dev/md0, slot 9.
mdadm: /dev/sdg1 is identified as a member of /dev/md0, slot 10.
mdadm: /dev/sdh1 is identified as a member of /dev/md0, slot 11.
mdadm: /dev/sdj1 is identified as a member of /dev/md0, slot 0.
mdadm: /dev/sdk1 is identified as a member of /dev/md0, slot 1.
mdadm: /dev/sdl1 is identified as a member of /dev/md0, slot 2.
mdadm: /dev/sdm1 is identified as a member of /dev/md0, slot 3.
mdadm: forcing event count in /dev/sde1(8) from 435 upto 442
mdadm: forcing event count in /dev/sdf1(9) from 435 upto 442
mdadm: forcing event count in /dev/sdg1(10) from 435 upto 442
mdadm: forcing event count in /dev/sdh1(11) from 435 upto 442
mdadm: clearing FAULTY flag for device 3 in /dev/md0 for /dev/sde1
mdadm: clearing FAULTY flag for device 4 in /dev/md0 for /dev/sdf1
mdadm: clearing FAULTY flag for device 5 in /dev/md0 for /dev/sdg1
mdadm: clearing FAULTY flag for device 6 in /dev/md0 for /dev/sdh1
mdadm: Marking array /dev/md0 as 'clean'
mdadm: added /dev/sdk1 to /dev/md0 as 1
mdadm: added /dev/sdl1 to /dev/md0 as 2
mdadm: added /dev/sdm1 to /dev/md0 as 3
mdadm: added /dev/sda1 to /dev/md0 as 4
mdadm: added /dev/sdb1 to /dev/md0 as 5
mdadm: added /dev/sdc1 to /dev/md0 as 6
mdadm: no uptodate device for slot 7 of /dev/md0
mdadm: added /dev/sde1 to /dev/md0 as 8
mdadm: added /dev/sdf1 to /dev/md0 as 9
mdadm: added /dev/sdg1 to /dev/md0 as 10
mdadm: added /dev/sdh1 to /dev/md0 as 11
mdadm: added /dev/sdj1 to /dev/md0 as 0
mdadm: /dev/md0 assembled from 11 drives - not enough to start the array.

AND:

cat /proc/mdstat:

cat /proc/mdstat 
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
md0 : inactive sdj1[0](S) sdh1[11](S) sdg1[10](S) sdf1[9](S) sde1[8](S) sdc1[6](S) sdb1[5](S) sda1[4](S) sdm1[3](S) sdl1[2](S) sdk1[1](S)
      21488646696 blocks super 1.0
       
unused devices: <none>

Seems like every HDD got marked as a spare. Why would mdadm do this, and how can I convince mdadm that they are not spares?


> That would be a good time to backup any critical data that isn't
> already in a backup.

Crashplan had about 30% before it happened. 20TB is a lot to upload.

> One more thing:  your drives report never having a self-test run.  You
> should have a cron job that triggers a long background self-test on a
> regular basis.  Weekly, perhaps.
> 
> Similarly, you should have a cron job trigger an occasional "check"
> scrub on the array, too.  Not at the same time as the self-tests,
> though.  (I understand some distributions have this already.)

I will certainly do so in the future.

Thanks again everyone, and I hope this will all end well.

Thanks,
Florian Lampel

