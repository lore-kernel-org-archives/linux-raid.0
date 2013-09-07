From: =?UTF-8?Q?Gar=C3=B0ar_Arnarsson?= <gardar@giraffi.net>
Subject: raid6 array assembled from 11 drives and 2 spares - not enough to
 start the array
Date: Sat, 7 Sep 2013 22:56:57 +0000
Message-ID: <CAH-e9vL7fUYSrd4J7+nej=xiqndgk3vim38Mu7+E-w37QX0Ebw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am unable to start my raid6 array.

At first I got sda1 missing so I went ahead and re-added it and was
able to start the array. Then few minutes later I got 3 failed drives.

I shut down my server, checked all the sata and power cables and
booted up again.
The array did not start automatically so I tried to force assemble it.

sudo mdadm --assemble --verbose --force /dev/md1 /dev/sda1 /dev/sdb1
/dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1 /dev/sdi1
/dev/sdj1 /dev/sdk1 /dev/sdm1 /dev/sdp1 /dev/sdq1
mdadm: looking for devices for /dev/md1
mdadm: /dev/sda1 is identified as a member of /dev/md1, slot 15.
mdadm: /dev/sdb1 is identified as a member of /dev/md1, slot 8.
mdadm: /dev/sdc1 is identified as a member of /dev/md1, slot 1.
mdadm: /dev/sdd1 is identified as a member of /dev/md1, slot 3.
mdadm: /dev/sde1 is identified as a member of /dev/md1, slot 6.
mdadm: /dev/sdf1 is identified as a member of /dev/md1, slot 9.
mdadm: /dev/sdg1 is identified as a member of /dev/md1, slot 10.
mdadm: /dev/sdh1 is identified as a member of /dev/md1, slot 0.
mdadm: /dev/sdi1 is identified as a member of /dev/md1, slot 11.
mdadm: /dev/sdj1 is identified as a member of /dev/md1, slot 7.
mdadm: /dev/sdk1 is identified as a member of /dev/md1, slot 5.
mdadm: /dev/sdm1 is identified as a member of /dev/md1, slot 14.
mdadm: /dev/sdp1 is identified as a member of /dev/md1, slot 2.
mdadm: /dev/sdq1 is identified as a member of /dev/md1, slot 4.
mdadm: ignoring /dev/sdq1 as it reports /dev/sda1 as failed
mdadm: added /dev/sdc1 to /dev/md1 as 1
mdadm: added /dev/sdp1 to /dev/md1 as 2
mdadm: added /dev/sdd1 to /dev/md1 as 3
mdadm: no uptodate device for slot 4 of /dev/md1
mdadm: added /dev/sdk1 to /dev/md1 as 5
mdadm: added /dev/sde1 to /dev/md1 as 6
mdadm: added /dev/sdj1 to /dev/md1 as 7
mdadm: added /dev/sdb1 to /dev/md1 as 8
mdadm: added /dev/sdf1 to /dev/md1 as 9
mdadm: added /dev/sdg1 to /dev/md1 as 10
mdadm: added /dev/sdi1 to /dev/md1 as 11
mdadm: no uptodate device for slot 12 of /dev/md1
mdadm: no uptodate device for slot 13 of /dev/md1
mdadm: added /dev/sdm1 to /dev/md1 as 14
mdadm: added /dev/sda1 to /dev/md1 as 15
mdadm: added /dev/sdh1 to /dev/md1 as 0
mdadm: /dev/md1 assembled from 11 drives and 2 spares - not enough to
start the array.

Any ideas what could have gone wrong and how I can possibly start the
array again?
