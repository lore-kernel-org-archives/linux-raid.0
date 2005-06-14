From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: sata_nv and RAID1
Date: Tue, 14 Jun 2005 23:11:49 +0200
Message-ID: <62b0912f050614141172e4a99b@mail.gmail.com>
References: <200506111613.42962.dvadell@lantech.com.ar>
	 <200506131351.50610.dvadell@lantech.com.ar>
	 <42ADC98C.6060808@pobox.com>
	 <200506131800.31956.dvadell@lantech.com.ar>
	 <42ADF8B2.5010501@pobox.com>
Reply-To: Molle Bestefich <molle.bestefich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42ADF8B2.5010501@pobox.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jeff Garzik wrote:
> The task is to update sata_nv to notify libata-core that a device
> has disappeared.  libata-core then notifies the SCSI layer of this.
> No new ioctls need to be supported.

> Calling scsi_remove_device() in the appropriate place is a good start.
> Add a debounce timer.  Make sure all commands are completed with an
> error (avoids memory leaks and lock-ups).  Other details.

Could you explain why a debounce timer is needed and what the other
details that need to be taken care of are?
