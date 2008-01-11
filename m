From: Neil Brown <neilb@suse.de>
Subject: Re: The effects of multiple layers of block drivers
Date: Fri, 11 Jan 2008 12:45:07 +1100
Message-ID: <18310.51747.929398.385256@notabene.brown>
References: <4786A329.90702@2inches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dennison Williams on Thursday January 10
Sender: linux-raid-owner@vger.kernel.org
To: Dennison Williams <evoltech@2inches.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday January 10, evoltech@2inches.com wrote:
> Hello,
> 
> I am starting to dig into the Block subsystem to try and uncover the
> reason for some data I lost recently.  My situation is that I have
> multiple block drivers on top of each other and am wondering how the
> effectss of a raid 5 rebuild would affect the block devices above it.

It should "just work" - no surprises.  raid5 is just a block device
like any other.  When doing a rebuild it might be a bit slower, but
that is all.

> 
> The layers are raid 5 -> lvm -> cryptoloop.  It seems that after the
> raid 5 device was rebuilt by adding in a new disk, that the cryptoloop
> doesn't have a valid ext3 partition on it.

There was a difference of opinion between raid5 and dm-crypt which
could cause some corruption.
What kernel version are you using, and are you using dm-crypt or loop
(e..g losetup) with encryption?


> 
> As a raid device re-builds is there ant rearranging of sectors or
> corresponding blocks that would effect another block device on top of it?

No.

NeilBrown
