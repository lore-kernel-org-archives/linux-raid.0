From: Derek Vadala <derek@cynicism.com>
Subject: Re: Linux dpti driver in 2.4 kernel with Adaptec 2400A card
Date: Mon, 6 Jan 2003 19:44:46 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030107004446.351E93B807@jaded.cynicism.com>
References: <3E1A10D0.7080603@etr-usa.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3E1A10D0.7080603@etr-usa.com>
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Oliver Elphick wrote:
> I'm trying to install Debian Linux with kernel 2.4.20 on a machine with an
> Adaptec 2400A RAID card with 3 40Gb IDE disks attached.
>
> [snip]
>
> dpti0: Trying to reset device
> dpti0: Device reset not supported
> dpti0: Bus reset: SCSI Bus 0: tid: 11
> dpti0: Bus reset success.
> scsi: device set offline - not ready or command retry failed after bus reset: host 0 channel 0 id 0 lun 0
> SCSI disk error:  host 0 channel 0 id 0 lun 0 return code = 30002
>  I/O error: dev 08:00, sector 0
>  I/O error: dev 08:00, sector 2
>  I/O error: dev 08:00, sector 0
>  unable to read partition table

There have been known compatability issues with drive firmware and Adaptec
controllers. I've experienced these personally with IBM SCSI disks and a
2100S, but I'm sure it could extended to other controllers and disks. It
was listed as a known issue on the Adaptec web site for a while. Cabling
also seems like a probably cause though. I'd check that first since disk
firmware can sometimes be a headache to upgrade. Upgrading the controller
firmware is step one if you haven't already done that.

