From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Is this enough for us to have triple-parity RAID?
Date: Fri, 20 Apr 2012 23:04:43 +0200
Message-ID: <20120420210443.GB2432@lazy.lzy>
References: <CAMqP1GVnOErhxj8RV=KFtzHHEJqtguEd1L_vmsS=AAi_rAPoVg@mail.gmail.com>
 <4F8D228D.8060005@westcontrol.com>
 <20120417171609.GA2859@lazy.lzy>
 <4F8DD02F.1060504@westcontrol.com>
 <4F905690.3060301@zytor.com>
 <CAMqP1GVjqBMTiM9Yb+PxQLULWDnG8x3uvzuLFKya3NXsTPt_hg@mail.gmail.com>
 <067e21e2-6f21-48a7-93a8-bb2249534155@email.android.com>
 <CAMqP1GXaqtxrSviV1ZhBXopt82ZprjzPFppXvLK36yLkptmXQw@mail.gmail.com>
 <4F91B1C4.5080205@hesbynett.no>
 <4F91BB65.8040304@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4F91BB65.8040304@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Brown <david.brown@hesbynett.no>, Alex <creamyfish@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Peter,

> > Yes, being a generator for GF(2^8) is a requirement for a parity
> > generator (sorry for the confusing terminology here - if anyone has a
> > better suggestion, please say) to be part of a 255 data disk system.
> > However, being a GF generator is necessary but not sufficient - using
> > parity generators (1, 2, 4, 16) will /not/ give quad parity for 255 data
> > disks, even though individually each of 1, 2, 4 and 16 are generators
> > for GF.
[...]
> It is also worth noting that there is nothing magical about GF(2^8).  It
> is just a reasonable tradeoff when tables are needed.

I, then, ask you too.

What is this story that being a generator is not enough?

Is there any reference, documentation, link which can be
studied in order to understand this limitation?

In all RS papers I found, the only constrain put was that
the Vandermonde must be constructed with generators.
Not all RAID examples used them, but no paper, at least
for what I understood, was limiting the generators to
be also "independent".

Any undestandable explanation?

Thanks,

bye,

-- 

piergiorgio
