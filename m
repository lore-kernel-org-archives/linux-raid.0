From: Peter Chubb <peter@chubb.wattle.id.au>
Subject: Re: fsck out of memory
Date: Mon, 10 Feb 2003 07:08:07 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15942.46375.478902.665549@wombat.chubb.wattle.id.au>
References: <Pine.LNX.4.53.0302071555110.718@ddx.a2000.nu>
	<Pine.LNX.4.53.0302071800200.1306@ddx.a2000.nu>
	<20030207102858.P18636@schatzie.adilger.int>
	<Pine.LNX.4.53.0302090953440.1039@ddx.a2000.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.53.0302090953440.1039@ddx.a2000.nu>
To: Stephan van Hienen <raid@a2000.nu>
Cc: Andreas Dilger <adilger@clusterfs.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, ext2-devel@lists.sourceforge.net, Theodore Ts'o <tytso@mit.edu>, peter@chubb.wattle.id.au, tbm@a2000.nu
List-Id: linux-raid.ids

>>>>> "Stephan" == Stephan van Hienen <raid@a2000.nu> writes:

Stephan> makes me wonder if this can have todo with the lbd (to allow
Stephan> 2TB+ devices) patch ? or is this something else?  (if it can
Stephan> be related to the lbd patch, i will remove 2 hd's from the
Stephan> array (but i don't prefer this option))

I haven't tested ext[23] with that large a system on IA32 (I stopped
at 2.4TB, and that was on Linux 2.5).  The 2.4 LBD patch was basically
backported from the 2.5.9 version (the last tested version before Al
Viro's rewrite of the block device and partitioning code).  Differences in
ext[32] between 2.4.20 and 2.5.9 may not have been allowed for
properly.

I'll have a look when I'm in at work today.

Is there any reason why you're sticking with the 2.4 kernel and ext3?
XFS has been used (on SGI systems) for much longer with large disk
arrays, and I'd expect (linux-specific bugs aside) it to be a more
mature product for this application.

Peter C

