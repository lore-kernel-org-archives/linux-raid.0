From: Anshuman Aggarwal <anshuman@brillgene.com>
Subject: RAID10: How to mark spare as active, assume-clean documentation
Date: Tue, 21 Feb 2012 00:05:45 +0530
Message-ID: <CANKTW-X7BUMGoAiuLLJoXJrP5+in9E8NDxG_jRy2DvfZty1w1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,
 I made a simple boo boo which I hope the pros here can quickly guide
me about. I have a near 2, 6 disk Raid 10 MD device (mdadm 3.1.4,
Ubuntu ocelot 3.0.0.12) in which I marked two consecutive devices as
failed and removed them (without bothering with that RAID10 can take
failure only of non consecutive devices in near 2 configuration). When
I re-added them they're showing as spares and the array is obviously
not assembling.....

I know the data is there and the disks are working reliably( I marked
them as failed coz I wanted these two drives reconstructed ...bad idea
...and there are other ways of resyncing that I now know about)

My questions:
1. I am guessing that I need to create the array with --assume-clean
the knowledge of the order of the drives (4 are known, only the order
of 2 spares is in question which I am also pretty confident about)??
2. Documentation of assume-clean is quite sparse. Does it not write
the superblock at all and only keep the details in memory? If so, how
would I write the superblocks after verifying (read-only) that the
array got recreated correctly? If it does write the superblock,
..wouldn't that destroy existing superblock in case I get the
order/some other parameter wrong on the first go?

I looked around on the list but couldn't get clear directions on the
correct use of assume-clean for such a situation. I'm hoping that a
thorough reply here could serve others looking for the same.

Thanks and regards,
Anshu
