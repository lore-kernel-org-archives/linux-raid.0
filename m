From: Erik Mouw <erik@harddisk-recovery.com>
Subject: Re: Recipe for Mirrored OS Drives
Date: Tue, 3 Oct 2006 12:03:22 +0200
Message-ID: <20061003100321.GA28561@harddisk-recovery.com>
References: <4520532A.3090204@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4520532A.3090204@aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: andy liebman <andyliebman@aol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Oct 01, 2006 at 07:45:46PM -0400, andy liebman wrote:
> -- Run rsync to copy contents from your existing OS drive
> 
>         rsync -av /mnt/oldroot /mnt/newroot
>         rsync -av /mnt/oldhome /mnt/newhome

At least add the -H flag to copy hardlinks. -S for sparse files might
also be useful.


Erik

-- 
+-- Erik Mouw -- www.harddisk-recovery.com -- +31 70 370 12 90 --
| Lab address: Delftechpark 26, 2628 XH, Delft, The Netherlands
