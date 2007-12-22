From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: mdadm --stop goes off and never comes back?
Date: Sat, 22 Dec 2007 07:01:44 -0600
Message-ID: <cccedfc60712220501n28cd9a6dx57e437c01dd1c1fb@mail.gmail.com>
References: <cccedfc60712181311i6bfd755v659ad5b81bc81dc5@mail.gmail.com>
	 <18281.51489.845404.884191@notabene.brown>
	 <cccedfc60712191805i5828ff32gb1f04247dc9dedc2@mail.gmail.com>
	 <cccedfc60712191807l1bb09ab3p1168570a5429865b@mail.gmail.com>
	 <18284.64513.783072.915203@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18284.64513.783072.915203@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/22/07, Neil Brown <neilb@suse.de> wrote:
> On Wednesday December 19, jnelson-linux-raid@jamponi.net wrote:
> > On 12/19/07, Jon Nelson <jnelson-linux-raid@jamponi.net> wrote:
> > > On 12/19/07, Neil Brown <neilb@suse.de> wrote:
> > > > On Tuesday December 18, jnelson-linux-raid@jamponi.net wrote:
> > > > >
> > > > > I tried to stop the array:
> > > > >
> > > > > mdadm --stop /dev/md2
> > > > >
> > > > > and mdadm never came back. It's off in the kernel somewhere. :-(
>
> Looking at your stack traces, you have the "mdadm -S" holding
> an md lock and trying to get a sysfs lock as part of tearing down the
> array, and 'hald' is trying to read some attribute in
>    /sys/block/md....
> and is holding the sysfs lock and trying to get the md lock.
> A classic AB-BA deadlock.
>
> >
> > NOTE: kernel is stock openSUSE 10.3 kernel, x86_64, 2.6.22.13-0.3-default.
> >
>
> It is fixed in mainline with some substantial changes to sysfs.
> I don't imagine they are likely to get back ported to openSUSE, but
> you could try logging a bugzilla if you like.

Nah - I'm eagerly awaiting new kernels anyway as I have some network
cards that work much better (read: they work) with 2.6.24rc3+.

> The 'hald' process is interruptible and killing it would release the
> deadlock.

Cool.

> I suspect you have to be fairly unlucky to lose the race but it is
> obviously quite possible.

Sometimes we are all a little unlucky. In my case, it cost me a reboot
or, in others, nothing at all. Fortunately this was not a production
system with lots of users.

> I don't think there is anything I can do on the md side to avoid the
> bug.

In the situation I don't think that such a change would be warranted anyway.
Thanks again for looking at this. I'm a big believer in the 'canary in
a coal mine' mentality - some problems may indications of much more
serious issues, but in this case, it would appear that the issue has
already been taken care of. Have a Happy Holidays.

-- 
Jon
