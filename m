From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: Checksumming RAID?
Date: Mon, 3 Dec 2012 14:24:45 +0200
Message-ID: <20121203122444.GV8912@reaktio.net>
References: <14319197.21.1353936449959.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <14319197.21.1353936449959.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Nov 26, 2012 at 02:27:30PM +0100, Roy Sigurd Karlsbakk wrote:
> Hi all
> 
> I see from an article at http://pages.cs.wisc.edu/~bpkroth/cs736/md-checksums/md-checksums-paper.pdf that an implementation has been made to allow for ZFS-like checksumming inside Linux MD. However, this code doesn't seem to exist in any kernel trees. Does anyone know the current status for data checksumming in MD?
> 

Afaik Linux md-raid raid0 and raid1 already supports T10 PI (Protection Information) and DIF (Data Integrity Fields) / DIX (Data Integrity Extensions).

I wonder if it'd be possible to utilize this mdadm code with normal disks that don't have T10 PI support? ie. implement custom checksums in the "backend" with normal non-PI disks..

T10 PI and DIF/DIX is a SCSI/SAS feature, so it's mostly available in new(ish) enterprise SAS disks and it's not available in SATA.. but I think there are plans to implement something similar in SATA aswell in the future.

A couple of SAS HBAs (mpt2sas, for example) and some FC HBAs support DIF/DIX in Linux.

The purpose of DIF/DIX is to allow passing and verifying end-to-end checksums from all the way from the applications to the disks.. and probably in more common case that'd be checksums all the way from filesystems to the disks.

Some more links about T10 PI and DIF/DIX:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob_plain;f=Documentation/block/data-integrity.txt;hb=HEAD
https://oss.oracle.com/~mkp/docs/dix.pdf
https://oss.oracle.com/~mkp/docs/osd2008-data-integrity.pdf
https://oss.oracle.com/~mkp/docs/ols2008-petersen.pdf
https://oss.oracle.com/~mkp/docs/ppdc.pdf


-- Pasi

