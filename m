From: andy liebman <andyliebman@aol.com>
Subject: Re: Can you IMAGE Mirrored OS Drives?
Date: Wed, 16 Aug 2006 06:06:24 -0400
Message-ID: <44E2EE20.9010004@aol.com>
References: <44E250CD.5040308@aol.com> <Pine.LNX.4.56.0608160755090.15328@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0608160755090.15328@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: gordon@drogon.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> On Tue, 15 Aug 2006, andy liebman wrote:
> 
>> -- If I were to create disk images of EACH drive (i.e., /dev/sda and
>> /dev/sdb), could I restore each of those images to NEW drives -- with
>> all of their respective partitions -- and have a working RAIDED OS?  I
>> ask because my ultimate goal is to put a RAIDED OS on many systems, and
>> once I get ONE working, it would be nice to clone them the way I already
>> clone SINGLE OS drives. Can you clone RAIDS?
> 
> Yes.
> 
> I did this some time back to create half a dozen identical systems. I did
> it with IDE drives, but I don't see why it won't work with SCSI/SATA.
> 
> The first thing you need is to make sure the partition tables are
> identical on both drives. (you probably don't, but it'll be much easier)
> 
> So I started with my good system, and had a copy of the partition table on
> hda:
> 
>   # sfdisk -d /dev/hda > ~hda.part
> 
> Made sure all partitions were insync, then shut it down and remove hdb,
> and replace it with a new blank disk of the same size.
> 
> It booted just fine, with all partitions degraded.
> 
> Put the parittion table on the new blank hdb:
> 
>   # sfdisk /dev/hdb < ~/hda.part
> 
> then I hot-added each partition. eg:
> 
>   # mdadm --add /dev/md1 /dev/hdb1
> 
> and so on.
> 

Thanks Gordon,

I may not have been clear what I was asking. I wanted to know if you can 
make DISK IMAGES -- for example, with a program like Norton Ghost or 
Acronis True Image (better) -- of EACH of the two OS drives from a 
mirrored pair. Then restore Image A to one new disk, Image B to another 
disk. And then have a new working mirrored pair.

There is absolutely NO PROBLEM making images of single disks and 
restoring them to new disks (thus, creating clones). And it is very 
fast. For an OS drive with about 4 GBs of data, it only takes about 5 
minutes to make the image and 3 to restore it. So, after making the 
first set of images, it would in theory take under 10 minutes to restore 
a mirrored pair.

I'm just trying to find out if there would be any "gotchas" in restoring 
mirrored drives. I can't think of any, but you never know. I'm not 
worried about hostnames. That's easy to fix.

Andy
