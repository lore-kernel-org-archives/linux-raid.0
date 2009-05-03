From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: md extension to support booting from raid whole disks.
Date: Sat, 2 May 2009 20:33:38 -0500
Message-ID: <20090503013342770.VMBT19475@cdptpa-omta01.mail.rr.com>
References: <6c4602af0905021002i6fb0e667mdde8fb589f34ead6@mail.gmail.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6c4602af0905021002i6fb0e667mdde8fb589f34ead6@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> First thing is, DO NOT boot from raid5/6. It's pointless anyway.

I agree.

> Summing up, I don't get, why would anybody really want to boot from raid5
> or 6.

Well, I can see the reasons, but to my mind they are outweighed by the
problems inherent in doing so and the fact the benefits are minimal.


> I second booting from one thing, and storing data on the other. It can
> be different partition, it can be different disk, but mixing those
> things together in one place is bad practice for many many reasons.

With hard drives being so inexpensive, I see no reason not to have separate
boot drive or mirrored set and data devices.  Indeed, since a human error is
much more likley than a drive failure, what I like to do is use a moderate
(160G or so) sized hard drive to create all the boot and OS partitions
(including Grub and if necessary, Windows) and keep a hard drive on the
shelf with a copy of the running system.  Of course there are snapshot
utilities which can make it fairly easy to revert to earlier states, and
those used in combination with mirrored drives can serve the same purpose,
but I find the spare drive on the shelf to be the most comfortable solution.

> And my very personal background; I chose mdadm because it allows me to
> make raid sets across multiple controllers, and I don't use my raid6
> for anything other than data. System boots from single (even EIDE)
> disk, I'm totally not worried about my system, only data matter.

Well, it can take a while to set up a system and recover from a boot drive
failure, so some means of backup is definitely a good idea.  If nothing
else, one can simply tar all the files from the boot system to the RAID
array.  At the very least, a copy of /var and /etc is a good idea.

