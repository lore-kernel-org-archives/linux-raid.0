From: Stephan van Hienen <raid@a2000.nu>
Subject: Re: non-optimal RAID 5 performance with 8 drive array
Date: Sun, 6 Mar 2005 15:25:34 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0503061516330.3998@adsl.a2000.nu>
References: <42246D1F.3070407@variant.ch>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
In-Reply-To: <42246D1F.3070407@variant.ch>
Sender: linux-raid-owner@vger.kernel.org
To: Nicola Fankhauser <nicola.fankhauser@variant.ch>
Cc: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 1 Mar 2005, Nicola Fankhauser wrote:

> the array (reading the first 8GiB from /dev/md0 with dd, bs=1024K) performs 
> at about 174MiB/s, accessing the array through LVM2 (still with bs=1024K) 
> only 86MiB/s.

Nicola,

which kernel are you using ?

2.4 vs 2.6 performance on my machine (and same problem on different 
machines)

raid5 13 disks

2.4:
write 100MB/s
read  140MB/s

2.6
write 100MB/s
read  280MB/s
