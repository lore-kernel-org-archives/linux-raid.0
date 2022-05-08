Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1E2AC433EF
	for <linux-raid@archiver.kernel.org>; Sun,  8 May 2022 13:18:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233445AbiEHNWZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 8 May 2022 09:22:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233354AbiEHNWY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 8 May 2022 09:22:24 -0400
Received: from postoffice.wmawater.com.au (postoffice.wmawater.com.au [61.69.178.123])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 2BF2438BE
        for <linux-raid@vger.kernel.org>; Sun,  8 May 2022 06:18:32 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by postoffice.wmawater.com.au (Postfix) with ESMTP id 61B8F19F372
        for <linux-raid@vger.kernel.org>; Sun,  8 May 2022 23:18:32 +1000 (AEST)
Authentication-Results: postoffice.wmawater.com.au (amavisd-new);
        dkim=pass (1024-bit key) header.d=wmawater.com.au
Received: from postoffice.wmawater.com.au ([127.0.0.1])
        by localhost (postoffice.wmawater.com.au [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id qvsu7j-I9KCW for <linux-raid@vger.kernel.org>;
        Sun,  8 May 2022 23:18:32 +1000 (AEST)
Received: from localhost (localhost [127.0.0.1])
        by postoffice.wmawater.com.au (Postfix) with ESMTP id 3628919F373
        for <linux-raid@vger.kernel.org>; Sun,  8 May 2022 23:18:32 +1000 (AEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 postoffice.wmawater.com.au 3628919F373
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wmawater.com.au;
        s=1D92CC64-C1F9-11E4-96FC-2C1EC0F5F97B; t=1652015912;
        bh=QYM4NkCxjCsTgFBoHp++bou1PCRtH3dk1DvlsCpprSM=;
        h=From:To:Date:Message-ID:MIME-Version;
        b=jFG2AWUFxatwxbHAirecdg97A8Y9wWgLR8o2PHsABUk6W9BN4UI7GL+bylaMQOnkv
         HllgVV6qak+lpu9aqexG+Rdibh6VbnM18KP2Tu6v0HX7aI2baNLea8GPwKNo3Qf9KR
         fQ09Gsp59K37GeuHqe0qBwApbB2MvtoQtk4IksZ0=
X-Virus-Scanned: amavisd-new at wmawater.com.au
Received: from postoffice.wmawater.com.au ([127.0.0.1])
        by localhost (postoffice.wmawater.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id X-S64WqbTXIR for <linux-raid@vger.kernel.org>;
        Sun,  8 May 2022 23:18:32 +1000 (AEST)
Received: from postoffice.wmawater.com.au (postoffice.wmawater.com.au [61.69.178.123])
        by postoffice.wmawater.com.au (Postfix) with ESMTP id 17FEE19F372
        for <linux-raid@vger.kernel.org>; Sun,  8 May 2022 23:18:32 +1000 (AEST)
Reply-To: "Bob Brand" <brand@wmawater.com.au>
From:   Bob Brand <brand@wmawater.com.au>
To:     <linux-raid@vger.kernel.org>
Subject: Failed adadm RAID array after aborted Grown operation
Thread-Topic: Failed adadm RAID array after aborted Grown operation
Date:   Sun, 8 May 2022 23:18:32 +1000 (AEST)
Message-ID: <00ae01d862de$1d336980$579a3c80$@wmawater.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="iso-8859-1"
X-Mailer: Microsoft Outlook 16.0
X-Mailer: Zimbra 8.8.15_GA_3894 (Zimbra-ZCO/9.0.0.1903 (10.0.19044  en-AU) P3210 T3bbc R1749)
Content-Language: en-au
Thread-Index: Adhin4la3i3k1n/cS2qxPdSjE7kZ+w==
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

I=92m somewhat new to Linux and mdadm although I=92ve certainly learnt a =
lot
over the last 24 hours.

I have a SuperMicro server running CentOS 7=A0 (3.10.0-1160.11.1.e17.x86_=
64)
with version 4.1 =96 2018-10-01 of mdadm with that was happily running wi=
th
30 8TB disk in a RAID6 configuration.=A0 (It also has boot and root on a
RAID1 array =96 the RAID6 array being solely for data.)=A0 It was however
starting to run out of space and I investigated adding more drives to the
array (it can hold a total of 45 drives).

Since this device is no longer under support, obtaining the same drives a=
s
it already contained wasn=92t an option and the supplier couldn=92t guara=
ntee
that they could supply compatible drives.=A0 We did come to an arrangemen=
t
where I would try one drive and, if it didn=92t work, I could return any
unopened units.

I spent ages ensuring that the ones he=92d suggested were as compatible a=
s
possible and I based the specs of the existing drives off the invoice for
the entire system.=A0 This turned out to be a mistake as the invoice stat=
ed
they were 512e drives but, as I discovered after the new drives had
arrived and I was doing a final check the existing =A0were actually 4096k
drives.=A0 Of course the new drives were 512e.=A0 Bother! After a lot mor=
e
reading I found out that it might be possible to reformat the new drives
from 512e to 4096k using sg_format.

I installed the test drive and proceeded to see if it was possible to
format them to 4096k using the command sg_format =96size=3D4096 /dev/sd<x=
>.=A0
All was proceeding smoothly when my ssh session terminated due a faulty
docking station killing my Ethernet connection.

So I logged onto the console and restarted the sg_format which completed
OK, sort of =96 it did convert the disk to 4096k but it did throw an I/O
error or two but they didn=92t seem too concerning and I figured, if ther=
e
was a problem, it would show up in the next couple of steps.=A0 I=92ve si=
nce
discovered the dmesg log and that indicated that there were significantly
more I/O errors than I thought.

Anyway, since sg_format appeared to complete OK, I moved onto the next
stage which was to partition the disk with the following commands

=A0=A0=A0=A0 parted -a optimal /dev/sd<x>
=A0=A0=A0=A0 (parted) mklabel msdos
=A0=A0=A0=A0 (parted) mkpart primary 2048s 100% (need to check that the s=
tart is
correct)
=A0=A0=A0=A0 (parted) align-check optimal 1 (verify alignment of partitio=
n 1)
=A0=A0=A0=A0 (parted) set 1 raid on (set the FLAG to RAID)
=A0=A0=A0=A0 (parted) print


Unfortunately, I don=92t have the results of the print command as my lapt=
op
unexpectedly shut down over night (it hasn=92t been a good weekend) but t=
he
partitioning appeared to complete without incident.

I then added the new disk to the array:

=A0=A0=A0=A0 mdadm --add /dev/md125 /dev/sd<x>


And it completed without any problems.

I then proceeded to grow the array:

=A0=A0=A0=A0 mdadm --grow --raid-devices=3D31 --backup-file=3D/grow_md125=
.bak
/dev/md125


I monitored this with cat /proc/mdstat and it showed that it was reshapin=
g
but the speed was 0K/sec and the reshape didn=92t progress from 0%.

#cat /proc/mdstat produced:

=A0=A0=A0=A0 Personalities : [raid1] [raid6] [raid5] [raid4]
=A0=A0=A0=A0 md125 : active raid6 sdab1[30] sdw1[26] sdc1[6] sdm1[16] sdi=
1[12]
sdz1[29] sdh1[11] sdg1[10] sds1[22] sdf1[9] sdq1[20] sdaa1[1] sdo1[18]
sdu1[24] sdb1[5] sdae1[4] sdl1[15] sdj1[13] sdn1[17] sdp1[19] sdv1[25]
sde1[8] =A0=A0 sdd1[7] sdr1[21] sdt1[23] sdx1[27] sdad1[3] sdac1[2] sdy1[=
28]
sda1[0] sdk1[14]
=A0=A0=A0=A0 =A0=A0=A0=A0=A0218789036032 blocks super 1.2 level 6, 512k c=
hunk, algorithm 2
[31/31] [UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU]
=A0=A0=A0=A0 =A0=A0=A0=A0=A0 [>....................]=A0 reshape =3D=A0 0.=
0% (1/7813894144)
finish=3D328606806584.3min speed=3D0K/sec
=A0=A0=A0=A0 =A0=A0=A0=A0=A0 bitmap: 0/59 pages [0KB], 65536KB chunk

=A0=A0=A0=A0 md126 : active raid1 sdaf1[0] sdag1[1]
=A0=A0=A0=A0 =A0=A0=A0=A0=A0 100554752 blocks super 1.2 [2/2] [UU]
=A0=A0=A0=A0 =A0=A0=A0=A0=A0 bitmap: 1/1 pages [4KB], 65536KB chunk

=A0=A0=A0=A0 md127 : active raid1 sdaf3[0] sdag2[1]
=A0=A0=A0=A0 =A0=A0=A0=A0=A0 976832 blocks super 1.0 [2/2] [UU]
=A0=A0=A0=A0 =A0=A0=A0=A0=A0 bitmap: 0/1 pages [0KB], 65536KB chunk

=A0=A0=A0=A0 unused devices: <none>


# mdadm --detail /dev/md125 produced:
/dev/md125:
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Version : 1.2
=A0=A0=A0=A0 Creation Time : Wed Sep 13 15:09:40 2017
=A0=A0=A0=A0=A0=A0=A0 Raid Level : raid6
=A0=A0=A0=A0=A0=A0=A0 Array Size : 218789036032 (203.76 TiB 224.04 TB)
=A0=A0=A0=A0 Used Dev Size : 7813894144 (7.28 TiB 8.00 TB)
=A0=A0=A0=A0=A0 Raid Devices : 31
=A0=A0=A0=A0 Total Devices : 31
=A0=A0=A0=A0=A0=A0 Persistence : Superblock is persistent

=A0=A0=A0=A0 Intent Bitmap : Internal

=A0=A0=A0=A0=A0=A0 Update Time : Sun May=A0 8 00:47:35 2022
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 State : clean, reshaping
=A0=A0=A0 Active Devices : 31
=A0=A0 Working Devices : 31
=A0=A0=A0 Failed Devices : 0
=A0=A0=A0=A0 Spare Devices : 0

=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Layout : left-symmetric
=A0=A0=A0=A0=A0=A0=A0 Chunk Size : 512K

Consistency Policy : bitmap

=A0=A0=A0 Reshape Status : 0% complete
=A0=A0=A0=A0 Delta Devices : 1, (30->31)

=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Name : localhost.localdomain:SW-R=
AID6
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 UUID : f9b65f55:5f257add:1140ccc0=
:46ca6c19
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Events : 1053617

=A0=A0=A0 Number=A0=A0 Major=A0=A0 Minor=A0=A0 RaidDevice State
=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0=A0 1=A0=A0=A0=A0=
=A0=A0=A0 0=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sda1
=A0=A0=A0=A0=A0=A0 1=A0=A0=A0=A0=A0 65=A0=A0=A0=A0=A0 161=A0=A0=A0=A0=A0=A0=
=A0 1=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdaa1
=A0=A0=A0=A0=A0=A0 2=A0=A0=A0=A0=A0 65=A0=A0=A0=A0=A0 193=A0=A0=A0=A0=A0=A0=
=A0 2=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdac1
=A0=A0=A0=A0=A0=A0 3=A0=A0=A0=A0=A0 65=A0=A0=A0=A0=A0 209=A0=A0=A0=A0=A0=A0=
=A0 3=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdad1
=A0=A0=A0=A0=A0=A0 4=A0=A0=A0=A0=A0 65=A0=A0=A0=A0=A0 225=A0=A0=A0=A0=A0=A0=
=A0 4=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdae1
=A0=A0=A0=A0=A0=A0 5=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 17=A0=A0=A0=A0=
=A0=A0=A0 5=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdb1
=A0=A0=A0=A0=A0=A0 6=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 33=A0=A0=A0=A0=
=A0=A0=A0 6=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdc1
=A0=A0=A0=A0=A0=A0 7=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 49=A0=A0=A0=A0=
=A0=A0=A0 7=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdd1
=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 65=A0=A0=A0=A0=
=A0=A0=A0 8=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sde1
=A0=A0=A0=A0=A0=A0 9=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 81=A0=A0=A0=A0=
=A0=A0=A0 9=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdf1
=A0=A0=A0=A0=A0 10=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 97=A0=A0=A0=A0=A0=
=A0 10=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdg1
=A0=A0=A0=A0=A0 11=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0 113=A0=A0=A0=A0=A0=A0=
 11=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdh1
=A0=A0=A0=A0=A0 12=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0 129=A0=A0=A0=A0=A0=A0=
 12=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdi1
=A0=A0=A0=A0=A0 13=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0 145=A0=A0=A0=A0=A0=A0=
 13=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdj1
=A0=A0=A0=A0=A0 14=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0 161=A0=A0=A0=A0=A0=A0=
 14=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdk1
=A0=A0=A0=A0=A0 15=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0 177=A0=A0=A0=A0=A0=A0=
 15=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdl1
=A0=A0=A0=A0=A0 16=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0 193=A0=A0=A0=A0=A0=A0=
 16=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdm1
=A0=A0=A0=A0=A0 17=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0 209=A0=A0=A0=A0=A0=A0=
 17=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdn1
=A0=A0=A0=A0=A0 18=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0 225=A0=A0=A0=A0=A0=A0=
 18=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdo1
=A0=A0=A0=A0=A0 19=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0 241=A0=A0=A0=A0=A0=A0=
 19=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdp1
=A0=A0=A0=A0=A0 20=A0=A0=A0=A0=A0 65=A0=A0=A0=A0=A0=A0=A0 1=A0=A0=A0=A0=A0=
=A0 20=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdq1
=A0=A0=A0=A0=A0 21=A0=A0=A0=A0=A0 65=A0=A0=A0=A0=A0=A0 17=A0=A0=A0=A0=A0=A0=
 21=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdr1
=A0=A0=A0=A0=A0 22=A0=A0=A0=A0=A0 65=A0=A0=A0=A0=A0=A0 33=A0=A0=A0=A0=A0=A0=
 22=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sds1
=A0=A0=A0=A0=A0 23=A0=A0=A0=A0=A0 65=A0=A0=A0=A0=A0=A0 49=A0=A0=A0=A0=A0=A0=
 23=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdt1
=A0=A0=A0=A0=A0 24=A0=A0=A0=A0=A0 65=A0=A0=A0=A0=A0=A0 65=A0=A0=A0=A0=A0=A0=
 24=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdu1
=A0=A0=A0=A0=A0 25=A0=A0=A0=A0=A0 65=A0=A0=A0=A0=A0=A0 81=A0=A0=A0=A0=A0=A0=
 25=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdv1
=A0=A0=A0=A0=A0 26=A0=A0=A0=A0=A0 65=A0=A0=A0=A0=A0=A0 97=A0=A0=A0=A0=A0=A0=
 26=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdw1
=A0=A0=A0=A0=A0 27=A0=A0=A0=A0=A0 65=A0=A0=A0=A0=A0 113=A0=A0=A0=A0=A0=A0=
 27=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdx1
=A0=A0=A0=A0=A0 28=A0=A0=A0=A0=A0 65=A0=A0=A0=A0=A0 129=A0=A0=A0=A0=A0=A0=
 28=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdy1
=A0=A0=A0=A0=A0 29=A0=A0=A0=A0=A0 65=A0=A0=A0=A0=A0 145=A0=A0=A0=A0=A0=A0=
 29=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdz1
=A0=A0=A0=A0=A0 30=A0=A0=A0=A0=A0 65=A0=A0=A0=A0=A0 177=A0=A0=A0=A0=A0=A0=
 30=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdab1


NOTE: the new disk is /dev/sdab


About 12 hours later, as the reshape hadn=92t progressed from 0%, I looke=
d
at ways of aborting it, such as mdadm --stop /dev/md125 which didn't work
so I ended up rebooting the server and this is where things really went
pear-shaped.

The server came up in emergency mode, which I found odd given that the
boot and root should have been OK.

I was able to log on as root OK but the RAID6 array ws stuck in the
reshape state.

I then tried mdadm --assemble --update=3Drevert-reshape
--backup-file=3D/grow_md125.bak --verbose --uuid=3D
f9b65f55:5f257add:1140ccc0:46ca6c19 /dev/md125 and this produced:

=A0=A0=A0=A0 mdadm: No super block found on /dev/sde (Expected magic a92b=
4efc, got
<varying numbers>
=A0=A0=A0=A0 mdadm: No RAID super block on /dev/sde
=A0=A0=A0=A0 .
=A0=A0=A0=A0 .
=A0=A0=A0=A0 mdadm: /dev/sde1 is identified as a member of /dev/md125, sl=
ot 6
=A0=A0=A0=A0 .
=A0=A0=A0=A0 .
=A0=A0=A0=A0 mdadm: /dev/md125 has an active reshape - checking if critic=
al
section needs to be restored
=A0=A0=A0=A0 mdadm: No backup metadata on /grow_md125.back
=A0=A0=A0=A0 mdadm: Failed to find backup of critical section
=A0=A0=A0=A0 mdadm: Failed to restore critical section for reshape, sorry=
.


I've tried difference variations on this including mdadm --assemble
--invalid-backup --force but I won't include all the different commands
here because I'm having to type all this since I can't copy anything off
the server while it's in Emergency Mode.

I have also removed the suspect disk but this hasn't made any difference.

But the closest I've come to fixing this is running mdadm /dev/md125
--assemble --invalid-backup --backup-file=3D/grow_md125.bak --verbose
/dev/sdc1 /dev/sdd1 ....... /dev/sdaf1 and this produces:
=A0=A0=A0=A0 .
=A0=A0=A0=A0 .
=A0=A0=A0=A0 .
=A0=A0=A0=A0 mdadm: /dev/sdaf1 is identified as a member of /dev/md125, s=
lot 4.
=A0=A0=A0=A0 mdadm: /dev/md125 has an active reshape - checking if critic=
al
section needs to be restored
=A0=A0=A0=A0 mdadm: No backup metadata on /grow_md125.back
=A0=A0=A0=A0 mdadm: Failed to find backup of critical section
=A0=A0=A0=A0 mdadm: continuing without restoring backup
=A0=A0=A0=A0 mdadm: added /dev/sdac1 to /dev/md125 as 1
=A0=A0=A0=A0 .
=A0=A0=A0=A0 .
=A0=A0=A0=A0 .
=A0=A0=A0=A0 mdadm: failed to RUN_ARRAY /dev/md125: Invalid argument


dmesg has this information:

=A0=A0=A0=A0 md: md125 stopped.
=A0=A0=A0=A0 md/raid:md125: reshape_position too early for auto-recovery =
-
aborting.
=A0=A0=A0=A0 md: pers->run() failed ...
=A0=A0=A0=A0 md: md125 stopped.


If you=92ve stuck with me and read all this way, thank you and I hope you
can help me.

Regards,
Bob Brand
