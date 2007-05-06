From: "martin f krafft" <madduck@madduck.net>
Subject: Re: what does md do if it finds an inconsistency?
Date: Sun, 6 May 2007 15:36:14 +0200 (CEST)
Message-ID: <3655.195.137.231.42.1178458574.squirrel@albatross.madduck.net>
References: <20070506004539.GA17736@lapse.madduck.net>
    <20070506090642.GA22083@lapse.madduck.net>
    <463DB709.8010900@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <463DB709.8010900@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> The first time it reports that it found (and repaired) 128 items.
> It does not mean that you now *have* 128 mismatches.
>
> The next run ('repair' or 'check') will find none (hopefully...)
> and report zero.

Oh, this makes perfect sense, thanks for the explanation.

As the mdadm maintainer for Debian, I would like to come up with a way to
handle mismatches somewhat intelligently. I already have the check
sync_action run once a month on all machines by default (can be turned
on/off via debconf), and now I would like to find a good way to react when
mismatch_count is non-zero. I don't want to write to the components
without the admin's consent though.

Maybe the ideal way would be to have mdadm --monitor send an email on
mismatch_count>0 or a cronjob that regularly sends reminders, until the
admin logs in and runs e.g. /usr/share/mdadm/repairarray.

Thoughts?

Also, if a mismatch is found on a RAID1, how does md decide which copy is
mismatched and which is correct? What about RAID 5/6/10?

Thanks for your time!
-martin

>
> --
> Eyal Lebedinsky (eyal@eyal.emu.id.au) <http://samba.org/eyal/>
> 	attach .zip as .dat
>
>

