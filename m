From: Neil Brown <neilb@suse.de>
Subject: Re: attempt to access beyond end of device on RAID0 with mdadm
Date: Mon, 7 May 2007 14:31:05 +1000
Message-ID: <17982.43913.806727.654588@notabene.brown>
References: <4638A028.1010706@open-e.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Slawek on Wednesday May 2
Sender: linux-raid-owner@vger.kernel.org
To: Slawek <slawekn1@open-e.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday May 2, slawekn1@open-e.com wrote:
> Hello,
> 
> I am using Debian 3.1 (sarge) with 2.6.17.13-gen64-smp kernel.
> I have storage of 53 TB (6 units with 9.5 T). All of them are stripped
> (Raid0) using mdadm 1.9.0. On this unit  have created with LVM2 Volume
> Group and 3 logical Volumes. One for SWAP (4GB), one for some system
> files encrypted with dm-crypt and with 1GB size. The rest of free space
> is used for Logical Volume for data.
> 
> Yesterday I saw in dmesg that:
> 
> 
> attempt to access beyond end of device
> dm-6: rw=1, want=10468036824, limit=2097152
> attempt to access beyond end of device
> dm-6: rw=1, want=1381842776, limit=2097152
> attempt to access beyond end of device
> dm-6: rw=1, want=2907847344, limit=2097152
> attempt to access beyond end of device
> dm-6: rw=1, want=822338824, limit=2097152
> Buffer I/O error on device dm-6, logical block 102792352
> lost page write due to I/O error on dm-6
> Aborting journal on device dm-6.
> ext3_abort called.
> EXT3-fs error (device dm-6): ext3_journal_start_sb: Detected aborted journal
> Remounting filesystem read-only
> 
> dm-6 is my system partition

This looks like filesystem corruption.  It could be caused by some
problem with dm-crypt, or it could be caused by a data error on the
storage media or on the path from the media to the CPU.

Encryption could turn a single bit error into substantial changes all
over the block.

I recommend you 'fsck' dm-6 and see how bad it is, and if the problem
is repeatable or transient.

I don't think this problem could be caused by mdadm or md/raid0.  If
there would bugs there, you would get much more consistent errors.

NeilBrown
