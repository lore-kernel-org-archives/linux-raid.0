From: "James R Bamford" <jim@jimtreats.com>
Subject: RE: Software Raid 1 data corruptions..
Date: Tue, 18 Nov 2003 00:52:50 -0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <PPEOJEIEFLAONFNHJPOOGEGNGOAA.jim@jimtreats.com>
References: <200311180020.hAI0Kl204624@bzs.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <200311180020.hAI0Kl204624@bzs.org>
To: michael@insulin-pumpers.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for the update that i'm not alone Michael..

Have you read my updates tonight.. I think i'm on the case of fixing it
(secondary drive on a controller on its own appears to have been the
problem.. touch wood) ... I will give it some more hard testing and will
consider getting a 3ware card if it doesn't stay fixed... i have quite a
good PSU i think and am only using 3 drives, and an old PC.. the PSU
shouldn't be too stressed...

Good luck..

Jim

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org]On Behalf Of Michael
> Sent: 18 November 2003 00:21
> To: linux-raid@vger.kernel.org
> Subject: RE: Software Raid 1 data corruptions..
>
>
> > > -----Original Message-----
> > > From: linux-raid-owner@vger.kernel.org
> > > [mailto:linux-raid-owner@vger.kernel.org]On Behalf Of Neil Brown
> > > Sent: 17 November 2003 03:19
> > > To: James R Bamford
> > > Cc: david.anderson@calixo.net; linux-raid@vger.kernel.org
> > > Subject: RE: Software Raid 1 data corruptions..
> > >
> > >
> > > On Saturday November 15, jim@jimtreats.com wrote:
> > >
>
> <snip>
> Just so you don't feel bad, I have the following situation that is
> very similar -- used your test procedure to find the problem.
>
> Three systems with supermicro mbrds and DPT RA4050 controllers (raid
> not used). An assortment of Segate and IBM 18 gig drives. Setup is
> raid 1 with small boot & swap partitions + one large data partition.
>
> Symptoms -- raid 1 would build, but data corruption would occur
> either during initial data transfer or upon doing the first disk
> thrashing i.e. build a kernel or something like that.
>
> broke the raid down and tested by simply transfering a 30 meg file
> from an installed IDE drive to the scsi drive, dismounting,
> remounting and doing md5sum of the file. Consistently, the Segate
> drives come up with differing cksums. The IBM drives all seem to work
> as does the IDE drive. I have 9 Segate drives and they work in other
> machines so I have to assume it is some combination of the power
> supply, mbrd, controller, etc... that is causing the problem though I
> have 3 of these systems and it seems pretty consistent on all of
> them. Big mystery, you are not alone -- it may be your hardware.
>
> Michael
> Michael@Insulin-Pumpers.org
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

