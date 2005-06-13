From: "Diego M. Vadell" <dvadell@lantech.com.ar>
Subject: Re: sata_nv and RAID1
Date: Mon, 13 Jun 2005 18:41:32 -0300
Message-ID: <200506131841.32850.dvadell@lantech.com.ar>
References: <200506111613.42962.dvadell@lantech.com.ar> <200506131800.31956.dvadell@lantech.com.ar> <42ADF8B2.5010501@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42ADF8B2.5010501@pobox.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 13 June 2005 18:20, you wrote:
> You need to go into the SCSI layer and figure out how to do it.
>
> Calling scsi_remove_device() in the appropriate place is a good start.
> Add a debounce timer.  Make sure all commands are completed with an
> error (avoids memory leaks and lock-ups).  Other details.
>
> Hot unplug is not just a simple function call...
>
> 	Jeff
thank you Jeff! I dont think I will be able to do it, though. Thank you for 
the fast answers.

 -- Diego.
