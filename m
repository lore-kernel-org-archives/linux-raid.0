From: Andrew Burgess <aab@cichlid.com>
Subject: Re: RAID without superblock
Date: Sun, 19 Apr 2009 14:57:32 -0700
Message-ID: <1240178252.31728.12.camel@cichlid.com>
References: <20090419114743.GA29195@lazy.lzy>
	 <e96b335a0ba8595e2921d164f9b15ff7.squirrel@neil.brown.name>
	 <20090419210200.GA6942@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090419210200.GA6942@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, 2009-04-19 at 23:04 +0200, Piergiorgio Sartor wrote:

> Ah! I was thinking about it as a method to
> build a RAID with an already existing disk
> or partition, which cannot be modified.
> So, let's say I've already a disk with some
> data and I want/need to protect it with a
> RAID configuration, but I cannot re-create
> the RAID from scratch, because this will
> damage the content of the disk.

Does the filesystem support shrinking? Maybe you can shrink it a tiny
bit and put the superblock at the end. Some sb formats do this. Ext2/3
can be shrunk, xfs not.

