From: Curt <lightspd@gmail.com>
Subject: Re: hung grow
Date: Mon, 9 Oct 2017 00:59:22 -0400
Message-ID: <CADg2FGZLkpd9txc4wCQgy8FH-sEPsg24mh4xL8f39hb+Uparng@mail.gmail.com>
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
 <87po9xyv0r.fsf@notabene.neil.brown.name> <CADg2FGaeuptaWRnM5+Z_aAR08vG-311s8p6OrBwZUNeCrNGu1g@mail.gmail.com>
 <87d15xymgc.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87d15xymgc.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Oct 9, 2017 at 12:28 AM, NeilBrown <neilb@suse.com> wrote:
> On Sun, Oct 08 2017, Curt wrote:
> Theoretically that should work.  Was it deliberate? (I cannot seem to
> find the start of the thread).
Yes and no, I ran the command, but it wasn't what I really wanted
and/or needed, so to speak.


> are all valid devices with the same event counts.  They are the six that
> you need.
> To confirm that names haven't changed, you can:
>   mdadm --examine  /dev/sdg1 /dev/sdd1 /dev/sdc1 /dev/sda1 /dev/sde1 \
>   /dev/sdb | grep Events

Yes, the numbers all match.
>
> and confirm all the numbers are the same.
> Then do the same and grep for "this" and confirm all the Raid Disk
> numbers are different.
confirmed
>
> Interesting that /dev/sdb is a whole device and the rest are partitions.
> I assume you know about that and why it is.
Just a mistake when I added it.
>
> What happens if you run the --assemble --update=revert-reshape command on
> these 6 devices (without --force)??
>
> NeilBrown
I'll give it a try, but first a question and FYI.  Earlier Phil had me
ddrescue sde1 because it had pending sectors I believe.  Should I use
sde1 or sdz1(ddrescued version)?

Also when this whole thing started. md127_raid process was using 100%
cpu, but nothing seemed to be happening, No numbers changed, nothing
that I could tell anyway.  Any suggestions on if the same thing
happens when I run the revert-reshape? Could one of my libraries be
behind a version somewhere?

Cheers,
Curt
