From: Stephan van Hienen <raid@a2000.nu>
Subject: Re:2TB+ fs ext3 (was fsck out of memory)
Date: Tue, 11 Feb 2003 16:32:48 +0100 (CET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.53.0302111628230.15933@ddx.a2000.nu>
References: <3E486596.2090800@ntr.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3E486596.2090800@ntr.net>
To: "Marco C. Mason" <mason@ntr.net>
Cc: Andreas Dilger <adilger@clusterfs.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, ext2-devel@lists.sourceforge.net, Theodore Ts'o <tytso@mit.edu>, peter@chubb.wattle.id.au, bernard@biesterbos.nl
List-Id: linux-raid.ids

On Mon, 10 Feb 2003, Marco C. Mason wrote:
> I don't know if anyone mentioned it or not, but the block addresses in your
> error messages appear suspiciously close to 2^29.  I'm suspecting an
> internal
> overflow in a calculation somewhere...

615381536 blocks can this be over the limit ?

(-b 8192 gives me warning : 'Warning: blocksize 8192 not usable on most
systems.')
