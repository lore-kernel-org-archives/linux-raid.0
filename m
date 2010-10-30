From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: argh!
Date: Sat, 30 Oct 2010 16:10:44 -0500
Message-ID: <3E.D6.13137.8D98CCC4@cdptpa-omtalb.mail.rr.com>
References: <4CCC3DB6.3020500@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CCC3DB6.3020500@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: 'Phil Turmel' <philip@turmel.org>, Jon@eHardcastle.com
Cc: 'Jon Hardcastle' <jonathan.hardcastle@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Phil Turmel
> Sent: Saturday, October 30, 2010 10:46 AM
> To: Jon@eHardcastle.com
> Cc: Jon Hardcastle; linux-raid@vger.kernel.org
> Subject: Re: argh!
> 
> On 10/30/2010 07:56 AM, Jon Hardcastle wrote:
> > Guys,
> >
> > a new HDD has failed on me during a scrub.... i tried to remove/fail it
> but
> > it kept saying the device was busy. so i forced a reboot.
> >
> > I have physically disconnected the drive..
> >
> > can anyone take alook at the examine below and tell me if it is should
> > assemble ok?
> >
> > I tried
> >
> > mdadm --assemble /dev/md4 /dev/sda1 /dev/sdb1 /dev/sdd1 /dev/sde1
> /dev/sdf1
> > /dev/sdg1
> 
> I'd try:
> 
> mdadm --assemble /dev/md4 /dev/sd{g,a,e}1 missing /dev/sd{d,b,f}1


	Yeah, I would, too.  Also, what are the contents of
/etc/mdadm/mdadm.conf?  If it is correct, then `mdadm --assemble --scan`
should work.

