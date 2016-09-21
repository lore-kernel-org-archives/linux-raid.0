From: Benjamin ESTRABAUD <ben.estrabaud@mpstor.com>
Subject: Re: restore 3disk raid5 after raidpartitions have been setup with
 xfs filesystem by accident
Date: Wed, 21 Sep 2016 14:34:33 +0100
Message-ID: <57E28C69.1040500@mpstor.com>
References: <CAKA=zHqbFv_RQvyR4o4HPS2UrP4xrRWLiy2nR+gudDguk+JLog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKA=zHqbFv_RQvyR4o4HPS2UrP4xrRWLiy2nR+gudDguk+JLog@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Simon Becks <beckssimon5@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21/09/16 11:39, Simon Becks wrote:
> Dear Developers & Gurus & Gods,
>
> i had a 3 disk software raid 5 (mdadm) on a buffalo terrastation. By
> accident I reset the raid and the NAS put on a xfs filesystem on each
> of the 3 partitions.
>
> sda6 sdb6 and sdc6 have been the raid5 member partitions.
>
> Now sda6 sdb6 and sdc6 only contain a xfs filesystem with some empty
> default folder structure - my NAS created during the "reset".
>

This is clearly not ideal, but hopefully you can recreate the MD 
superblocks and re-assemble the RAID as it was before, but that will 
imply you knowing exactly what order the devices were in your array and 
what RAID level and chunksize you used. There are procedures online to 
attempt this somewhat safe (by telling MD to assemble read only) but 
really the first step in this case is usually to backup the raw 
partitions to files or new devices in case you mess up something during 
recovery.

> Am I screwed or is there a chance to recreate the raid with the 3
> disks end up with the raid and the filesystem i had before?
>
Even if you manage to recreate the RAID superblocks and re-assemble as 
it used to be, part of the on RAID data will have been overwritten by 
the format of the individual partitions. Maybe enough that your 
filesystem will be corrupted beyond repair (at which point you can use 
utilities like the excellent "testdisk").

> any help is greatly appreciated.
>
Good luck!

> Simon
>
Regards,
Ben.
