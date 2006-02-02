From: Neil Brown <neilb@suse.de>
Subject: Re: 2.6.15: mdrun, udev -- who creates nodes?
Date: Thu, 2 Feb 2006 12:27:55 +1100
Message-ID: <17377.24603.320734.849367@cse.unsw.edu.au>
References: <20060129123532.GA6158@wonderland.linux.it>
	<43DCD614.20705@pobox.com>
	<20060130204231.GP19465@austin.ibm.com>
	<20060130204743.GA13902@wonderland.linux.it>
	<dro3ue$ntb$1@sea.gmane.org>
	<20060131192643.GU19465@austin.ibm.com>
	<62b0912f0601311219x78cbb29dof3768c1449bc8349@mail.gmail.com>
	<20060131205202.GD27268@knob.reflex>
	<20060131211317.GB19465@austin.ibm.com>
	<62b0912f0601311358t5e028beeqdc61302ade37ecf0@mail.gmail.com>
	<20060201092758.GQ7017@strugglers.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andy Smith on Wednesday February 1
Sender: linux-raid-owner@vger.kernel.org
To: Andy Smith <andy@lug.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday February 1, andy@lug.org.uk wrote:
> On Tue, Jan 31, 2006 at 10:58:03PM +0100, Molle Bestefich wrote:
> > Quoting Luca Berra:
> > > the in kernel auto assembly should be removed for good
> > > it should be replaced by auto assembly in user space (mdadm),
> > > which does not suffer from the problems that in-kernel has.
> > 
> > If people could start saying
> >  "we need to get rid of in-kernel autodetection"
> > instead of
> >  "we need to get rid of autodetection",
> > I think there would be much less confusion.
> 
> And force us all to use initrd/initramfs :(

Don't think of it as 'forcing' you.  Think of it as encouraging you to
be an early adopter...
I suspect it won't be many years (maybe 1) before you have to have an
initramfs to boot.  There will be a standard one distributed with the
kernel, but it will (hopefully) be fairly easy to add stuff.

So get with the program. Initramfs is *easy*.  Just DO it.

(mdadm-2.2 comes with a script to make an initramfs which "works for me").

NeilBrown
