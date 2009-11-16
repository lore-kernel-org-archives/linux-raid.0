From: <senthilkumar.muthukalai@wipro.com>
Subject: (unknown)
Date: Mon, 16 Nov 2009 09:14:11 +0530
Message-ID: <8338BD137FF1B64EB341218BD702985E02AB8FCB@BLR-EC-MBX03.wipro.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Subject: 
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All,

Could you pls help me out with the below problem?

1. Created a RAID5 with 3 disks.
2. Initial rebuild done.
3. Pulled out a disk from the array.
4. The array got degraded.
5. Added the disk back to the array with 'assemble' command.
6. The disk was successfully added and the array started rebuilding
again.
7. While rebuilding, reset the power to the NAS box.
8. When the NAS box boot up, the RAID was in degraded with the added
disk thrown out.
9. The boot messages say 'kicking out of the non-fresh disk from the
array'.

We tried '--force' option with the 'assemble' command but no success.

Could you pls share your thought on this?

Thanks,
Senthil M
