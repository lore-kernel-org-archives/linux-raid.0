From: Matt Stegman <matts@ksu.edu>
Subject: Re: Move md raid5 from intel to sparc?
Date: Wed, 11 Jun 2003 14:08:28 -0500 (CDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200306111908.h5BJ8SsX012002@imsebackup.imse.ksu.edu>
References: <3EE76EDA.1060000@geodev.com>
Mime-Version: 1.0
Content-Type: TEXT/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3EE76EDA.1060000@geodev.com>
To: matthew@geodev.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11 Jun, Matthew Mitchell wrote:
> What _about_ the filesystem and data, though?  Some filesystems are 
> certainly written in a known byte-order, like ISO 9660.  Are there any 
> of (ext3, XFS, JFS, reiserfs) that this is true for?  Or are they all 
> written in cpu native byte-order?

I know XFS always uses big-endian on disk; one of SGI's selling points
was that you can move disks back and forth between MIPS and Intel
computers.  I think ext2/3 also uses the same format between big and
little endian archs.

-- 
--
    -Matt Stegman
