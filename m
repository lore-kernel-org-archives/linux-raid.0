From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: fsck out of memory
Date: Sun, 9 Feb 2003 13:31:17 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030209133117.E12639@schatzie.adilger.int>
References: <Pine.LNX.4.53.0302071555110.718@ddx.a2000.nu> <Pine.LNX.4.53.0302071800200.1306@ddx.a2000.nu> <20030207102858.P18636@schatzie.adilger.int> <Pine.LNX.4.53.0302090953440.1039@ddx.a2000.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.53.0302090953440.1039@ddx.a2000.nu>; from raid@a2000.nu on Sun, Feb 09, 2003 at 11:08:44AM +0100
To: Stephan van Hienen <raid@a2000.nu>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, ext2-devel@lists.sourceforge.net, Theodore Ts'o <tytso@mit.edu>, peter@chubb.wattle.id.au, tbm@a2000.nu
List-Id: linux-raid.ids

On Feb 09, 2003  11:08 +0100, Stephan van Hienen wrote:
> makes me wonder if this can have todo with the lbd (to allow 2TB+ devices)
> patch ? or is this something else?
> (if it can be related to the lbd patch, i will remove 2 hd's from the
> array (but i don't prefer this option))

Now that you mention this, I believe that there were som fixes to the ext2/3
code to not overflow some calcs, but I don't recall the specifics.  It sure
seems unusual to have such easy-to-reproduce errors.

> mke2fs -j -m 0  -b 4096 -i 4096 -R stride=16

Do you expect to have so many small files in this huge filesystem?
Basically, the "-i" parameter is telling mke2fs what you think the
average file size will be, so 4kB is very small.

Cheers, Andreas
--
Andreas Dilger
http://sourceforge.net/projects/ext2resize/
http://www-mddsp.enel.ucalgary.ca/People/adilger/

