From: Kanoa Withington <kanoa@cfht.hawaii.edu>
Subject: Re: No response?
Date: Thu, 20 Jan 2005 08:49:53 -1000 (HST)
Message-ID: <Pine.LNX.4.55.0501200841070.31637@umi.cfht.hawaii.edu>
References: <Pine.LNX.4.58.0501201052240.19586@lewis.et.byu.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.58.0501201052240.19586@lewis.et.byu.edu>
Sender: linux-raid-owner@vger.kernel.org
To: David Dougall <davidd@et.byu.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi David,

I have several systems with similar kernels, raid1 mirrors and XFS
filesystems and I don't have the problem you are talking about so
there is no inherent incompatibility.

XFS will, however, shut down a filesystem if an I/O timeout is
reached. I have seen this on a system with SCSI drives where the host
controller keeps resetting itself to try to get a failing disk
back. If both disks are on the same SCSI channel, the card resets can
sometimes be long enough to trip the XFS timeout. The solution is to
make sure your mirror elements are on different host controllers, no
matter what type of interface (SCSI/IDE/ETC) they are using.

After an XFS timeout you can unmount and remount the filesystem,
unless of course it is the root filesystem.

-Kanoa

On Thu, 20 Jan 2005, David Dougall wrote:

> Perhaps I was asking a stupid question or an obvious one, but I have
> received not response.
> Maybe if I simplify the question...
>
> If I am running software raid1 and a disk device starts throwing I/O
> errors, Is the filesystem supposed to see any indication of this?  I
> thought software raid would mask all of this and just fail the drive.
>
> I have servers with xfs as the filesystem and xfs will start to throw I/O
> errors when a disk starts acting up even with software raid in between.
> Please advise on how I can confirm my setup or if this is possibly a bug
> how to diagnose further.
> If it makes a difference, I am running linux-2.4.26
> Thanks
> --David Dougall
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
