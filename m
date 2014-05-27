From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: Which RAID do you recommend for home use?
Date: Tue, 27 May 2014 14:16:08 -0500
Message-ID: <CAJvUf-BVTNd9jK3oXyX3uUAj9x6F0j+Aqg4UCrRUmdSPsGdRiA@mail.gmail.com>
References: <b4ea2d0e-15bc-40b0-b836-aab134b0e0b7@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <b4ea2d0e-15bc-40b0-b836-aab134b0e0b7@email.android.com>
Sender: linux-raid-owner@vger.kernel.org
To: "L. M. J" <linuxmasterjedi@free.fr>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, May 27, 2014 at 1:47 PM, L. M. J <linuxmasterjedi@free.fr> wrote:
> Since I've broken my RAID 5, I can restart my raid array from scratch. I have 3 disks, but I can get another. I could go to RAID 6 or 10. That's for personal use, mostly store static data. Hardware is very common...
> Is it worth to lose one extra capacity drive for my needs? Which RAID will fit my needs?

How big are the drives?  What are your goals?  Any performance requirements?

Although rule #1 is "RAID is not backup", many people, particular in
simple home server situations, use RAID as an excuse for not having
proper backups.  The real intent behind RAID is nonstop availability,
which is usually not required in a home environment (in other words,
if your home RAID goes down, how much will it cost you until you can
bring it back up?).  That said, in the absence of real backups, I
suppose RAID is better than no-RAID (with the caveat that there are
still plenty of scenarios where permanent data loss is a real
possibility).

For home use and "mostly static data", raid-10 is probably not what
you want.  If you are using RAID as a proxy for real backups, more
redundancy is better than less, so I'd buy another drive and go with
RAID-6.  Also consider, if these are large (>2 TB) consumer-grade
drives, then rebuild times will be quite long.  During rebuild, your
drives are stressed heavily, so the possibility of failure goes up
considerably.  Again, more redundancy is your friend.

On the other hand, if you have real backups, and can tolerate the
downtime, RAID-5 is probably adequate.

Depending on your particular needs, there are another couple
possibilities that might interest you:

snapraid - http://snapraid.sourceforge.net/ - like raid-5 or raid-6 (I
believe it now supports even more levels of parity), but not in "real
time".  The idea is that your data is mostly static (think large media
collection), so it doesn't make sense to have extra drives spinning
all the time for on-the-fly parity calculations.  Just update your
parity data as-needed (either by hand or e.g. nightly cron job).

zfs - http://zfsonlinux.org/ - arguably a "competitor" to linux md, it
does provide "raid-z3", which is zfs's branding for triple-parity raid
(zfs raid-z1 is basically raid-5, raid-z2 is effectively raid-6).
Gives you a little more protection if you're going without backups.
