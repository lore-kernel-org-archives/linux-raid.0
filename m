From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: raid6check extremely slow ?
Date: Tue, 12 May 2020 18:05:19 +0200
Message-ID: <20200512160519.GA7261@lazy.lzy>
References: <20200510120725.20947240E1A@gemini.denx.de>
 <2cf55e5f-bdfb-9fef-6255-151e049ac0a1@cloud.ionos.com>
 <20200511064022.591C5240E1A@gemini.denx.de>
 <f003a8c7-e96d-ddc3-6d1d-42a13b70e0b6@cloud.ionos.com>
 <20200511161415.GA8049@lazy.lzy>
 <CAOxFTcyH8ET=DXsm7RQ3eVbxg+6g+nX-apwahBejniGz1QR2+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOxFTcyH8ET=DXsm7RQ3eVbxg+6g+nX-apwahBejniGz1QR2+g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, Wolfgang Denk <wd@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, May 11, 2020 at 10:53:05PM +0200, Giuseppe Bilotta wrote:
> Hello Piergiorgio,
> 
> On Mon, May 11, 2020 at 6:15 PM Piergiorgio Sartor
> <piergiorgio.sartor@nexgo.de> wrote:
> > Hi again!
> >
> > I made a quick test.
> > I disabled the lock / unlock in raid6check.
> >
> > With lock / unlock, I get around 1.2MB/sec
> > per device component, with ~13% CPU load.
> > Wihtout lock / unlock, I get around 15.5MB/sec
> > per device component, with ~30% CPU load.
> >
> > So, it seems the lock / unlock mechanism is
> > quite expensive.
> >
> > I'm not sure what's the best solution, since
> > we still need to avoid race conditions.
> >
> > Any suggestion is welcome!
> 
> Would it be possible/effective to lock multiple stripes at once? Lock,
> say, 8 or 16 stripes, process them, unlock. I'm not familiar with the
> internals, but if locking is O(1) on the number of stripes (at least
> if they are consecutive), this would help reduce (potentially by a
> factor of 8 or 16) the costs of the locks/unlocks at the expense of
> longer locks and their influence on external I/O.

Probabily possible, from the technical
point of view, even if I do not know
either the effect.

From the coding point of view, a bit
tricky, boundary conditions and so on
must be properly considered.

> 
> --
> Giuseppe "Oblomov" Bilotta

-- 

piergiorgio
