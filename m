From: Yuehai Xu <yuehaixu@gmail.com>
Subject: Re: The huge different performance of sequential read between RAID0
	and RAID5
Date: Thu, 28 Jan 2010 09:31:23 -0500
Message-ID: <100eff551001280631h7de01ba6n52d79fdfcea9445e@mail.gmail.com>
References: <100eff551001271916y116de081la77982f4b5a03c73@mail.gmail.com>
	 <20100128070606.GD3098@boogie.lpds.sztaki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100128070606.GD3098@boogie.lpds.sztaki.hu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: gombasg@sztaki.hu, yhxu@wayne.edu
List-Id: linux-raid.ids

On Thu, Jan 28, 2010 at 2:06 AM, Gabor Gombas <gombasg@sztaki.hu> wrote=
:
> On Wed, Jan 27, 2010 at 10:16:12PM -0500, Yuehai Xu wrote:
>
>> md0 : active raid5 sdh1[7] sdg1[5] sdf1[4] sde1[3] sdd1[2] sdc1[1] s=
db1[0]
>> =A0 =A0 =A0 631353600 blocks level 5, 64k chunk, algorithm 2 [7/6] [=
UUUUUU_]
> [...]

Do you mean there is something wrong when I setup my RAID5? The
command I use to setup RAID5 is:
mdadm --create /dev/md0 --level=3D5 --raid-devices=3D7 /dev/sdb1 /dev/s=
dc1
/dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1

I don't think any of my drive fail because there is no "F" in my
/proc/mdstat output

>> Then I start IOZONE which starts 10 processes to do the sequential
>> read(iozone -i 1). Each process read 640M file on each partition. Th=
e
>> throughput of RAID0 is about 180M/s, while the throughput of RAID5 i=
s
>> just 43M/s. Why the performance between RAID0 and RAID5 is so
>> different?
>
> You have a degraded RAID5 array with one drive missing, meaning the d=
ata
> has to be recalculated from parity all the time. That obviously kills
> performance.
>
> Gabor

How do you know my RAID5 array has one drive missing? I tried to setup
RAID5 with 5 disks, 3 disks, after each setup, recovery has always
been done. However, if I format my md0 with such command:
mkfs.ext3 -b 4096 -E stride=3D16 -E stripe-width=3D*** /dev/XXXX, the
performance for RAID5 becomes usual, at about 200~300M/s.

>
> --
> =A0 =A0 ---------------------------------------------------------
> =A0 =A0 MTA SZTAKI Computer and Automation Research Institute
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Hungarian Academy of Sciences
> =A0 =A0 ---------------------------------------------------------
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
