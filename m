From: Phil Turmel <philip@turmel.org>
Subject: Re: Raid5 boot failure after grow
Date: Wed, 20 Jul 2011 13:16:39 -0400
Message-ID: <4E270D77.2090609@turmel.org>
References: <CADVynFA9NffR7jMrN5HV05n9V0=SOVdyFQjvCvNP=MU+G-ur6g@mail.gmail.com> <4E260E21.5020001@turmel.org> <CADVynFDJO3_87ub-qfKK-0JWOB0nYK5P7=Au7fhcd+LEQkP=OA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADVynFDJO3_87ub-qfKK-0JWOB0nYK5P7=Au7fhcd+LEQkP=OA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: shaun.reich@kdemail.net
Cc: Shaun Reich <predator106@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/20/2011 12:39 PM, Shaun Reich wrote:
> Do you happen to know how to rebuild it when I can't boot into it?
> I've tried booting into a livecd, mounting the raid volume and the
> /boot, running 'dracut --mdadmconf "initramfs-$(uname -r).img" $(uname
> -r)', copying the generated initramfs into the separate /boot
> partition, and making grub try to boot it, but it simply is not
> working.

I'm not familiar with Fedora, so I don't know what tools it has on the liveCD.  Look for a tool that will mount everything for you then put you in a chroot.  Then run the appropriate update-initramfs utility within the chroot.

> It seems to be because it's actually using the livecd's kernel and
> mods, which is rather unfortunate and would probably be why it is
> unable to boot. I've also tried simply doing it from the livecd (with
> the proper mdadm.conf) and then copying that file (from the livecd),
> into /boot. That at least gets me from a blank blinking cursor, to a
> message about a failed modprobe attempt for /lib/modules, prior to
> falling back to a shell.
> 
> Ideas?

HTH,

Phil
