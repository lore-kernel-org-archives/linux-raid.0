From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: sata_nv and RAID1
Date: Mon, 13 Jun 2005 18:07:15 +0200
Message-ID: <jin0o2-eg1.ln1@news.it.uc3m.es>
References: <200506111613.42962.dvadell@lantech.com.ar> <42AD74BD.8050704@tls.msk.ru> <gma0o2-jck.ln1@news.it.uc3m.es> <200506131140.54982.dvadell@lantech.com.ar>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Diego M. Vadell <dvadell@lantech.com.ar> wrote:
> On Monday 13 June 2005 09:27, Peter T. Breuer wrote:

> > I don't know either. For the FR1 code I implemented three new ioctls ..
> > all of them sent out by the FR1 (raid1) driver.
> >
> >   1) notify component that it is in an array and which
> >   2) notify component that it is no longer in an array and which
> >   3) send component a callback function through which it can
> >      SET_FAULTY and re-HOTADD itself to the array it kno it is in
> >      as need be.
> >
> > Maybe hotplugging has those facilities. I don't know.
> >
> > Cooperating devices would have to implement the ioctls.



>    If I understand right, even if I used FR1, it wont pass the test 

Yes it will. The device driver will detect something wrong (if the
device driver doesn't know, NOBODY does) and call back to the raid array
driver to say "set me faulty".

That's the whole idea.

When the device driver senses its device is well again, it will call
back and say "hot add me again".

Peter

