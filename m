From: Curt <lightspd@gmail.com>
Subject: Re: hung grow
Date: Tue, 10 Oct 2017 10:11:15 -0400
Message-ID: <CADg2FGad+Tpu-4Z4rx1Kx_U1Tw64nQ_FqGuPRn5ODV=_pYFuDw@mail.gmail.com>
References: <CADg2FGbgdgHWbaJN94p36-SUjfDEKNi2VYuyHXJN1pDJ9Kdg7w@mail.gmail.com>
 <CADg2FGbnMzLBqWthKY5Uo__ANC2kAqH_8B1G23nhW+7hWJ=KeA@mail.gmail.com>
 <CADg2FGYc-sPjwukuhonoUUCr3ze3PQWv8gtZPnUT=E4CvsQftg@mail.gmail.com>
 <7e23d39b-aebb-0852-c98f-758bd99d3eb9@turmel.org> <CADg2FGZatpLPHbuJUEuitbipfX77T1XXduEpLTQjPzq2e56fgg@mail.gmail.com>
 <89992d1f-172f-9fc6-3a1e-50df34e11d3b@turmel.org> <CADg2FGaPFTNLuQPussL=YFDCRndRDFX99D-KjnWfD93MqGJXmg@mail.gmail.com>
 <CADg2FGZNs9KmkKGvbCf-dwsqxYN5ftJd5v7RTJ1M=rLP=v6wJg@mail.gmail.com>
 <CADg2FGa5iUGVqVvy5MrJf00fCqH4NEVXrODPHS6Dc=jsrBx2PQ@mail.gmail.com>
 <87po9xyv0r.fsf@notabene.neil.brown.name> <CADg2FGaeuptaWRnM5+Z_aAR08vG-311s8p6OrBwZUNeCrNGu1g@mail.gmail.com>
 <87d15xymgc.fsf@notabene.neil.brown.name> <CADg2FGbzr_JcrGfvU6kpGc_5vJ=+L2gXx3PcfpOTsst8BeNA-Q@mail.gmail.com>
 <CADg2FGaFt4_4UHPUSnY8tr=LeJMKKojR_QrPE-YoXvWmgXXZxQ@mail.gmail.com>
 <0d4987d9-e8ff-0cdb-6e45-7f962b75c189@turmel.org> <3e5766b0-1437-2857-4806-264386d1633f@youngman.org.uk>
 <6d4b7055-c26c-951e-b63c-273a7fe447b8@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6d4b7055-c26c-951e-b63c-273a7fe447b8@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Anthony Youngman <antlists@youngman.org.uk>, NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>
> I've never seen this before, and don't have time at the moment
> to read the code to understand what it means.
I did a search and here's the comment before the code I found spits
out that error message.  I don't know if it's useful to you
/* reshape_position is a little messy.
* Its value must be a multiple of the larger
* chunk size, and of the "after" data disks.
* So when reverting we need to change it to
* be a multiple of the new "after" data disks,
* which is the old "before".
* If it isn't already a multiple of 'before',
* the only thing we could do would be
* copy some block around on the disks, which
* is easy to get wrong.
* So we reject a revert-reshape unless the
* alignment is good.
*/
if (reshape_sectors % reshape_chunk)

That doesn't read good for me.
>
>
> Probably.  But yeah, "fit state".  That's the magic. /-:
>
What are the chances if I just do an assemble and let it try to grow
again that it will complete without issue? Then assuming it completes,
that I will have most my data still?

Cheers,
Curt
