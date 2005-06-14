From: Mike Hardy <mhardy@h3c.com>
Subject: Re: sata_nv and RAID1
Date: Tue, 14 Jun 2005 16:46:20 -0700
Message-ID: <42AF6C4C.206@h3c.com>
References: <200506111613.42962.dvadell@lantech.com.ar>	 <20050611192606.GA4055@pentafluge.infradead.org>	 <42AB49BC.50104@tls.msk.ru> <42AD2B85.30303@pobox.com>	 <42AD74BD.8050704@tls.msk.ru>	 <62b0912f05061414116f7afedc@mail.gmail.com>	 <42AF4E17.2040900@tls.msk.ru> <62b0912f0506141526358647d0@mail.gmail.com> <42AF631C.1050806@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42AF631C.1050806@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Molle Bestefich <molle.bestefich@gmail.com>, Michael Tokarev <mjt@tls.msk.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Bill Davidsen wrote:

> Actually I suspect most Linux users are smart enough not to pull a PATA
> drive out while in use, and it works just fine if you offline the drive
> before removal. I may be wrong recently, it seems that the ability to
> disable the interface was taken out of either hdparm or a recent kernel.
> I read about, exchange comments with Alan Cox, and I don't recall the
> details.
> 
> There may have been a step backward, hopefully just a brain fart and not
> a deliberate decision to disable hot swap.

This is barely pertinent to the original discussion, but I still use
hdparm -[U|R] to enable/disable an interface and attach/detach an
optical drive on my laptop (Dell D800 - not that new or fancy anymore).

It works fine, as far as I can tell, once you get udev to have the
devices in /dev/ for you

Partial uname:
2.6.11-1.27_FC3 #1 Tue May 17 20:27:37 EDT 2005 i686

Hopefully they haven't disabled it after that, I'll be disappointed.

I do agree in general that SMART support for SATA at least should be in
kernels by this point, and correct error propagation as well. Perhaps
all the kernel devs either don't get the new hardware, or they're on
SCSI though. I'm still building with PATA until SATA's got it all anyway.

-Mike
