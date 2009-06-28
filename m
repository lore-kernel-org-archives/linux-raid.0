From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: device with newer data added as spare - data now gone?
Date: Sun, 28 Jun 2009 14:04:54 -0500
Message-ID: <20090628190459297.FVMV19511@cdptpa-omta03.mail.rr.com>
References: <24218843.post@talk.nabble.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <24218843.post@talk.nabble.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Hi all
> 
> I've lost quite a lot of data on my /home raid partition and I'm wondering
> what exactly I did to make it happen. I'd like to know so something
> similar
> won't happen in the future.

	Well, first of all, of course learning from your mistakes will
prevent them from happening in the future.  If you ask me, a second very
important utility to enable is mdadm's ability to notify you via e-mail
whenever a significant event transpires.  You will then be notified quickly
of any significant changes to any RAID array, such as losing a hard drive.

	Finally, more important than anything else: BACK UP YOUR IMPORTANT
DATA.  If it is data that can be recovered through some external process,
but takes a bit of doing, back it up once, and keep it handy.  A different
drive or array on the same machine or a different machine in the same room
is fine for this level of backup.  If it is data that cannot be recovered
and would cause some heartache if lost, then include it in the local handy
backup, but also include it in an off-premise backup.  If it is critical
data - like financial information, then back it up 16 ways from Sunday.  I
keep all critical data backed up on two different servers with independent
RAID arrays, DVD-ROM backups offsite, and independent multi-generation
backups on every workstation which accesses the data.  If it is a commercial
application and the revenue supports it, or if it is important enough to you
and you can personally afford it, I suggest you might look into an online
storage solution.

	Remember, RAID arrays are fault tolerant, not fault-free, and while
hard drives are frail, the most likely source of data failure by far is user
error.

> * Some time ago I did something to have one device fail which resulted md3
> in having only 1 device.

	I presume md3 is the /home array and this was a 2 drive RAID1 array,
yes?

> * Time went by without me noticing (because I suck)

	See above.  We human beings all tend to suck from time to time.
Computers can help by reminding or notifying us of things - if we bother to
set them up to do so.

> * An update broke my raid setup and gave me a kernel panic (because I
> suck).
> Didn't put the mdadm and raid hooks in mkinitcpio.conf
> * Booted a live-cd, mounted the drives and chrooted back into the system
> and
> fixed the mkinitcpio.conf

	This all sounds like lessons learned.

> * Rebooted and noticed that md3 was running with only 1 device
> * Added sdb4 to md3 and it then read 1 device with 1 spare
> * cat /proc/mdstat started to say "recovery"
> * All data from approx. 1 year is gone

	Was sdb4 originally the second partition in the array?  What is the
first partition?  What was the apparent cause of the failure?

> I guessing that the old (not updated) device was set as "master" and the
> data on the drive (containing newer data) was overwritten by data on the
> old
> device - is this plausible?

	Well, I suppose, yeah.

> If not what exactly did I do to delete all of the data?

	What command did you use to add the partition back to the array?

