From: Jon Hardcastle <jd_hardcastle@yahoo.com>
Subject: Re: Adding more drives/saturating the bandwidth
Date: Wed, 1 Apr 2009 01:56:14 -0700 (PDT)
Message-ID: <771992.67269.qm@web51307.mail.re2.yahoo.com>
References: <87myb1ieoq.fsf@frosties.localdomain>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87myb1ieoq.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com, Goswin von Brederlow <goswin-v-b@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



--- On Tue, 31/3/09, Goswin von Brederlow <goswin-v-b@web.de> wrote:

> From: Goswin von Brederlow <goswin-v-b@web.de>
> Subject: Re: Adding more drives/saturating the bandwidth
> To: Jon@eHardcastle.com
> Cc: "Goswin von Brederlow" <goswin-v-b@web.de>, linux-raid@vger.kernel.org
> Date: Tuesday, 31 March, 2009, 10:07 PM
> Jon Hardcastle <jd_hardcastle@yahoo.com> writes:
> 
> > --- On Mon, 30/3/09, Goswin von Brederlow
> <goswin-v-b@web.de> wrote:
> >
> >> From: Goswin von Brederlow
> <goswin-v-b@web.de>
> >> Subject: Re: Adding more drives/saturating the
> bandwidth
> >> To: Jon@eHardcastle.com
> >> Cc: linux-raid@vger.kernel.org
> >> Date: Monday, 30 March, 2009, 4:40 PM
> >> Jon Hardcastle <jd_hardcastle@yahoo.com>
> writes:
> >> 
> >> > Hey guys, How do you know if your machine can
> handle
> >> adding some more drives to it? How can you check
> that there
> >> is enough BUS IO to handle extra sata cards and
> also that
> >> the machine is powerful enough to support say an 8
> drive
> >> raid 5...
> >> 
> >> A) Try & error.
> >> B) look up the speed of the bus and half it. Any
> bandwidth
> >> left?
> >>    make sure the cpu isn't at 100% already as
> well
> >> 
> >> MfG
> >>         Goswin
> >
> > Cheers guys, I dont think CPU will be an issue as when
> i looked yesterday whilst copying to my 6 drive raid 5 array
> it was at ~10% (the only time i get access issues is when i
> am smart checking all 6 discs and trying to stream a movie
> of it at the same time!)
> >
> > As for try and error... sounds scary as once I have
> added a drive to the array I can undo the process! I suppose
> I could add them as JBOD's and then thrash the hell out
> of them.. whilst accessing the rest of the array... What
> does halving the bus speed tell me in anycase?
> 
> Just see if you can get a decent bandwidth from each disk:
> 
> for i in /dev/sd?; do dd if=$i of=/dev/null bs=1M
> count=10240 & done
> iostat -k 10
> 
> 
> Halving the bus speed gives you a reasonable low
> expectation of how
> much data you should be able to pull of the disks. If your
> disks can't
> even fill half the bus bandwidth you certainly can cope
> with more
> disks or something is seriously wrong.
> 
> MfG
>         Goswin
> --


Whoops! of course it isn't; sorry. it is presumably a read test thought rather than a read/write? Safe to do whilst the array is constructed?

-----------------------
N: Jon Hardcastle
E: Jon@eHardcastle.com
'..Be fearful when others are greedy, and be greedy when others are fearful.'
-----------------------
