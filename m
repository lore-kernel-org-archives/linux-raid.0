From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: RAID5: failing an active component during spare rebuild - arrays hangs
Date: Sun, 26 Jun 2011 21:13:17 +0300
Message-ID: <BANLkTinijekK8Y6TTk6TYtYhv4Dn2YGQbA@mail.gmail.com>
References: <BANLkTikkeoCsr3-UBSPEDrYwh4jGSn=MaA@mail.gmail.com>
	<BANLkTinwr9UE_B+MSXfbE2nAv0wLrTvhXg@mail.gmail.com>
	<20110622125409.14428883@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110622125409.14428883@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Neil,
thank you for your response. Meanwhile I have moved to stock ubuntu
natty 11.04, but it still happens. I have a simple script that
reproduces the issue for me in less than 1 minute.
System details:
Linux ubuntu 2.6.38-8-server #42-Ubuntu SMP Mon Apr 11 03:49:04 UTC
2011 x86_64 x86_64 x86_64 GNU/Linux

Here is the script:
##################################
#!/bin/bash

while true
do
	mdadm --create /dev/md1123 --raid-devices=3D3 --level=3D5
--bitmap=3Dinternal --name=3D1123 --run --auto=3Dmd --metadata=3D1.2
--homehost=3Dalex --verbose /dev/sda /dev/sdb /dev/sdc
	sleep 6
	mdadm --manage /dev/md1123 --fail /dev/sda
	sleep 1
	if mdadm --stop /dev/md1123
	then
		true
	else
		break
	fi
done
#####################################

And here is the output of one run. At the end of the output, the
--stop command fails and from that point I am unable to do anything
with the array, other than rebooting the machine.

root@ubuntu:/mnt/work/alex# ./repro.sh
mdadm: layout defaults to left-symmetric
mdadm: chunk size defaults to 512K
mdadm: layout defaults to left-symmetric
mdadm: /dev/sda appears to be part of a raid array:
    level=3Draid5 devices=3D3 ctime=3DSun Jun 26 20:55:54 2011
mdadm: layout defaults to left-symmetric
mdadm: /dev/sdb appears to be part of a raid array:
    level=3Draid5 devices=3D3 ctime=3DSun Jun 26 20:55:54 2011
mdadm: layout defaults to left-symmetric
mdadm: /dev/sdc appears to be part of a raid array:
    level=3Draid5 devices=3D3 ctime=3DSun Jun 26 20:55:54 2011
mdadm: size set to 20969984K
mdadm: creation continuing despite oddities due to --run
mdadm: array /dev/md1123 started.
mdadm: set /dev/sda faulty in /dev/md1123
mdadm: stopped /dev/md1123
mdadm: layout defaults to left-symmetric
mdadm: chunk size defaults to 512K
mdadm: layout defaults to left-symmetric
mdadm: /dev/sda appears to be part of a raid array:
    level=3Draid5 devices=3D3 ctime=3DSun Jun 26 20:57:45 2011
mdadm: layout defaults to left-symmetric
mdadm: /dev/sdb appears to be part of a raid array:
    level=3Draid5 devices=3D3 ctime=3DSun Jun 26 20:57:45 2011
mdadm: layout defaults to left-symmetric
mdadm: /dev/sdc appears to be part of a raid array:
    level=3Draid5 devices=3D3 ctime=3DSun Jun 26 20:57:45 2011
mdadm: size set to 20969984K
mdadm: creation continuing despite oddities due to --run
mdadm: array /dev/md1123 started.
mdadm: set /dev/sda faulty in /dev/md1123
mdadm: stopped /dev/md1123
mdadm: layout defaults to left-symmetric
mdadm: chunk size defaults to 512K
mdadm: layout defaults to left-symmetric
mdadm: /dev/sda appears to be part of a raid array:
    level=3Draid5 devices=3D3 ctime=3DSun Jun 26 20:57:52 2011
mdadm: layout defaults to left-symmetric
mdadm: /dev/sdb appears to be part of a raid array:
    level=3Draid5 devices=3D3 ctime=3DSun Jun 26 20:57:52 2011
mdadm: layout defaults to left-symmetric
mdadm: /dev/sdc appears to be part of a raid array:
    level=3Draid5 devices=3D3 ctime=3DSun Jun 26 20:57:52 2011
mdadm: size set to 20969984K
mdadm: creation continuing despite oddities due to --run
mdadm: array /dev/md1123 started.
mdadm: set /dev/sda faulty in /dev/md1123
mdadm: failed to stop array /dev/md1123: Device or resource busy
Perhaps a running process, mounted filesystem or active volume group?

At this point mdadm --detail produces:

/dev/md1123:
        Version : 1.2
  Creation Time : Sun Jun 26 20:57:59 2011
     Raid Level : raid5
     Array Size : 41939968 (40.00 GiB 42.95 GB)
  Used Dev Size : 20969984 (20.00 GiB 21.47 GB)
   Raid Devices : 3
  Total Devices : 3
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Sun Jun 26 20:58:23 2011
          State : active, FAILED
 Active Devices : 1
Working Devices : 2
 Failed Devices : 1
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 512K

           Name : alex:1123
           UUID : cd564563:94fecf52:5b3492d4:4530ecbc
         Events : 4

    Number   Major   Minor   RaidDevice State
       0       8        0        0      faulty spare rebuilding   /dev/=
sda
       1       8       16        1      active sync   /dev/sdb
       3       8       32        2      spare rebuilding   /dev/sdc

and the faulty device is not kicked out from the array, as I would expe=
ct.

Thanks,
  Alex.

On Wed, Jun 22, 2011 at 5:54 AM, NeilBrown <neilb@suse.de> wrote:
>
> On Sun, 5 Jun 2011 22:41:55 +0300 Alexander Lyakas <alex.bolshoy@gmai=
l.com>
> wrote:
>
> > Hello everybody,
> > I am testing a scenario, in which I create a RAID5 with three devic=
es:
> > /dev/sd{a,b,c}. Since I don't supply --force to mdadm during creati=
on,
> > it treats the array as degraded and starts rebuilding the sdc as a
> > spare. This is as documented.
> >
> > Then I do --fail on /dev/sda. I understand that at this point my da=
ta
> > is gone, but I think should still be able to tear down the array.
> >
> > Sometimes I see that /dev/sda is kicked from the array as faulty, a=
nd
> > /dev/sdc is also removed and marked as a spare. Then I am able to t=
ear
> > down the array.
> >
> > But sometimes, it looks like the system hits some kind of a deadloc=
k.
>
> I cannot reproduce this, either on current mainline or 2.6.38. =A0I d=
idn't try
> the particular Ubuntu kernel that you mentioned as I don't have any U=
buntu
> machines.
> It is unlikely that Ubuntu have broken something, but not impossible.=
=2E. are
> you able to compile a kernel.org kernel (preferably 2.6.39) and see i=
f you
> can reproduce.
>
> Also, can you provide a simple script that will trigger the bug relia=
bly for
> you.
>
> I did:
>
> while : ; do mdadm -CR /dev/md0 -l5 -n3 /dev/sd[abc] ; sleep 5; mdadm=
 /dev/md0 -f /dev/sda ; mdadm -Ss ; echo ; echo; done
>
> and it has no problems at all.
>
> Certainly a deadlock shouldn't be happening...
>
> =A0From the stack trace you get it looks like it is probably hanging =
at
>
> =A0 =A0 =A0 =A0wait_event(mddev->recovery_wait, !atomic_read(&mddev->=
recovery_active));
>
> which suggests that so resync request started and didn't complete. =A0=
I've
> never seen a hang there before.
>
> NeilBrown
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
