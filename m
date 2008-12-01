From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: LVM on raid10,f2 performance issues
Date: Mon, 1 Dec 2008 17:42:45 +0100
Message-ID: <20081201164244.GB23899@rap.rap.dk>
References: <49332920.5010503@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49332920.5010503@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Holger Mauermann <mauermann@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Dec 01, 2008 at 01:00:32AM +0100, Holger Mauermann wrote:
> When I setup LVM on top of a 4 disk RAID 10 with f2 layout read/write
> performance is really worse - it's far below single drive speed...

How is it if you use the raid10,f2 without lvm?


What are the numbers?

Did you use it with a live file system, or with just the raw raid?

Live fs performance is much better than raw fs, in practice the raw fs
performance is not really related to real life for raid10,f2.
This because the elevator enhances operation quite a lot.

best regards
keld


> I did some testing with dd and hexdump and I noticed that after writing
> a 128k file (with 64k "X" and 64k "Y") to the lvol the data on the raw
> disks looks somewhat weird:
> 
> sda:  sdb:  sdc:  sdd:
> ----------------------
> YYYY  ....  ....  XXXX
> ....  ....  ....  ....
> XXXX  YYYY  ....  ....
> ....  ....  ....  ....
> 
> Any hints how to tune this? With LVM on a standard RAID 10 (n2) the data
> appears as expected on the disks:
> 
> sda:  sdb:  sdc:  sdd:
> ----------------------
> YYYY  YYYY  XXXX  XXXX
> ....  ....  ....  ....
> ....  ....  ....  ....
> ....  ....  ....  ....
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
