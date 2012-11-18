From: Phil Turmel <philip@turmel.org>
Subject: Re: Issue with Raid 10 super block failing
Date: Sun, 18 Nov 2012 13:56:19 -0500
Message-ID: <50A92F53.5080100@turmel.org>
References: <CAPAnFc_USC=a8S_0wcsK36Sx=HXgfVTQ4LPC=m9Y9mDFrYrepg@mail.gmail.com> <50A82267.9030802@turmel.org> <CAPAnFc_ZtiE_-6usMHZA56Vx9JOw=gT3O3ABdpb2kcqLV6hcBw@mail.gmail.com> <50A8F247.8060002@turmel.org> <CAPAnFc9_AqQCHnzpNukVJNuaAZ0k9+i0wEZn6SAX=ucF_X_k2g@mail.gmail.com> <50A91487.70806@turmel.org> <CAPAnFc9KLBDhCDt1WYiOye5wvRv=zvBDfL1=8OEYg04VBCLHBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPAnFc9KLBDhCDt1WYiOye5wvRv=zvBDfL1=8OEYg04VBCLHBQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Drew Reusser <dreusser@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Drew,

Please don't top-post.  Repaired again.

On 11/18/2012 12:39 PM, Drew Reusser wrote:
> On Sun, Nov 18, 2012 at 5:01 PM, Phil Turmel <philip@turmel.org> wrote:

[trim /]

>> This all looks like it should work.
>>
>> Please try "mdadm -v --assemble /dev/md0 /dev/sd[abde]1" and show the
>> output.  If it doesn't work, also show "cat /proc/mdstat" and "dmesg".

> The issue is not that I cannot get the raid to create, it is that I
> cannot access any of the files on the system when I mount it.  It was
> setup as an ext4 filesystem and it all was working and I rebooted and
> it was not after that point.
>
>
> mint mnt # mount -t ext4 /dev/md0 /mnt/raid
> mount: wrong fs type, bad option, bad superblock on /dev/md0,
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail  or so
>
> mint dev # mdadm -v --assemble /dev/md0 /dev/sd[abde]1
> mdadm: looking for devices for /dev/md0
> mdadm: /dev/sda1 is identified as a member of /dev/md0, slot 0.
> mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 1.
> mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 2.
> mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 3.
> mdadm: added /dev/sdb1 to /dev/md0 as 1
> mdadm: added /dev/sdd1 to /dev/md0 as 2
> mdadm: added /dev/sde1 to /dev/md0 as 3
> mdadm: added /dev/sda1 to /dev/md0 as 0
> mdadm: /dev/md0 has been started with 4 drives.
> mint dev # cat /proc/mdstat
> Personalities : [raid10]
> md0 : active raid10 sda1[0] sde1[3] sdd1[2] sdb1[1]
>       1952211968 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]
>
> unused devices: <none>

Ok.  So it's not a raid problem.  You didn't show your dmesg.

Phil
