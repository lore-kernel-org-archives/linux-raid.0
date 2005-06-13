From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: sata_nv and RAID1
Date: Mon, 13 Jun 2005 14:27:28 +0200
Message-ID: <gma0o2-jck.ln1@news.it.uc3m.es>
References: <200506111613.42962.dvadell@lantech.com.ar> <20050611192606.GA4055@pentafluge.infradead.org> <42AB49BC.50104@tls.msk.ru> <42AD2B85.30303@pobox.com> <42AD74BD.8050704@tls.msk.ru>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Tokarev <mjt@tls.msk.ru> wrote:
> Jeff Garzik wrote:
> [linux I/O layer loops forever on SATA drive unplug;
>   SATA hotplug is unsupported yet]

> >> It isn't hotPLUG -- it's hotUNplug.  Happens when drive is dying for
> > 
> > Same difference to me:  both require new code.

> I didn't want to blame you or anyone else (just in case
> if that wasn't clear).  Instead, I just wanted to understand
> what's the current state of the whole thing.  I know SATA
> hotplug is unsupported, and some code has to be written for
> that to work.  But I don't know if hotUNplugging and error
> handling comes together.  That is, is there a difference

I don't know either. For the FR1 code I implemented three new ioctls ..
all of them sent out by the FR1 (raid1) driver. 

  1) notify component that it is in an array and which
  2) notify component that it is no longer in an array and which
  3) send component a callback function through which it can 
     SET_FAULTY and re-HOTADD itself to the array it kno it is in
     as need be.

Maybe hotplugging has those facilities. I don't know.

Cooperating devices would have to implement the ioctls.

Peter

