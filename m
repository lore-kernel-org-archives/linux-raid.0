From: Stephan van Hienen <raid@a2000.nu>
Subject: Re: fsck out of memory
Date: Mon, 10 Feb 2003 13:01:35 +0100 (CET)
Sender: ext2-devel-admin@lists.sourceforge.net
Message-ID: <Pine.LNX.4.53.0302101228430.7274@ddx.a2000.nu>
References: <Pine.LNX.4.53.0302071555110.718@ddx.a2000.nu>
 <Pine.LNX.4.53.0302071800200.1306@ddx.a2000.nu> <20030207102858.P18636@schatzie.adilger.int>
 <Pine.LNX.4.53.0302090953440.1039@ddx.a2000.nu> <20030209133117.E12639@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <ext2-devel-admin@lists.sourceforge.net>
In-Reply-To: <20030209133117.E12639@schatzie.adilger.int>
Errors-To: ext2-devel-admin@lists.sourceforge.net
List-Help: <mailto:ext2-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:ext2-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/ext2-devel>,
	<mailto:ext2-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/ext2-devel>,
	<mailto:ext2-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=ext2-devel>
To: Andreas Dilger <adilger@clusterfs.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, ext2-devel@lists.sourceforge.net, Theodore Ts'o <tytso@mit.edu>, peter@chubb.wattle.id.au, tbm@a2000.nu
List-Id: linux-raid.ids

On Sun, 9 Feb 2003, Andreas Dilger wrote:

> > mke2fs -j -m 0  -b 4096 -i 4096 -R stride=16
>
> Do you expect to have so many small files in this huge filesystem?
> Basically, the "-i" parameter is telling mke2fs what you think the
> average file size will be, so 4kB is very small.
not really, i thought the -b was telling this ?
i think average filesize should be somewhere from 1-5 megabyte
(zipfiles few megabyte/videofiles (can be a few gigabyte)/installation
files for programmes)

i also wonder what kind of chunk-size i need to use
i use 64k now, but i wonder if 256k (or something bigger?) would be better
(does chunk size difference in performance between a 4disk raid5 and a 15disk raid5 ?)


-------------------------------------------------------
This SF.NET email is sponsored by:
SourceForge Enterprise Edition + IBM + LinuxWorld = Something 2 See!
http://www.vasoftware.com
