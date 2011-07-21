From: Vasco =?iso-8859-15?b?Tul2b2E=?= <vasco.nevoa@sapo.pt>
Subject: upgrading the superblock version
Date: Thu, 21 Jul 2011 10:06:00 +0100
Message-ID: <20110721100600.66251wgcutbqknw8@mail.sapo.pt>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-15;
	DelSp="Yes";
	format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Hello.

I'd like to know if it is possible to upgrade the superblock model  
version of an array, from 0.9 to 1.0 for example.

Theoretically it should be possible, I think. What would be the safe  
steps to do it?

I imagine something like:
- zeroing the current superblocks in all the array disks;
- (optionally) assembling the array in "build" mode, ignoring superblocks;
- updating the superblocks using the desired version.

If that isn't possible, then:
- zeroing the current superblocks in all the array disks;
- creating a new array with those disks, using the desired superblock  
version and --assume-clean;
- would this lead to the loss of the partition table inside the array?

Has anyone done such a thing?
How should I proceed?

Thanks,
Vasco.
