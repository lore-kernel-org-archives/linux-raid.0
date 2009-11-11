From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Bitmap did not survive reboot
Date: Wed, 11 Nov 2009 09:01:46 -0600
Message-ID: <20091111150155475.WWUI3390@cdptpa-omta03.mail.rr.com>
References: <20091111091609.GB9137@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091111091609.GB9137@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> > If you have a temporary space for your data, I'd suggest you move it
> > out and go for an internal bitmap solution. It certainly beats the
> > patch work you're going to have to do on the startup scripts (and
> > every time you update mdadm, or the distro).
> >
> There should be no need to move the data off - you can add an internal
> bitmap using the --grow option.  An internal bitmap does have more of an
> overhead than an external one though.

	I thought I remembered reading in the man page than an internal
bitmap could only be added when the array was created?  Is that incorrect?  

