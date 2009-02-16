From: =?ISO-8859-1?B?UultaQ==?= PALANCHER <remi.palancher@inria.fr>
Subject: mdadm RAID5 re-assemble issue
Date: Mon, 16 Feb 2009 13:34:50 +0100
Message-ID: <20090216133450.5c700c09@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi there,

I've been a happy and successful mdadm user for a while now, but
unfortunately, I met a problem recently.

I use mdadm to manage a RAID5 array with 5 disks and 1 spare. The
devices in the array are sda5, sdb1, sdc1, sdd1, sde1 and sdf1. Before
things start to go wrong, sdb1 device was the spare and the other
devices were active in the array. Here is this configuration as shown
by the logs:

[85054.372171] RAID5 conf printout:
[85054.372175]  --- rd:5 wd:4
[85054.372177]  disk 0, o:1, dev:sdc1
[85054.372179]  disk 1, o:1, dev:sde1
[85054.372181]  disk 2, o:1, dev:sda5
[85054.372183]  disk 3, o:1, dev:sdd1
[85054.372185]  disk 4, o:0, dev:sdf1

Last thursday, a problem occured on sdf1 and mdadm started recovering
the array with sdb1 as expected. But sdb1 have had a problem too during
the recovery process, but the array continued to run properly with the
last good 4 devices. I can attach logs if needed. Actually, sdb1 was
defective, and I removed it physically from the server.

But here is the output when I try to reassemble the array with the
remaining devices:
# mdadm --assemble /dev/md0 --force \
--verbose /dev/sda5 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
mdadm: looking for devices for /dev/md0
mdadm: /dev/sda5 is identified as a member of /dev/md0, slot 5.
mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 0.
mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 3.
mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 1.
mdadm: /dev/sde1 is identified as a member of /dev/md0, slot -1.
mdadm: added /dev/sdd1 to /dev/md0 as 1
mdadm: no uptodate device for slot 2 of /dev/md0
mdadm: added /dev/sdc1 to /dev/md0 as 3
mdadm: no uptodate device for slot 4 of /dev/md0
mdadm: added /dev/sda5 to /dev/md0 as 5
mdadm: added /dev/sde1 to /dev/md0 as -1
mdadm: added /dev/sdb1 to /dev/md0 as 0
mdadm: /dev/md0 assembled from 3 drives and 2 spares - not enough to
start the array.

I can understand why sde1 (previously sdf1) cannot take an active slot,
but why does sda5 wanna take slot5 instead of slot2, as it was
previously?

Is there any way to force it?
Do I have to deal with mkdir or mdadm --create --assume-clean to
recover my data?

Regards,
--
R=E9mi PALANCHER
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
