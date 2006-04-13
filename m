From: Erik Mouw <erik@harddisk-recovery.com>
Subject: Re: Cheap Clustered FS
Date: Thu, 13 Apr 2006 15:06:36 +0200
Message-ID: <20060413130636.GE20839@harddisk-recovery.com>
References: <589a24260604101424o4bbb193egcd21d639ec040322@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <589a24260604101424o4bbb193egcd21d639ec040322@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Miller <jonebird@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Apr 10, 2006 at 05:24:34PM -0400, Jon Miller wrote:
> I have two machines which have redundant paths to the same shared scsi
> disk. I've had no problem creating the multipath'ed device md0 to
> handle my redundant pathing. But now I'd like to use a simple FS, such
> as ext3, mounted rw on the first machine and ro on the second machine.
> The idea is that the second machine, mounting the FS ro, would be able
> to read any new data being written in the FS.
> Everything has been rather easy to setup, but anything being created
> on the FS is not seen on the other machine with the FS mounted ro.
> That is, I can create a file on the first machine and I never see that
> file from the second machine until I remount the FS.
> At this point, I am actually trying to avoid GFS, OCFS, veritas
> clustered FS options as well as NFS. If there was a simple hack, that
> I'm missing, to enable the updates to the FS to be seen in realtime,
> then I'd actually prefer that method.
> Any help would be appreciated.

I'm affraid the only way out is indeed GFS or OCFS. Those filesystems
are specifically designed to be mounted by several hosts and (should)
have caching and locking issues covered.


Erik

-- 
+-- Erik Mouw -- www.harddisk-recovery.com -- +31 70 370 12 90 --
| Lab address: Delftechpark 26, 2628 XH, Delft, The Netherlands
