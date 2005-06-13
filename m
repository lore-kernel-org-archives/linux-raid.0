From: "Diego M. Vadell" <dvadell@lantech.com.ar>
Subject: Re: sata_nv and RAID1
Date: Mon, 13 Jun 2005 13:51:50 -0300
Message-ID: <200506131351.50610.dvadell@lantech.com.ar>
References: <200506111613.42962.dvadell@lantech.com.ar> <200506131140.54982.dvadell@lantech.com.ar> <jin0o2-eg1.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <jin0o2-eg1.ln1@news.it.uc3m.es>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "Peter T. Breuer" <ptb@lab.it.uc3m.es>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 13 June 2005 13:07, Peter T. Breuer wrote:
> > > I don't know either. For the FR1 code I implemented three new ioctls ..
> > > all of them sent out by the FR1 (raid1) driver.
> > >
> > >   1) notify component that it is in an array and which
> > >   2) notify component that it is no longer in an array and which
> > >   3) send component a callback function through which it can
> > >      SET_FAULTY and re-HOTADD itself to the array it kno it is in
> > >      as need be.
> > >
> > > Maybe hotplugging has those facilities. I don't know.
> > >
> > > Cooperating devices would have to implement the ioctls.
> >
> >    If I understand right, even if I used FR1, it wont pass the test
>
> Yes it will. The device driver will detect something wrong (if the
> device driver doesn't know, NOBODY does) and call back to the raid array
> driver to say "set me faulty".
>
> That's the whole idea.
>
> When the device driver senses its device is well again, it will call
> back and say "hot add me again".
>
> Peter

But not as it is today... when you say "Cooperating devices would have to 
implement the ioctls." means that I have to touch sata_nv's source code to 
implement those ioctls, am I right?
If that is all I have to do, I will give it a try (supposing my boss does not 
make me use the raid in the motherboard) . 

Thanks a lot,
 -- Diego.
