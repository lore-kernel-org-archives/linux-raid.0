From: Curt <lightspd@gmail.com>
Subject: Re: hung grow
Date: Sun, 8 Oct 2017 21:40:05 -0400
Message-ID: <CADg2FGaeuptaWRnM5+Z_aAR08vG-311s8p6OrBwZUNeCrNGu1g@mail.gmail.com>
References: <CADg2FGbgdgHWbaJN94p36-SUjfDEKNi2VYuyHXJN1pDJ9Kdg7w@mail.gmail.com>
 <cdf0fd70-ec6d-8e9d-6abd-6d9937b6a709@gmail.com> <d1bd0e82-9415-b6f4-2ffa-6e17bf636f34@youngman.org.uk>
 <CADg2FGaNtjN7=wYe6f07xEZ=mW2QFZdjtBFjQLDthn9w3Jw=NA@mail.gmail.com>
 <3173c10a-fbd9-f563-4c90-a9f63e020773@youngman.org.uk> <CADg2FGbSyvLykThXBpMd4MOuHgh2Q_-zPGm-HFxdYW2z4qsNDQ@mail.gmail.com>
 <c583e62d-f4c1-755e-3985-a37164910c2e@youngman.org.uk> <d21f169e-0546-aa00-ce19-b6688ba74da6@turmel.org>
 <CADg2FGbnMzLBqWthKY5Uo__ANC2kAqH_8B1G23nhW+7hWJ=KeA@mail.gmail.com>
 <CADg2FGYc-sPjwukuhonoUUCr3ze3PQWv8gtZPnUT=E4CvsQftg@mail.gmail.com>
 <7e23d39b-aebb-0852-c98f-758bd99d3eb9@turmel.org> <CADg2FGZatpLPHbuJUEuitbipfX77T1XXduEpLTQjPzq2e56fgg@mail.gmail.com>
 <89992d1f-172f-9fc6-3a1e-50df34e11d3b@turmel.org> <CADg2FGaPFTNLuQPussL=YFDCRndRDFX99D-KjnWfD93MqGJXmg@mail.gmail.com>
 <CADg2FGZNs9KmkKGvbCf-dwsqxYN5ftJd5v7RTJ1M=rLP=v6wJg@mail.gmail.com>
 <CADg2FGa5iUGVqVvy5MrJf00fCqH4NEVXrODPHS6Dc=jsrBx2PQ@mail.gmail.com>
 <CADg2FGY97NYLYPk9W3XL_WgbVdCvOWamF6gjbw9zqwPON5h2og@mail.gmail.com> <87po9xyv0r.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87po9xyv0r.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> You get this because sdf1 says:
>
>    Raid Devices : 7
>   Total Devices : 7
>
> while sda1 (for example) says:
>
>    Raid Devices : 8
>   Total Devices : 6
> Preferred Minor : 127
>
>   Reshape pos'n : 3799296 (3.62 GiB 3.89 GB)
>   Delta Devices : 1 (7->8)
>
> mdadm cannot reconcile this difference.
>
> It appears that sdf1 was never involved in any reshape.
> So you need to revert the reshape before trying to include sdf1 into the
> array.  Clearly you need at least 6 devices that were involved in
> the reshape to do this.
> I haven't been following closely ... do you have 6 such devices?
>
> NeilBrown
>

Correct.  Which I thought was sorta the point, but could have
completely misunderstood it, sdf was restored from a "faulty" drive
that was out before the reshape.  Whether I have 6 devices depends on
how picky things are.  I've got 5 that should be in sync, the 6th not,
but it was involved in the reshape.

Short version, is I shot myself in the foot on this one. Reshape never
got anywhere, but need to try to revert and save what data I can.

Cheers,
Curt
