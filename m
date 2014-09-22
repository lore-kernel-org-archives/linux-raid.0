From: =?ISO-8859-1?Q?Patrik_Horn=EDk?= <patrik@dsl.sk>
Subject: Please advise, strange "not enough to start the array while not clean"
Date: Mon, 22 Sep 2014 04:11:20 +0200
Message-ID: <CAAOsTSkaFdum4LD8aOkOsG-f45fTjRSUPb=EqguJi4yaNjcSdQ@mail.gmail.com>
Reply-To: patrik@dsl.sk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Neil,

I've got this situation unfamiliar to me on RAID6 array md1 with important data.

- It is RAID6 with 6 devices, 5 are partitions and 1 is another RAID0
array md101 from two smaller drives. One of the smaller drives froze,
so md101 got kicked out from md1 and marked as faulty in md1. After
while I've stopped md1 without removing md101 from it first. Then I
rebooted and assembled md101.

- First I tried mdadm -A --no-degraded -u UUID /dev/md1 but got
"mdadm: /dev/md1 assembled from 5 drives (out of 6), but not started."
so I stopped the md1.

- Second time I started it with -v and got:

mdadm: /dev/md101 is identified as a member of /dev/md1, slot 5.
mdadm: /dev/sdk1 is identified as a member of /dev/md1, slot 4.
mdadm: /dev/sdi1 is identified as a member of /dev/md1, slot 1.
mdadm: /dev/sdh1 is identified as a member of /dev/md1, slot 2.
mdadm: /dev/sdg1 is identified as a member of /dev/md1, slot 0.
mdadm: /dev/sde1 is identified as a member of /dev/md1, slot 3.
mdadm: added /dev/sdi1 to /dev/md1 as 1
mdadm: added /dev/sdh1 to /dev/md1 as 2
mdadm: added /dev/sde1 to /dev/md1 as 3
mdadm: added /dev/sdk1 to /dev/md1 as 4
mdadm: added /dev/md101 to /dev/md1 as 5 (possibly out of date)
mdadm: added /dev/sdg1 to /dev/md1 as 0
mdadm: /dev/md1 assembled from 5 drives (out of 6), but not started.

- On third time I tried without --nodegraded with mdadm -A -v -u UUID
/dev/md1. This is what I've got:

mdadm: /dev/md101 is identified as a member of /dev/md1, slot 5.
mdadm: /dev/sdk1 is identified as a member of /dev/md1, slot 4.
mdadm: /dev/sdi1 is identified as a member of /dev/md1, slot 1.
mdadm: /dev/sdh1 is identified as a member of /dev/md1, slot 2.
mdadm: /dev/sdg1 is identified as a member of /dev/md1, slot 0.
mdadm: /dev/sde1 is identified as a member of /dev/md1, slot 3.
mdadm: added /dev/sdi1 to /dev/md1 as 1
mdadm: added /dev/sdh1 to /dev/md1 as 2
mdadm: added /dev/sde1 to /dev/md1 as 3
mdadm: added /dev/sdk1 to /dev/md1 as 4
mdadm: added /dev/md101 to /dev/md1 as 5 (possibly out of date)
mdadm: added /dev/sdg1 to /dev/md1 as 0
mdadm: /dev/md1 assembled from 5 drives - not enough to start the
array while not clean - consider --force.

Array md1 has bitmap. All drive devices have all same Events, their
state is clean and Device Role is Active device. md101 has active
state and lower Events.

Is this expected behavior? My theory is that it is caused by md101 and
I should start array md1 without it (by for example stopping md101)
and then re-add it. Is that a case or is it something else?

Thanks.

Best regards,

Patrik
