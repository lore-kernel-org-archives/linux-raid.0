From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: fsck out of memory
Date: Fri, 7 Feb 2003 10:28:58 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030207102858.P18636@schatzie.adilger.int>
References: <Pine.LNX.4.53.0302071555110.718@ddx.a2000.nu> <Pine.LNX.4.53.0302071800200.1306@ddx.a2000.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.53.0302071800200.1306@ddx.a2000.nu>; from raid@a2000.nu on Fri, Feb 07, 2003 at 06:07:09PM +0100
To: Stephan van Hienen <raid@a2000.nu>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, ext2-devel@lists.sourceforge.net, Theodore Ts'o <tytso@mit.edu>
List-Id: linux-raid.ids

On Feb 07, 2003  18:07 +0100, Stephan van Hienen wrote:
> ok added some swap space (4 gigabyte)
> 
> usage was about 2.5GB
> 
> till aborted :
> 
> d0:  64450554/dev/md0:  64450555/dev/md0:  64450556/dev/md0:
> 64450557/dev/md0:  64450558/dev/md0:  64450559/dev/md0:  64450560/dev/md0:
> 64450561/dev/md0:  64450562/dev/md0:  64450563/dev/md0:  64450564/dev/md0:
> 64450565/dev/md0:  64450566/dev/md0:  64450567/dev/md0:  64450568/dev/md0:
> 64450569/dev/md0:  64450570/dev/md0:  64450571/dev/md0:  64450572/dev/md0:
> 64450573/dev/md0:  64450574/dev/md0:  64450575/dev/md0:  64450576/dev/md0:
> 64450577/dev/md0:  64450578/dev/md0:  64450579/dev/md0:  64450580/dev/md0:
> 64450581/dev/md0:  64450582/dev/md0:  64450583/dev/md0:  64450584/dev/md0:
> 64450585/dev/md0:  64450586/dev/md0:  64450587/dev/md0:  64450588/dev/md0:
> 64450589/dev/md0:  64450590e2fsck: Can't allocate block element
> 
> e2fsck: aborted
> /dev/md0: 153834/76922880 files (9.3% non-contiguous), 181680730/615381536
> blocks
> 
> any hints ?
> (i really would like to get back a clean fs (with ext3 journal))

Hmm, I don't think that will be easy...  By default e2fsck will load all
of the inode blocks into memory (pretty sure at least), and if you have
76922880 inodes that is 9.6GB of memory, which you can't allocate from a
single process on i386 no matter how much swap you have.  2.5GB sounds
about right for the maximum amount of memory one can allocate.

Ted, any suggestions?

Cheers, Andreas
--
Andreas Dilger
http://sourceforge.net/projects/ext2resize/
http://www-mddsp.enel.ucalgary.ca/People/adilger/

