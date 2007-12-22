From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm --stop goes off and never comes back?
Date: Sat, 22 Dec 2007 22:58:57 +1100
Message-ID: <18284.64513.783072.915203@notabene.brown>
References: <cccedfc60712181311i6bfd755v659ad5b81bc81dc5@mail.gmail.com>
	<18281.51489.845404.884191@notabene.brown>
	<cccedfc60712191805i5828ff32gb1f04247dc9dedc2@mail.gmail.com>
	<cccedfc60712191807l1bb09ab3p1168570a5429865b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jon Nelson on Wednesday December 19
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday December 19, jnelson-linux-raid@jamponi.net wrote:
> On 12/19/07, Jon Nelson <jnelson-linux-raid@jamponi.net> wrote:
> > On 12/19/07, Neil Brown <neilb@suse.de> wrote:
> > > On Tuesday December 18, jnelson-linux-raid@jamponi.net wrote:
> > > >
> > > > I tried to stop the array:
> > > >
> > > > mdadm --stop /dev/md2
> > > >
> > > > and mdadm never came back. It's off in the kernel somewhere. :-(

Looking at your stack traces, you have the "mdadm -S" holding
an md lock and trying to get a sysfs lock as part of tearing down the
array, and 'hald' is trying to read some attribute in
   /sys/block/md....
and is holding the sysfs lock and trying to get the md lock.
A classic AB-BA deadlock.

> 
> NOTE: kernel is stock openSUSE 10.3 kernel, x86_64, 2.6.22.13-0.3-default.
> 

It is fixed in mainline with some substantial changes to sysfs.
I don't imagine they are likely to get back ported to openSUSE, but
you could try logging a bugzilla if you like.

The 'hald' process is interruptible and killing it would release the
deadlock.

I suspect you have to be fairly unlucky to lose the race but it is
obviously quite possible.

I don't think there is anything I can do on the md side to avoid the
bug.

NeilBrown
