From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: argh!
Date: Sat, 30 Oct 2010 19:05:38 -0500
Message-ID: <DD.7A.07087.7D2BCCC4@cdptpa-omtalb.mail.rr.com>
References: <AANLkTimeu=M-m4iKO=1Q_ALb47ST1uvtZavy2yk0NA-a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimeu=M-m4iKO=1Q_ALb47ST1uvtZavy2yk0NA-a@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com
Cc: 'Phil Turmel' <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Jon Hardcastle
> Sent: Saturday, October 30, 2010 4:55 PM
> To: Leslie Rhorer
> Cc: Phil Turmel; linux-raid@vger.kernel.org
> Subject: Re: argh!
> 
> Also,
> 
> What commands can I not run? I.e. what are destructive?

	--build, --create, --add, --zero-superblock.  Some of the growth
commands can get you into trouble if something happens, and depending on the
version of mdadm.  --assemble --force should not, at least not in and of
itself.  I would take care to mount the filesystem read-only and check it
out thoroughly before re-mounting as read-write.  If there are problems, you
may need to restore some of the data from backups.  You have backups, right?

