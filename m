From: Marcus Sorensen <shadowsor@gmail.com>
Subject: Re: RAID5 alignment issues with 4K/AF drives (WD green ones)
Date: Thu, 29 Dec 2011 21:48:20 -0700
Message-ID: <CALFpzo7bo_DijDNRKJzPP+ecvcZkeFOwHp52TqmXi4zkszrbJg@mail.gmail.com>
References: <A0933627-0D84-496C-B7B7-4FE265C2A212@gmail.com>
	<4EFD1B42.3040009@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EFD1B42.3040009@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zdenek Kaspar <zkaspar82@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

No, those drives generally DON'T report 4k to the OS, even though they
are. If they were, there'd be fewer problems. They lie and say 512b
sectors for compatibility.

My only suggestion would be to experiment with various partitioning,
starting the first partition at 2048s or various points to see if you
can find a placement that aligns the partitions properly. I'm sure
there's an explanation, but I'm not in the mood to put on my thinking
hat to figure it out at the moment. May also be worth using a
different superblock version, as 1.2 is 4k from the start of the
drives, which might be messing with alignment (although I would expect
it on all arrays), worth trying the .9 which goes to the end of the
device.

On Thu, Dec 29, 2011 at 7:00 PM, Zdenek Kaspar <zkaspar82@gmail.com> wr=
ote:
> Dne 30.12.2011 0:28, Michele Codutti napsal(a):
>> Hi all, I'm writing to this mailing list because I cannot figure out=
 why I had some performance issues with my three WD20EARS (2TB Western =
Digital "Green" 4K/AF drive).
>> These drives has a (sequential) write throughput around 100MB/s. Whe=
n I combine them in a RAID0 configuration the throughput is around 300 =
MB/s and in a RAID1 configuration they preserve a single drive performa=
nce of 100MB/s.
>> When I combine all three drives in a RAID5 configuration the (indivi=
dual) performance falls around 40MB/s.
>> I get the same performance level when I do individual misaligned wri=
tes (ex: dd if=3D/dev/zero bs=3D6K of=3D/dev/sda).
>> The drives are not partitioned. I'm using the default chunk size (51=
2K) and the default metadata superblock version (1.2).
>> I had not formatted the RAID or any single drive during my test i ha=
d directly used the raw devices.
>> I'm using a 11.10 ubuntu with 3.0.0 linux kernel and 3.1.4 mdadm.
>> The hardware is a HP microserver.
>>
>> Could you give me some advice?
>> Thanks in advance.
>>
>> Michele--
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
> There must be some misalignment somewhere :( Do all drives really rep=
ort
> as 4K to the OS - physical_block_size, logical_block_size under
> /sys/block/sdX/queue/ ??
>
> NB: how does it perform with partitions starting at sector 2048 (chec=
k
> all disks with fdisk -lu /dev/sdX).
>
> HTH, Z.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
