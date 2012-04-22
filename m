From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Is this enough for us to have triple-parity RAID?
Date: Sun, 22 Apr 2012 10:57:00 +0200
Message-ID: <20120422085659.GA2893@lazy.lzy>
References: <CAMqP1GVjqBMTiM9Yb+PxQLULWDnG8x3uvzuLFKya3NXsTPt_hg@mail.gmail.com>
 <067e21e2-6f21-48a7-93a8-bb2249534155@email.android.com>
 <CAMqP1GXaqtxrSviV1ZhBXopt82ZprjzPFppXvLK36yLkptmXQw@mail.gmail.com>
 <4F91B1C4.5080205@hesbynett.no>
 <20120420210106.GA2432@lazy.lzy>
 <20369.54567.60804.896644@tree.ty.sabi.co.UK>
 <20120420223138.GA11308@lazy.lzy>
 <20370.33554.998900.245328@tree.ty.sabi.co.UK>
 <20120421111848.GA28576@lazy.lzy>
 <CAMqP1GXvGdC_Ff7+tpSqvppfTgQU-2cTdzrcaeqqeDUsRMj81w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAMqP1GXvGdC_Ff7+tpSqvppfTgQU-2cTdzrcaeqqeDUsRMj81w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alex <creamyfish@gmail.com>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Alex,

> Just being curious, any mathematical improvement in Reed-Solomon's
> code like the
> RS(96,64) you mentioned? The calculation of RS involves arbitrary
> multiplication in a
> Galois field and table look-up has to be used. Has that already chang=
ed?

AFAIK (details are not public) it uses the stardard
RS with LUT operations.

Considering that this is for network disks, I suppose
there is no performance problem.

The RS(255,223) or RS(160,128) are very old encoding
schemes, we talk about Voyager space probe here.

What I know about improvement, is the decoding using
the Berlekamp=E2=80=93Massey algorithm.
This is quite hard, since it also find *where* error
are, but it seems there is some work out there on
how to implement it very efficiently.

My personal opinion is that the first thing to do is
to have a working system, later it could be possible
to improve performance by different optimizations.

=46or example LUT multiplication might or might not be
the best way, but at first it is the easy way to do it.

bye,

--=20

piergiorgio
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
