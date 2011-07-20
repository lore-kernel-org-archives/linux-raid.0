From: Shaun Reich <predator106@gmail.com>
Subject: Re: Raid5 boot failure after grow
Date: Wed, 20 Jul 2011 12:39:16 -0400
Message-ID: <CADVynFDJO3_87ub-qfKK-0JWOB0nYK5P7=Au7fhcd+LEQkP=OA@mail.gmail.com>
References: <CADVynFA9NffR7jMrN5HV05n9V0=SOVdyFQjvCvNP=MU+G-ur6g@mail.gmail.com>
 <4E260E21.5020001@turmel.org>
Reply-To: shaun.reich@kdemail.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E260E21.5020001@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Do you happen to know how to rebuild it when I can't boot into it?
I've tried booting into a livecd, mounting the raid volume and the
/boot, running 'dracut --mdadmconf "initramfs-$(uname -r).img" $(uname
-r)', copying the generated initramfs into the separate /boot
partition, and making grub try to boot it, but it simply is not
working.

It seems to be because it's actually using the livecd's kernel and
mods, which is rather unfortunate and would probably be why it is
unable to boot. I've also tried simply doing it from the livecd (with
the proper mdadm.conf) and then copying that file (from the livecd),
into /boot. That at least gets me from a blank blinking cursor, to a
message about a failed modprobe attempt for /lib/modules, prior to
falling back to a shell.

Ideas?

-- 
Shaun Reich,
KDE Software Developer (kde.org)
