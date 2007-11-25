From: "Joshua Johnson" <enigma2175@gmail.com>
Subject: Re: HELP! New disks being dropped from RAID 6 array on every reboot
Date: Sun, 25 Nov 2007 13:03:25 -0700
Message-ID: <e59c37290711251203q104dbd0cnccff8c594877deb5@mail.gmail.com>
References: <e59c37290711231019v3c20ea71od906bca6e5cab724@mail.gmail.com>
	 <47487976.7060201@tmr.com>
	 <e59c37290711241653n69664fd2kf39279fa9acdb086@mail.gmail.com>
	 <4748F99D.4050100@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4748F99D.4050100@tmr.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Nov 24, 2007 9:27 PM, Bill Davidsen <davidsen@tmr.com> wrote:

>  No, I think you read that backward. using PARTITIONS is the right way to do
> it, but I was suggesting that the boot mdadm.conf in initrd was still using
> the old deleted partition names. And I assume that the old drives were
> either physically removed or you used the zero-superblock option to prevent
> the old partitions from being found and confusing the issue.

I doubt a second mdadm.conf is the problem (unless I misunderstand
something about the boot process), as I am not using a initrd on this
kernel.  One PATA drive was physically removed and one was moved to
the new controller.  The new SATA drive took the place of the removed
PATA drive in the array.

>  I assume you made the old partitions go away in one of these ways, so
> PARTITIONS should work, and from what you said I had the impression it did
> work after boot, which would fit having a non-functional mdadm config in
> initrd.
>
>  Any of that match what you're doing? I've never had to use the explicit
> partitions except when I forgot to zap the old superblocks.
>
>  --
> Bill Davidsen <davidsen@tmr.com>

I'm not sure exactly why the array wasn't being assembled with the sd*
disks but I suspect that the md driver was being loaded before the
scsi disk driver was done with the partition scan.  At any rate, using
the wildcarded device names resolved the issue and the server is
humming along happily.  Thanks for the help!
