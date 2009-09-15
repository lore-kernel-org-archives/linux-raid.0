From: "NeilBrown" <neilb@suse.de>
Subject: Re: RAID1 assembled broken array
Date: Wed, 16 Sep 2009 07:01:14 +1000 (EST)
Message-ID: <65549e07fd6559855af68b60783213c3.squirrel@neil.brown.name>
References: <h8ophd$n8p$6@ger.gmane.org>
    <9F2F4760-DF0C-4416-89AC-C689177AD4ED@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9F2F4760-DF0C-4416-89AC-C689177AD4ED@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Matthias Urlichs <matthias@urlichs.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, September 16, 2009 6:00 am, Doug Ledford wrote:
> On Sep 15, 2009, at 3:22 PM, Matthias Urlichs wrote:
>> I had a somewhat strange error today.
>>
>> One of my servers has a RAID1 array. Two partitions at the end of the
>> disk; the RAID superblocks are at the end of the partition.
>>
>> After a hard reboot today, one of the disks managed to not have its
>> partition table scanned correctly, most probably because the disk was
>> hung and the ("intelligent") controller got confused about it. After
>> the
>> initial scan, however, it came up correctly.
>>
>> This error caused mdadm to "successfully" build a RAID1 from /dev/sda3
>> and /dev/sdb (instead of /dev/sdb3). Needless to say, the resulting
>> volume was somewhat unuseable. To say the least.
>>
>> My server's mdadm.conf has a 'DEVICE=partitions' line. I suppose that
>> replacing these with a pattern that explicitly only matches
>> partitions,
>> not disks, would make the problem go away, and that the lesson from
>> today's disaster recovery effort is to always explicitly list the
>> allowed
>> partition names, instead of being lazy and using 'DEVICE=partitions'.
>
>
> Wrong lesson.  The correct lesson to gather from this is to prefer
> version 1.1 or 1.2 superblocks wherever possible.  Superblocks at the
> beginning of the device disappear when there is no partition table,
> superblocks at the end can be confused for superblocks belonging to
> the whole device when there is no partition table.

1.0 also protects from this problem.  The 1.x metadata stores the
offset of the superblock from the start of the device.  That will appear
to be wrong if you find a partition-superblock when reading from a
whole-device, so mdadm will reject the device as not having a valid
superblock.

NeilBrown

