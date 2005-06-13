From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: sata_nv and RAID1
Date: Mon, 13 Jun 2005 15:57:49 +0400
Message-ID: <42AD74BD.8050704@tls.msk.ru>
References: <200506111613.42962.dvadell@lantech.com.ar> <20050611192606.GA4055@pentafluge.infradead.org> <42AB49BC.50104@tls.msk.ru> <42AD2B85.30303@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42AD2B85.30303@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: "Diego M. Vadell" <dvadell@lantech.com.ar>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jeff Garzik wrote:
[linux I/O layer loops forever on SATA drive unplug;
  SATA hotplug is unsupported yet]

>> It isn't hotPLUG -- it's hotUNplug.  Happens when drive is dying for
> 
> Same difference to me:  both require new code.

Jeff,

I didn't want to blame you or anyone else (just in case
if that wasn't clear).  Instead, I just wanted to understand
what's the current state of the whole thing.  I know SATA
hotplug is unsupported, and some code has to be written for
that to work.  But I don't know if hotUNplugging and error
handling comes together.  That is, is there a difference
between real drive failure (and oh, there are alot of various
failure scenarios too, from bad block, including a drive dying
completely during normal operations as if there wa no drive at
all, up to unplugging the cable by a mistake) and such hot-
UN-plugging?  Will current code notice and properly propagate
I/O errors on the drive, or drive dying?  If some errors are
propagated properly now, Where's the "boundary" between I/O
errors (implemented) and hotplug (not implemented)?

This all is quite important IMHO.  Without proper error handling
(if I/O errors are "blacked" by that "boundary" too), linux SATA
subsystem isn't ready for production, and people should not
rely on it *now*.

/mjt
