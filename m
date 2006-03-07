From: "Francois Barre" <francois.barre@gmail.com>
Subject: Re: [RFC] Generic Migration
Date: Tue, 7 Mar 2006 14:07:48 +0100
Message-ID: <fd8d0180603070507v12d8bfa7i@mail.gmail.com>
References: <fd8d0180603010459j316a8776j@mail.gmail.com>
	 <17420.54727.866701.153409@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17420.54727.866701.153409@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2006/3/7, Neil Brown <neilb@suse.de>:
> Thank you for your thoughts.
You welcome !

[...]
> So an upsize migration from any of these level to any other could be
> done within the raid6 code providing the raid6 code could cope with an
> array where the Q block was not present (which is often the case in a
> degraded array anyway).
>
> So to perform an generic upsize migration, I would:
>   switch to raid6 mode with appropriate layout
>   perform the growth within raid6
>   switch back to more appropriate module.
>
You seem to be really keen on raid6 for these topics ; I may have a
closer look on this layer to really understand why you wish to rely on
this for these issues...
Can it really be possible to teach raid6 how to handle such different layouts ?

> For stable migration you really to need to log to a separate device.
> This would be slow, but not impossible.  It could be done with the
> 'grow' function in raid6 and so the above approach would still work.
Well, I think so. I would really like to work on such things,
including the use of an external drive (external WRT raid), to harden
such things...

> The only complication comes with raid10.
Here, I shall agree...
[...]

> NeilBrown
>

BTW, I could not find any kind of git tree nor svn containing
experimental works on raid, (f.e. including your raid5 reshape
code...). Does this exist ?
I would also be interrested in hardening mdadm for your raid5 reshape
patch (i.e. fixing the vulnerability issue at the beginning of the
reshape). Is http://www.cse.unsw.edu.au/~neilb/source/mdadm/ the only
place where you store mdadm versions ?
