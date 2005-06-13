From: "Diego M. Vadell" <dvadell@lantech.com.ar>
Subject: Re: sata_nv and RAID1
Date: Mon, 13 Jun 2005 18:16:42 -0300
Message-ID: <200506131816.42671.dvadell@lantech.com.ar>
References: <200506111613.42962.dvadell@lantech.com.ar> <200506131351.50610.dvadell@lantech.com.ar> <rn11o2-7c6.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <rn11o2-7c6.ln1@news.it.uc3m.es>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "Peter T. Breuer" <ptb@lab.it.uc3m.es>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 13 June 2005 16:00, you wrote:
> Diego M. Vadell <dvadell@lantech.com.ar> wrote:
> > On Monday 13 June 2005 13:07, Peter T. Breuer wrote:
> > > > > I don't know either. For the FR1 code I implemented three new
> > > > > ioctls .. all of them sent out by the FR1 (raid1) driver.
> > > > >
> > > > >   1) notify component that it is in an array and which
> > > > >   2) notify component that it is no longer in an array and which
> > > > >   3) send component a callback function through which it can
> > > > >      SET_FAULTY and re-HOTADD itself to the array it kno it is in
> > > > >      as need be.
> > > > >
> > > > > Maybe hotplugging has those facilities. I don't know.
> > > > >
> > > > > Cooperating devices would have to implement the ioctls.
> > > >
> > > >    If I understand right, even if I used FR1, it wont pass the test
> > >
> > > Yes it will. The device driver will detect something wrong (if the
> > > device driver doesn't know, NOBODY does) and call back to the raid
> > > array driver to say "set me faulty".
> > >
> > > That's the whole idea.
> > >
> > > When the device driver senses its device is well again, it will call
> > > back and say "hot add me again".
> >
> > But not as it is today...
>
> Yes, "as it is today".
>
> > when you say "Cooperating devices would have to
> > implement the ioctls." means that I have to touch sata_nv's source code
> > to implement those ioctls, am I right?
>
> One has to implement or have implemented those ioctls in the driver of
> whichever device you are interested in, in order to cooperate properly
> with fr1 (in that respect).  That goes without saying.  I merely provided
> the infrastructure in fr1 - indeed, I could not have provided anything
> else because I do not control the code for anything else. Fr1 will send
> the ioctls I listed above (or sketched, rather) to any component device.
> It is up to that component device to make use of them.
>
> There may well be another scheme/architecture already available. I
> don't know. In my abject ignorance I simply implemented an adequate
> scheme for my purposes, and waited for anyone to tell me of a better
> one.  If hotplugging is supported by the target device, it may well be
> the case that you could implement at least ioctl (3) via hotplugging.
>
> Ioctls (1) and (2) are merely informative. They courteously let the
> target device know that it has been included in (or excluded from) a
> particular md array. This allows the target device to make any mode
> shifts that may be appropriate to running in a raid array, such as
> exposing errors immediately to the array instead of blocking and trying
> again internally (or vice versa -). It also allows the target device
> to decide when or if to make use of the callback function provided to
> it in ioctl (3), with which it can tell the raid arrays in which it has
> been informed that it has been included of its current state of health.
>
> > If that is all I have to do, I will give it a try (supposing my boss does
> > not make me use the raid in the motherboard) .
>
> The enbd code (ftp://oboe.it.uc3m.es/pub/Programs/enbd-2.4.32pre.tgz)
> implements the ioctls in question.
>
> If you know of another scheme, please feel free to tell me about it.
>
> My idea was that the target device should preemptively inform the array
> if it is in good or bad health. This implies that it should know in
> which array it is included, in order to know who is interested in
> knowing its health. Hence ioctls (1) and (2) which tell it who wishes
> to be informed about its health. And ioctl (3) which gives it a
> telephone number to use.
>
> Ioctl (3) could be implemented the other way round - that is, it could
> be simply the md array which receives an existing SETFAULTY or HOTADD
> ioctl. I don't know why I chose to send across a callback function to
> the target device instead. Probably because I was aware of locking
> difficulties.
>
>
> Peter

Peter,
   thanks you very much. When I recieved your mail, I was already trying Jeff 
Garzik's solution. Basically, if that doesn't work, I have to put the server 
in production with whatever it has, and I will be unable to make more tests.
   But besides my problem, Fast Raid seems a very good idea! Is it any reason 
why it isn't in the mainline kernel?

 -- Diego.
