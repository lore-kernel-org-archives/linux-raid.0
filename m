From: Doug Herr <gmane@wombatz.com>
Subject: Re: Replacing a RAID1 drive that has not failed.
Date: Wed, 28 Oct 2015 15:54:00 +0000 (UTC)
Message-ID: <n0qr2n$9t7$1@ger.gmane.org>
References: <n0mbam$gmk$1@ger.gmane.org> <n0o9n3$gmk$2@ger.gmane.org>
	<562FED15.5040804@youngman.org.uk> <20151028102817.4ec30b5c@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 28 Oct 2015 10:28:17 +0500, Roman Mamedov wrote:

> On Tue, 27 Oct 2015 21:31:01 +0000
> Wols Lists <antlists@youngman.org.uk> wrote:
> 
>> On 27/10/15 16:45, Doug Herr wrote:
>> >  1. Partition new drive (plugged in via external SATA dock)
>> > #fdisk /dev/sdc
>> > (make it an exact match of sda/sdb unless it turns out to be smaller,
>> >  in which case I can shrink /boot to make room.)
>> 
>> man gdisk.
>> 
>> Look at the "u" option in the "expert" menu - it'll probably save you
>> some work :-)
> 
> Unfamiliar with 'gdisk', but when I need the exact same set of 
partitions on
> another drive, I use sfdisk:
> 
> # sfdisk -d /dev/sda > sda.sf
> # sfdisk /dev/sdb < sda.sf
> 
> You could even do it in one step:
> 
> # sfdisk -d /dev/sda | sfdisk /dev/sdb


Thanks much to all who have replied and all who post here.

Yup, the sfdisk copy is one that I am ready to use if needed but your 
replies have triggered better googling and I am now planning to use fdisk 
(I am in Fedora 22) to manually partition the new disk.  I don't think I 
have any need for GPT yet but what I realized is that my current set of 
disks was created when fdisk was still starting at sector 63 where now it 
uses 2048.  I don't think it matters much for my current set of Hitachi 
HDT721010SLA360 drives.  It might not even matter for the slightly newer 
"E7K1000" that is on the way to me, but I do want to stick with the 
current standards as best I can.  I have room to tweak it since I have a 
non-RAID /boot partition that is easily large enough to lend space as 
needed.

I do plan to play with GPT to learn about it and to be more ready for the 
next computer if it is the default at that point.

Oh, I also added a step in my plan.  Adding my new partitions as spares 
first will alert me of size errors (if smaller) *before* any of the 
replacement jobs kick off:

For each:
# mdadm /dev/md4 --add-spare /dev/sdc2

If the above does not complain then move forward for each:
# mdadm /dev/md3 --replace /dev/sda2 --with /dev/sdc2

And fear not, I will be updating my backups before moving forward with 
this.

-- 
Doug Herr 

