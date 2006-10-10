From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: avoiding the initial resync on --create
Date: Tue, 10 Oct 2006 22:37:55 +0200
Message-ID: <20061010203755.GA14865@boogie.lpds.sztaki.hu>
References: <20061009125700.GA10191@piper.madduck.net> <20061009134946.GA26122@harddisk-recovery.com> <1160411520.2917.76.camel@fc6.xsintricity.com> <20061010095524.GF7416@boogie.lpds.sztaki.hu> <1160502476.2917.134.camel@fc6.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1160502476.2917.134.camel@fc6.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Erik Mouw <erik@harddisk-recovery.com>, linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Oct 10, 2006 at 01:47:56PM -0400, Doug Ledford wrote:

> Not at all true.  Every filesystem, no matter where it stores its
> metadata blocks, still writes to every single metadata block it
> allocates to initialize that metadata block.  The same is true for
> directory blocks...they are created with a . and .. entry and nothing
> else.  What exactly do you think mke2fs is doing when it's writing out
> the inode groups, block groups, bitmaps, etc.?  Every metadata block
> needed by fsck is written either during mkfs or during use as the
> filesystem data is grown.

You don't get my point. I'm not talking about normal operation, but
about the case when the filesystem becomes corrupt, and fsck has to glue
together the pieces. Consider reiserfs: it stores metadata in a single
tree. If an internal node of the tree gets corrupted, reiserfsck has
absolutely no information where the child nodes are. So it must scan the
whole device, and perform a "does this block look like reiserfs
metadata?" test for every single block.

Btw. that's the reason why you can't store reiserfs3 file system images
on a reiserfs3 file system - reiserfsck simply can't tell if a block
that looks like metadata is really part of the filesystem or is it just
part of a regular file. AFAIK this design flaw is only fixed in reiser4.

> So, like my original email said, fsck has no business reading any block
> that hasn't been written to either by the install or since the install
> when the filesystem was filled up more.

But fsck has _ZERO_ information about what blocks were written since the
filesystem was created, because that information is part of the metadata
that got corrupted. If you could trust the metadata, you'd not need
fsck.

> It certainly does *not* read
> blocks just for the fun of it, nor does it rely on anything the
> filesystem didn't specifically write.

That's only true for "traditional" UNIX file systems like ext2/3. But
there are many other filesystems out there...

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
