From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: LVM on raid10,f2 performance issues
Date: Mon, 19 Jan 2009 08:28:20 +0100
Message-ID: <49742B94.8090407@rabbit.us>
References: <49332920.5010503@gmail.com> <20081201164244.GB23899@rap.rap.dk> <4935C4B3.2060404@gmail.com> <493654C7.2090909@ziu.info> <8CB47EBD70FE9E8-AC4-981@WEBMAIL-DG06.sim.aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8CB47EBD70FE9E8-AC4-981@WEBMAIL-DG06.sim.aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: thomas62186218@aol.com
Cc: soltys@ziu.info, mauermann@gmail.com, keld@dkuug.dk, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

thomas62186218@aol.com wrote:
> Hi everyone,
> 
> I too was seeing miserable read-performance with LVM2 volumes on top of
> md RAID 10's on my Ubuntu 8.04 64-bit machine. My RAID 10 has 12 x 300GB
> 15K SAS drives on a 4-port LSI PCIe SAS controller.
> 
> I use:
> blockdev --setra 65536 /dev/md0
> 
> And this dramatically increased my RAID 10 read performance.
> 
> You MUST do the same for your LVM2 volumes for them to see a comparable
> performance boost.
> 
> blockdev --setra 65536 /dev/mapper/raid10-testvol
> 

This is incorrect. Only the readahead setting of the _last_ block device
matters. So in case you have a raid6 of 10 drives, with LUKS on top,
with LVM on top - only the readahead settings of the individual LVs
matter, nothing further down the chain is consulted.
