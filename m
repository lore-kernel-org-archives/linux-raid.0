From: Michael Busby <michael.a.busby@gmail.com>
Subject: Re: Raid5 to another raid level??
Date: Wed, 12 Oct 2011 10:25:16 +0100
Message-ID: <CAFsPQ__r3OX4X_U=f06DCpFMvi2QEKYo9D+N5-SEXpEyRBhR4A@mail.gmail.com>
References: <-7602537176266265843@unknownmsgid>
	<CAFsPQ__YdDnJw=qgLAq10vRbNPy4B_EhkV4FU0JAfovxnw9TxQ@mail.gmail.com>
	<CAFsPQ__NZPpf1G0MfNFsnLp7d0TrVvSGgN2wNwyeeF_fHDZFAQ@mail.gmail.com>
	<20111012151051.6f03a0e7@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111012151051.6f03a0e7@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: john.robinson@anonymous.org.uk, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks, can i just double check the command with you

mdadm --create /dev/md0 --chunk=3D512 --metadata=3D1.0 --assume-clean
--level=3D5 --raid-devices=3D4 /dev/sde /dev/sdc /dev/sdd /dev/sdb


On 12 October 2011 05:10, NeilBrown <neilb@suse.de> wrote:
> On Mon, 10 Oct 2011 22:47:58 +0100 Michael Busby <michael.a.busby@gma=
il.com>
> wrote:
>
>> I have a quick question i remember reading somewhere about not using
>> metadata version 0.9 with drives larger than 2tb,
>> > at the moment i have the following
>> >
>> > root@BlueBolt:~# cat /proc/mdstat
>> > Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid=
5] [raid4] [raid10]
>> > md0 : active raid5 sdd[2] sde[0] sdb[3] sdc[1]
>> > =A0 =A0 =A0 5860543488 blocks level 5, 512k chunk, algorithm 2 [4/=
4] [UUUU]
>> > =A0 =A0 =A0 bitmap: 2/15 pages [8KB], 65536KB chunk
>> > unused devices: <none>
>> > root@BlueBolt:~# mdadm --detail /dev/md0
>> > /dev/md0:
>> > =A0 =A0 =A0 =A0 Version : 0.90
>> > =A0 Creation Time : Mon Jul =A04 15:08:38 2011
>> > =A0 =A0 =A0Raid Level : raid5
>> > =A0 =A0 =A0Array Size : 5860543488 (5589.05 GiB 6001.20 GB)
>> > =A0 Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
>> > =A0 =A0Raid Devices : 4
>> > =A0 Total Devices : 4
>> > Preferred Minor : 0
>> > =A0 =A0 Persistence : Superblock is persistent
>> > =A0 Intent Bitmap : Internal
>> > =A0 =A0 Update Time : Mon Oct 10 22:44:11 2011
>> > =A0 =A0 =A0 =A0 =A0 State : active
>> > =A0Active Devices : 4
>> > Working Devices : 4
>> > =A0Failed Devices : 0
>> > =A0 Spare Devices : 0
>> > =A0 =A0 =A0 =A0 =A0Layout : left-symmetric
>> > =A0 =A0 =A0Chunk Size : 512K
>> > =A0 =A0 =A0 =A0 =A0 =A0UUID : ddab6c38:dee3ead0:95ba4558:1c9a49ed =
(local to host BlueBolt)
>> > =A0 =A0 =A0 =A0 =A0Events : 0.2836102
>> > =A0 =A0 Number =A0 Major =A0 Minor =A0 RaidDevice State
>> > =A0 =A0 =A0 =A00 =A0 =A0 =A0 8 =A0 =A0 =A0 64 =A0 =A0 =A0 =A00 =A0=
 =A0 =A0active sync =A0 /dev/sde
>> > =A0 =A0 =A0 =A01 =A0 =A0 =A0 8 =A0 =A0 =A0 32 =A0 =A0 =A0 =A01 =A0=
 =A0 =A0active sync =A0 /dev/sdc
>> > =A0 =A0 =A0 =A02 =A0 =A0 =A0 8 =A0 =A0 =A0 48 =A0 =A0 =A0 =A02 =A0=
 =A0 =A0active sync =A0 /dev/sdd
>> > =A0 =A0 =A0 =A03 =A0 =A0 =A0 8 =A0 =A0 =A0 16 =A0 =A0 =A0 =A03 =A0=
 =A0 =A0active sync =A0 /dev/sdb
>> > which as you can see if using 0.90, i am looking at replacing all =
the 2tb drives with 3tb versions, would i need to update the metadata v=
ersion? if so how can i go about this?
>
> With a really recent kernel (3.1) and recent mdadm (also not released=
 yet),
> 0.90 can go up to 4TB (it has 32 bits to count kilobytes with).
>
> Alternately you need to convert to 1.0 metadata.
>
> Currently the only way to do this is to 'create' the array again.
> Be sure to specified the same chunk size, the right metadata, the nam=
e level
> and number of disks, and the correct disks in the correct order.
> An use "--assume-clean". =A0Then check your data is still consistent.
> With --assume-clean and a read-only mount, no data will actually be c=
hanged,
> only metadata.
>
> NeilBrown
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
