From: dean gaudet <dean@arctic.org>
Subject: Re: md/mdadm fails to properly run on 2.6.15 after upgrading from
 2.6.11
Date: Sun, 9 Apr 2006 07:47:39 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0604090736170.4668@twinlark.arctic.org>
References: <4438FFA9.4030907@debruin.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4438FFA9.4030907@debruin.org>
Sender: linux-raid-owner@vger.kernel.org
To: "Marc L. de Bruin" <marc@debruin.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 9 Apr 2006, Marc L. de Bruin wrote:

...
> Okay, just pressing Control-D continues the boot process and AFAIK the root
> filesystemen actually isn't corrupt. Running e2fsck returns no errors and
> booting 2.6.11 works just fine, but I have no clue why it picked the wrong
> partitions to build md[01234].
> 
> What could have happened here?

i didn't know sarge had 2.6.11 or 2.6.15 packages... but i'm going to 
assume you've installed one of initramfs-tools or yaird in order to use 
the unstable 2.6.11 or 2.6.15 packages... so my comments might not apply.

initramfs-tools generates an "mdrun /dev" which starts all the raids it 
can find... but does not include the mdadm.conf in the initrd so i'm not 
sure it will necessarily start them in the right minor devices.  try doing 
an "mdadm --examine /dev/xxx" on some of your partitions to see if the 
"preferred minor" is what you expect it to be...

if the preferred minors are wrong there's some mdadm incantation to update 
them... see the man page.

or switch to yaird (you'll have to install yaird and purge 
initramfs-tools) and dpkg-reconfigure your kernel packages to cause the 
initrds to be rebuilt.  yaird starts only the raid required for the root 
filesystem, and specifies the correct minor for it.  then later after the 
initrd /etc/init.d/mdadm-raid will start the rest of your raids using your 
mdadm.conf.

-dean
