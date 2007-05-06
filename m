From: Gavin McCullagh <gmccullagh@gmail.com>
Subject: Re: what does md do if it finds an inconsistency?
Date: Sun, 6 May 2007 16:59:54 +0100
Message-ID: <20070506155954.GB27948@gmail.com>
References: <20070506004539.GA17736@lapse.madduck.net> <20070506090642.GA22083@lapse.madduck.net> <463DB709.8010900@eyal.emu.id.au> <3655.195.137.231.42.1178458574.squirrel@albatross.madduck.net>
Reply-To: Gavin McCullagh <gmccullagh@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3655.195.137.231.42.1178458574.squirrel@albatross.madduck.net>
Sender: linux-raid-owner@vger.kernel.org
To: martin f krafft <madduck@madduck.net>
Cc: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, 06 May 2007, martin f krafft wrote:

> Maybe the ideal way would be to have mdadm --monitor send an email on
> mismatch_count>0 or a cronjob that regularly sends reminders, until the
> admin logs in and runs e.g. /usr/share/mdadm/repairarray.
> 
> Also, if a mismatch is found on a RAID1, how does md decide which copy is
> mismatched and which is correct? What about RAID 5/6/10?

I think it just picks one at random.  After all, how could you reliably
know which is right in a raid1 array?  With raid5, I understand it just
updates the parity.

I had an idea to write an interactive userspace program which ran through
each block on each disk device to figure out which ones didn't match up and
then figure out whether it's within allocated filesystem space and if so,
which file or filesystem data was affected.  This would hopefully enable a
user to figure out which block is wrong and correct things.

Gavin

