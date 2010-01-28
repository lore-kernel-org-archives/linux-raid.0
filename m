From: Yuehai Xu <yuehaixu@gmail.com>
Subject: Re: The huge different performance of sequential read between RAID0
	and RAID5
Date: Thu, 28 Jan 2010 09:55:05 -0500
Message-ID: <100eff551001280655r2e173286nfca3dbf688609571@mail.gmail.com>
References: <100eff551001271916y116de081la77982f4b5a03c73@mail.gmail.com>
	 <20100128070606.GD3098@boogie.lpds.sztaki.hu>
	 <100eff551001280631h7de01ba6n52d79fdfcea9445e@mail.gmail.com>
	 <20100128144118.GB17369@twister.selfip.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100128144118.GB17369@twister.selfip.org>
Sender: linux-raid-owner@vger.kernel.org
To: Gabor Gombas <gombasg@sztaki.hu>
Cc: linux-raid@vger.kernel.org, yhxu@wayne.edu
List-Id: linux-raid.ids

2010/1/28 Gabor Gombas <gombasg@sztaki.hu>:
> On Thu, Jan 28, 2010 at 09:31:23AM -0500, Yuehai Xu wrote:
>
>> >> md0 : active raid5 sdh1[7] sdg1[5] sdf1[4] sde1[3] sdd1[2] sdc1[1=
] sdb1[0]
>> >> =A0 =A0 =A0 631353600 blocks level 5, 64k chunk, algorithm 2 [7/6=
] [UUUUUU_]
> [...]
>
>> I don't think any of my drive fail because there is no "F" in my
>> /proc/mdstat output
>
> It's not failed, it's simply missing. Either it was unavailable when =
the
> array was assembled, or you've explicitely created/assembled the arra=
y
> with a missing drive.

I noticed that, thanks! Is it usual that at the beginning of each
setup, there is one missing drive?

>
>> How do you know my RAID5 array has one drive missing?
>
> Look at the above output: there are just 6 of the 7 drives available,
> and the underscore also means a missing drive.
>
>> I tried to setup RAID5 with 5 disks, 3 disks, after each setup,
>> recovery has always been done.
>
> Of course.
>
>> However, if I format my md0 with such command:
>> mkfs.ext3 -b 4096 -E stride=3D16 -E stripe-width=3D*** /dev/XXXX, th=
e
>> performance for RAID5 becomes usual, at about 200~300M/s.
>
> I suppose in that case you had all the disks present in the array.

Yes, I did my test after the recovery, in that case, does the "missing
drive" hurt the performance?

Thanks!

Yuehai
>
> Gabor
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
