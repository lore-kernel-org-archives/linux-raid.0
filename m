From: "Diego M. Vadell" <dvadell@lantech.com.ar>
Subject: Re: sata_nv and RAID1
Date: Mon, 13 Jun 2005 11:40:54 -0300
Message-ID: <200506131140.54982.dvadell@lantech.com.ar>
References: <200506111613.42962.dvadell@lantech.com.ar> <42AD74BD.8050704@tls.msk.ru> <gma0o2-jck.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <gma0o2-jck.ln1@news.it.uc3m.es>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "Peter T. Breuer" <ptb@lab.it.uc3m.es>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 13 June 2005 09:27, Peter T. Breuer wrote:

> I don't know either. For the FR1 code I implemented three new ioctls ..
> all of them sent out by the FR1 (raid1) driver.
>
>   1) notify component that it is in an array and which
>   2) notify component that it is no longer in an array and which
>   3) send component a callback function through which it can
>      SET_FAULTY and re-HOTADD itself to the array it kno it is in
>      as need be.
>
> Maybe hotplugging has those facilities. I don't know.
>
> Cooperating devices would have to implement the ioctls.
>
> Peter

Hi Peter,
   If I understand right, even if I used FR1, it wont pass the test 
(unplugging the cable). Notice that Im not interested int hotplugging, but in 
hotUNplugging it as Michael Tokarev said: unplug the cable, linux starts 
using a degraded mirror, and later I can shutdown the server, plug the disk 
and let it resync.

Thanks,
 -- Diego.
