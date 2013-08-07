From: P Orrifolius <porrifolius@gmail.com>
Subject: Re: Advice for recovering array containing LUKS encrypted LVM volumes
Date: Wed, 7 Aug 2013 14:22:06 +1200
Message-ID: <CAC38o7S3BvM0t2Q24z1FjnEDwk7-nimQPBGKQRxfEAPqyg1=dw@mail.gmail.com>
References: <CAC38o7ScozDqspEH-FSyoa_W5W8s+VfYd1RTAitz574wMYqhkA@mail.gmail.com>
	<51FE529C.6000502@hardwarefreak.com>
	<CAC38o7TqO9m=6LDHxDiV=XYcfAdbnpa=GZuft-TAqFDvdqvJ4A@mail.gmail.com>
	<52015093.3040100@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52015093.3040100@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 7 August 2013 07:37, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> On 8/5/2013 8:54 PM, P Orrifolius wrote:

> Newegg sells these Vantecs for $100 USD each.  For not substantially
> more than what you spent on two of these and the USB3 controller, given
> the increase in reliability, performance, and stability, you could have
> gone with a combination of quality consumer and enterprise parts to
> achieve a fast and stable RAID.  You could have simply swapped your PC
> chassis and PSU, acquired a top notch 8 port SAS/SATA HBA, two SFF8087
> to discrete SATA breakout cables, and 3 Molex to SATA power splitters.
> For example:
>
> http://www.newegg.com/Product/Product.aspx?Item=N82E16811124156
> http://www.newegg.com/Product/Product.aspx?Item=N82E16817170018
> http://www.newegg.com/Product/Product.aspx?Item=N82E16816118112
> http://www.newegg.com/Product/Product.aspx?Item=N82E16816132040 x2
> http://www.newegg.com/Product/Product.aspx?Item=N82E16812422777 x3
>
> Total:  $355 USD
>
> This would give you plenty of +12VDC power for all drives concurrently
> (unlike the Vantec wall wart transformers), rock solid stability, full
> bandwidth to/from all drives, and at least 20x better drive cooling than
> the Vantecs.

Thanks for taking the time to make these recommendations, I will
certainly reassess that style of solution.

Just to give a little economic context, so as not to appear heedless
of your advice, the relative prices of things are a bit different
here.
A Vantec costs about USD125, the LSI about USD360.  Anything vaguely
enterprise-y or unusual tends to attract a larger markup.  And if you
take purchasing power into account that LSI probably equates to about
USD650 of beer/groceries... not directly relevant but it does mean the
incremental cost is harder to bear.

All that said data loss is grim and, by the sounds of your email, just
switching to eSATA won't help me much in terms of reliability.


Putting cost aside, and the convenience of having occasionally just
taken the two enclosures elsewhere for a few days, my biggest problem
is an adequately sized and ventilated case.

Ideally it would have 10 3.5" bays, 8 for the RAID6 and 2 for the
RAID1 holding the system.  Though once the RAID6 isn't 'mobile' I
guess I could do away with the existing RAID1 pair and shuffle the
system onto the 8 drives... quite a mission though.
The Enermax looks good, especially regarding ventilation, but is not
available here.  I know from having 6 drives in 6 bays with a single
120mm HDD cage fan in my existing case that some drives get very hot.
Unfortunately I can't find anything like the Enermax locally, I'll
keep looking though.


Anyway, thanks for prompting the reassessment.



>> Good news is I worked through the recovery instructions, including
>> setting up the overlays (due to an excess of paranoia), and I was able
>> to mount each XFS filesystem and get a seemingly good result from
>> xfs_repair -n.
>
> You can't run xfs_repair on a mounted filesystem, so I assume you simply
> have the order of events reversed here.

I mounted, to make sure the log was replayed, then unmounted, then
xfs_repair'd... I forgot to mention the unmounting.

> "Seemingly" makes me
> wonder/worry.  If errors are found they are noted in the output.  There
> is no ambiguity.  "-n" means no modify, so any errors that might have
> been found, and displayed, were not corrected.

I was imprecise... xfs_repair -n exited with 0 for each filesystem, so
that was a good result.  'Seemingly' because I didn't believe that it
had actually checked 8TB of data in the time it took... as you say the
data may still be mangled.

> The solution I described above is likely more than you wish to spend to
> fix this problem, but it is a tiny sum to part with considering the
> stability and performance you'll gain.  Add the fact that once you have
> this up and working it should be rock solid and you won't have to screw
> with it again.
>
> You could reduce that ~$355 USD to ~$155 by substituting something like
> two of these for the LSI HBA
>
> http://www.newegg.com/Product/Product.aspx?Item=N82E16816124064
>
> though I can't attest to any qualities of this card.  If they're decent
> these will work better direct connected to the drives than any eSATA
> card connected to those Vantecs.

OK.  They're not available locally but I'll consider something similar
if I can find a suitable case to put them in.

> I hope the advice I've given here is beneficial, and not too preachy.

It has been, and not at all.  I appreciate you taking the time to
help.  I'll keep looking to see if I can find the necessaries for an
in-case solution, within budget.


Thanks.
