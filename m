From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: IDE Software RAID5 with linux 2.4.20-pre
Date: Mon, 30 Sep 2002 01:41:29 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3D977389.1010008@tls.msk.ru>
References: <20020928085932.GG511@gzp2.gzp.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Gabor, before posting to a public mailing list,
set your email software correctly.  There is just
now way to send mail to <gzp@myhost.mynet> - there
is no such email address exists.

Gabor Z. Papp wrote:
> lo lo all,
> 
> I would like build a raid5 host with 4 IC35L060AVVA07-0
> disks, running 0 spare disks.
> Created 1-1 full size partition on each disk.
> I have found Neil's wonderful mdadm tool, and ran the command:
> 
> mdadm -C /dev/md0 -l5 -x0 -n4 /dev/hd[aceg]1 2>&1 | tee log.raid5create
[]
> Personalities : [raid5] 
> read_ahead 1024 sectors
> md0 : active raid5 ide/host2/bus1/target0/lun0/part1[4] ide/host2/bus0/target0/lun0/part1[2] ide/host0/bus1/target0/lun0/part1[1] ide/host0/bus0/target0/lun0/part1[0]
>       180154368 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]
>       [>....................]  recovery =  3.3% (2023372/60051456) finish=27.4min speed=35245K/sec
> unused devices: <none>
> 
> Seems like one of the disks failed? Or what happening?

And, before posting such questions, *wait* for mentioned
27.4min at least to see what'll happen.  No, it isn't
failed, this is expected behaviour.  Raid code is bringing
your array up by calculating necessary info to put to your
disks so that the whole thing will be consistent.  The "_"
disk shown above just don't have required information on
it yet, and raid code is working hard to initialize data
on it, at 35245K/sec speed (quite fast I'd say).  Failed
disk usually marked by F char.

/mjt

