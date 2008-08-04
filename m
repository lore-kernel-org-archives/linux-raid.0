From: Michal Przyluski <mikylie@gmail.com>
Subject: Re: RAID5 to RAID6 migration
Date: Mon, 4 Aug 2008 20:18:34 +0200
Message-ID: <200808042000.35343@rosamund>
References: <6c4602af0808040544k2b1a3028vf0867a9b32958b25@mail.gmail.com> <20080804075758.2d7cdd6b@hardcode42.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080804075758.2d7cdd6b@hardcode42.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Conway S. Smith" <beolach@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thank you for your agile response, 

On Monday 04 August 2008 15:57, Conway S. Smith wrote:
> Why are you thinking you'll have to totally recreate your raid anyway?
> (I'm assuming you meant even if RAID5->6 reshape was possible, you'd
> still be recreating it instead of reshaping).

No actually, I'd really prefer to  reshape it, but I've been somehow 
suspecting the bad news incoming.

> > I see the following ways, supposing there's no reshape from raid5
> > to raid6.
> >
> > 1. Copy stuff to 2 new hdds (not raid'ed), create a slightly
> > degraded raid6 out of old 3 hdds (making raid6 looks like it should
> > have had 4), copy stuff over to raid6, and then add/reshape/etc.
> >
> > 2. Create a totally degraded raid6 with 2 new hdds, lacking 2
> > drives. Copy from current, operational, raid5, and then
> > add/reshape/etc.
> >
> > 3. (risky) Check current raid5, and if it's checks ok, degrade it!
> > Create a 4 hdd raid6 (4 out of 4 operational), copy stuff from
> > degraded raid5, add/reshape/etc.
>
> I'd actually lean towards a fourth option: keeping the existing
> RAID5, possibly reshaped to add more space on a new disk, and then
> have another new disk as a hot spare.  Not as good redundancy as
> moving to RAID6, but much simpler w/ the current md feature set.
> Except above you said you thought you'd have to recreate the array
> anyway, in which case you may as well go to RAID6 now.  Of the three
> methods you show, I think #2 looks best, as it only involves one copy
> step.  The totally degraded RAID6 will be slow, but I doubt as slow
> as another copy step.

Keeping a RAID5 would be a great idea, and with a still rather small array, 
I think it could resync with a hot spare in about 4 hours. I'm on the safe 
side, I guess. 
Problem is, that I'd really like to move onto a RAID6 at some 
point, and, if I have to copy all the data to a temporary location, it's 
easier to do now, than few months later, with, say, 2 times more data.

Crikey, I've realised that all my "ideas" are bad actually, they wouldn't 
survive any drive failure during the procedure. I think I'm gonna spend extra 
100E on 3rd drive, and set up a slightly less degraded raid6. Knowing 
tricks, things tend to fail in worst possible moment. 

Best regards, 
MK

PS: Sorry for some garbage at the end of my previous message, I have no idea 
what made gmail do that.
