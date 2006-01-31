From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: 2.6.15: mdrun, udev -- who creates nodes?
Date: Tue, 31 Jan 2006 22:58:03 +0100
Message-ID: <62b0912f0601311358t5e028beeqdc61302ade37ecf0@mail.gmail.com>
References: <43DCA9CA.5020505@bl.com>
	 <20060129123532.GA6158@wonderland.linux.it> <43DCD614.20705@pobox.com>
	 <20060130204231.GP19465@austin.ibm.com>
	 <20060130204743.GA13902@wonderland.linux.it>
	 <dro3ue$ntb$1@sea.gmane.org> <20060131192643.GU19465@austin.ibm.com>
	 <62b0912f0601311219x78cbb29dof3768c1449bc8349@mail.gmail.com>
	 <20060131205202.GD27268@knob.reflex>
	 <20060131211317.GB19465@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060131211317.GB19465@austin.ibm.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linas <linas@austin.ibm.com>
Cc: Jason Lunz <lunz@falooley.org>, neilb@suse.de, linux-hotplug-devel@lists.sourceforge.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

linas wrote:
> I was reacting to the following:
> > > From: Neil Brown <neilb <at> suse.de>
> > > It is perfectly possible and even preferable
> > > to live without autodetect.
>
> I didn't see how it could be "preferable", and illustrated this
> with the sysadmin story.

Certainly it isn't, and now I remember the point.

Quoting Luca Berra:
> the in kernel auto assembly should be removed for good
> it should be replaced by auto assembly in user space (mdadm),
> which does not suffer from the problems that in-kernel has.

If people could start saying
 "we need to get rid of in-kernel autodetection"
instead of
 "we need to get rid of autodetection",
I think there would be much less confusion.
