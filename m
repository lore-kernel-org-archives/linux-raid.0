From: Phil Turmel <philip@turmel.org>
Subject: Boot md/udev event storm
Date: Thu, 12 Aug 2010 15:33:28 -0400
Message-ID: <4C644C88.9020103@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I've been trying to track down an infinite loop of device "change" events
during boot on my personal server, and I think I've identified the
cause:  Line #24 of 64-md-raid.rules runs "mdadm --detail --export" on each
new or changed md device in order to create a variety of symlinks.
Executing this one line (sometimes?) creates another change event.  There is
some kind of timing quirk, as the system does successfully complete an
occasional reboot.

The symptoms:
After dracut finds and mounts my raid5 root partition, init gets to
"Waiting for uevents to be processed", which times out in 60 seconds.  A list
of unprocessed events shows on the console, usually several thousand.  They all
reference an md device.  Init then proceeds to "Setting up the Logical Volume
Manager", which hangs forever.

This system is Gentoo Unstable, x86-32, although I've seen this on my x86-64
laptop in the past.  Relevant packages:

mdadm-3.1.2
udev-160
lvm2-2.02.72
Kernel config: http://www.turmel.org/other/config.gz

When the problem occurs, I can get my system working by requesting interactive
startup, then skipping the udev service.  It gets started later in that case,
but it is after LVM is started, and the race doesn't re-appear.

When I first encountered this problem, I thought it was an LVM issue, like
gentoo bug #306491, or ubuntu bug #332270.  I tried all of the recommendations
in those bug reports, to no avail.  I even forward-ported the LVM2
"open-readonly" patch to lvm2-2.02.72, also to no effect.  (Upstream LVM
never incorporated that patch, so my system didn't have it by default.  I
suspect it remains an issue for many people, but it doesn't appear to affect
me.)  For anyone who's interested, that patch is here:
	http://www.turmel.org/other/lvm2-2.02.72-open-readonly.patch

In any case, when I comment out lines 24 through 31 of 64-md-raid.rules, no
event storm occurs.  If I uncomment just line 24, the event storm re-occurs.

I poked a little in the mdadm source, and noted that Detail.c opens the
requested md device read-only.  I don't know enough about mdadm's code to
go further.

Any ideas?

Phil

