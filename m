From: "Stephen C. Tweedie" <sct@redhat.com>
Subject: Re: [Ext2-devel] Re: fsck out of memory
Date: 10 Feb 2003 22:44:20 +0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1044917060.11838.108.camel@sisko.scot.redhat.com>
References: <Pine.LNX.4.53.0302071555110.718@ddx.a2000.nu>
	<Pine.LNX.4.53.0302071800200.1306@ddx.a2000.nu>
	<20030207102858.P18636@schatzie.adilger.int>
	<Pine.LNX.4.53.0302090953440.1039@ddx.a2000.nu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.53.0302090953440.1039@ddx.a2000.nu>
To: Stephan van Hienen <raid@a2000.nu>
Cc: Andreas Dilger <adilger@clusterfs.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, ext2-devel@lists.sourceforge.net, Theodore Ts'o <tytso@mit.edu>, peter@chubb.wattle.id.au, tbm@a2000.nu
List-Id: linux-raid.ids

Hi,

On Sun, 2003-02-09 at 10:08, Stephan van Hienen wrote:

> Feb  7 04:18:15 storage kernel: EXT3-fs error (device md(9,0)):
> ext3_new_block:
> Allocating block in system zone - block = 536875638

That looks like it could be a block wrap, amongst other possible causes.

> makes me wonder if this can have todo with the lbd (to allow 2TB+ devices)
> patch ? or is this something else?

Well, that's the most likely candidate, because it's the least tested
component.  Are you using Ben LaHaise's LBD fixes for the md devices? 
Without those, md and lvm are not LBD-safe.

Cheers,
 Stephen

