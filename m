From: "NeilBrown" <neilb@suse.de>
Subject: Re: After partition resize, RAID5 array does not assemble on boot
Date: Wed, 4 Jun 2008 07:27:02 +1000 (EST)
Message-ID: <48675.192.168.1.70.1212528422.squirrel@neil.brown.name>
References: <4844E994.8020808@jellybean.co.uk>
    <4845B573.7090801@jellybean.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4845B573.7090801@jellybean.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Jules Bean <jules@jellybean.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, June 4, 2008 7:19 am, Jules Bean wrote:
> Jules Bean wrote:
>> Help? What next ;) Is there enough information in /dev/sdd2 and
>> /dev/sdc2 to reconstruct the apparently missing superblocks on /dev/sda2
>> and /dev/sdb2? Do I need to try to resize my partitions back to their
>> old size so it can find the old superblock? Even if by adding /dev/sda2
>> as a spare I've corrupted its superblock entirely, sdb2 should still
>> have enough to save my array with 3 out of 4 devices?
>
> I have become convinced (correct me if you think I'm wrong) that the
> problem was cfdisk resizing the partitions but the kernel tables not
> being updated.

That sounds likely.... That really should get fixed one day!

>
> Therefore although I thought the partitions were 400G, the kernel still
> thought they were 250G, and presumably the raid subsystem used that
> figure.
>
> So the raid subsytem probably recorded its superblock as if the
> partitions were still only 250G long? So I ought to be able to find that
> superblock again by resizing the partitions back?
>
> Alas I didn't take precise notes of my old partition table (stupid
> error). I have tried a couple of cylinder counts near 250G but no luck.
> Is there any good way to 'search for' somethign which looks like a RAID
> superblock?
>
> Does the mdadm --detail output I pasted in my last message hold any clues?
>

Yes.  Based on the "used device size", the smallest device was between
242244096K and 242244160K

Hopefully both of the smaller devices were the same size.

NeilBrown

