From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID5 / 6 Growth
Date: Sat, 19 Dec 2009 13:02:40 -0600
Message-ID: <FD.58.01470.3532D2B4@cdptpa-omtalb.mail.rr.com>
References: <70ed7c3e0912191036o2a1d413es6492bdafc3a75267@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0912191036o2a1d413es6492bdafc3a75267@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "'Majed B.'" <majedb@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Do any of the disks report sector errors or ATA or read errors?
> smartctl -a /dev/sdx should give the report, assuming you run smartd
> and have it probe disks periodically.

	No, they are clean.

> I've seen newer versions of the xfsprogs and libs packages. Try using
> those. I know you're against new packages that haven't been included
> in "stable" -- but if this is a dev/backup system, it's worth the shot
> in my opinion.

	Well, either way, that's not going to help in this situation.
Either there is something I can attempt to fix in the underlying array
structure, or else I am going to have to erase the log and continue.

	I'm not sure what you mean by dev/backup.  The file system is not
created as a device on any other system by udev, if that's what you mean.
It's just a Linux system dedicated solely to running rscync backups every
morning at 04:00.  The array does get mounted on other systems using SAMBA
or NFS, as the case may be, so I can easily copy over files to the main
systems lost or corrupted through whatever means.

