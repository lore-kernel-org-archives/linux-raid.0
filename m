From: Roger Roglans <rroglans@gmail.com>
Subject: Trouble reassembling RAID10
Date: Mon, 20 Feb 2017 21:42:28 +0000
Message-ID: <CAPXQET=6v3NTeujqtq69KfzAv1gpeG8vGQPfwMxxOaECvFR4sg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hey new to the mailing list and fairly new to RAIDs in general. I ran
into an issue and was hoping someone could help.

Our server that runs a 14 drive RAID10 through a rocketraid 2470
controller refused to assemble. Our goal is not necessarily to recover
a working RAID, but to get as much data back as possible.

Maybe as a consequence of the assembly failure, upon shutting down the
server, it would get stuck in boot loops. So I'm currently running
Ubuntu 16.04.1 from a USB. I've determined that 2 of 14  disks are
faulty and have determined which ones they are.

Here is the output of a mdadm --examine call.

    ubuntu@ubuntu:~$ sudo mdadm --examine /dev/sd[c-p]1 | egrep
'Events | /dev/sd'
       Events : 21988
       Events : 21988
       Events : 21988
       Events : 21988
       Events : 21988
       Events : 21988
       Events : 21988
       Events : 21988
       Events : 21988
       Events : 21988
       Events : 21988
       Events : 560
       Events : 21944
       Events : 560

However, I keep running into an error:

    ubuntu@ubuntu:~$ sudo mdadm --assemble --verbose --force /dev/md0
/dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1 /dev/sdi1
/dev/sdj1 /dev/sdk1 /dev/sdl1 /dev/sdm1 /dev/sdn1 /dev/sdo1 /dev/sdp1
    mdadm: looking for devices for /dev/md0
    mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 0.
    mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 1.
    mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 2.
    mdadm: /dev/sdf1 is identified as a member of /dev/md0, slot 3.
    mdadm: /dev/sdg1 is identified as a member of /dev/md0, slot 4.
    mdadm: /dev/sdh1 is identified as a member of /dev/md0, slot 5.
    mdadm: /dev/sdi1 is identified as a member of /dev/md0, slot 6.
    mdadm: /dev/sdj1 is identified as a member of /dev/md0, slot 7.
    mdadm: /dev/sdk1 is identified as a member of /dev/md0, slot 8.
    mdadm: /dev/sdl1 is identified as a member of /dev/md0, slot 9.
    mdadm: /dev/sdm1 is identified as a member of /dev/md0, slot 10.
    mdadm: /dev/sdn1 is identified as a member of /dev/md0, slot 11.
    mdadm: /dev/sdo1 is identified as a member of /dev/md0, slot 12.
    mdadm: /dev/sdp1 is identified as a member of /dev/md0, slot 13.
    mdadm: added /dev/sdd1 to /dev/md0 as 1
    mdadm: added /dev/sde1 to /dev/md0 as 2
    mdadm: added /dev/sdf1 to /dev/md0 as 3
    mdadm: added /dev/sdg1 to /dev/md0 as 4
    mdadm: added /dev/sdh1 to /dev/md0 as 5
    mdadm: added /dev/sdi1 to /dev/md0 as 6
    mdadm: added /dev/sdj1 to /dev/md0 as 7
    mdadm: added /dev/sdk1 to /dev/md0 as 8
    mdadm: added /dev/sdl1 to /dev/md0 as 9
    mdadm: added /dev/sdm1 to /dev/md0 as 10
    mdadm: added /dev/sdn1 to /dev/md0 as 11 (possibly out of date)
    mdadm: added /dev/sdo1 to /dev/md0 as 12 (possibly out of date)
    mdadm: added /dev/sdp1 to /dev/md0 as 13 (possibly out of date)
    mdadm: added /dev/sdc1 to /dev/md0 as 0
    mdadm: /dev/md0 assembled from 11 drives - not enough to start the array.

and trying to add --run gives this error:

    ubuntu@ubuntu:~$ sudo mdadm --assemble --verbose --run --force
/dev/md1 /dev/sdc1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1 /dev/sdi1
/dev/sdj1 /dev/sdk1 /dev/sdl1 /dev/sdm1 /dev/sdo1
    mdadm: looking for devices for /dev/md1
    mdadm: /dev/sdc1 is identified as a member of /dev/md1, slot 0.
    mdadm: /dev/sde1 is identified as a member of /dev/md1, slot 2.
    mdadm: /dev/sdf1 is identified as a member of /dev/md1, slot 3.
    mdadm: /dev/sdg1 is identified as a member of /dev/md1, slot 4.
    mdadm: /dev/sdh1 is identified as a member of /dev/md1, slot 5.
    mdadm: /dev/sdi1 is identified as a member of /dev/md1, slot 6.
    mdadm: /dev/sdj1 is identified as a member of /dev/md1, slot 7.
    mdadm: /dev/sdk1 is identified as a member of /dev/md1, slot 8.
    mdadm: /dev/sdl1 is identified as a member of /dev/md1, slot 9.
    mdadm: /dev/sdm1 is identified as a member of /dev/md1, slot 10.
    mdadm: /dev/sdo1 is identified as a member of /dev/md1, slot 12.
    mdadm: no uptodate device for slot 2 of /dev/md1
    mdadm: added /dev/sde1 to /dev/md1 as 2
    mdadm: added /dev/sdf1 to /dev/md1 as 3
    mdadm: added /dev/sdg1 to /dev/md1 as 4
    mdadm: added /dev/sdh1 to /dev/md1 as 5
    mdadm: added /dev/sdi1 to /dev/md1 as 6
    mdadm: added /dev/sdj1 to /dev/md1 as 7
    mdadm: added /dev/sdk1 to /dev/md1 as 8
    mdadm: added /dev/sdl1 to /dev/md1 as 9
    mdadm: added /dev/sdm1 to /dev/md1 as 10
    mdadm: no uptodate device for slot 22 of /dev/md1
    mdadm: added /dev/sdo1 to /dev/md1 as 12 (possibly out of date)
    mdadm: no uptodate device for slot 26 of /dev/md1
    mdadm: added /dev/sdc1 to /dev/md1 as 0
    mdadm: failed to RUN_ARRAY /dev/md1: Input/output error
    mdadm: Not enough devices to start the array.

So it's clear that the last three drives are out of date. It's
possible that drives 11 and 13 were never really active, but since
they were only partners in a raid 1, the array was unaffected until
now. I'm hoping that if I can reassemble with the 12th drive, then I
will be able to recover most of the data. Does anyone know what I can
do about that? I've also tried without the "inactive" drives but it
still isn't assembling drive 12. I know that I can try using --run,
but I'm not sure if I'll lose data that way. I'm also hesitant to zero
the superblock because I've always heard it was a last resort option.

Note that because I'm running this off a USB the usual `cat
/proc/mdstat` doesn't return the previous array. Also, I don't know
the exact structure of the array (if I did this would be a lot
easier).

Thanks in advance for the help,
Roger
