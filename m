From: "NeilBrown" <neilb@suse.de>
Subject: Re: Reliability of bitmapped resync
Date: Tue, 24 Feb 2009 06:59:10 +1100 (EST)
Message-ID: <b2460d0414270e6a6be4c91ec2d5a071.squirrel@neil.brown.name>
References: <20090223194019.GA3488@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090223194019.GA3488@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, February 24, 2009 6:40 am, Piergiorgio Sartor wrote:
> Hi all,
>
> I've a strange issue.
>
> I've a PC with 2 HDs in RAID-10 f2 with bitmap.
> There are actually 3 md devices, boot, swap and root.
>
> It happens that one SATA cable is/was flaky, so sometimes,
> at boot, /dev/sdb does not show up.
> The RAID starts in degraded mode, tracking the writes
> in the bitmap.
> On the next reboot, /dev/sdb is again there, so it is
> possible to re-add it.
> The md device resyncs what is to be resynced, very
> quickly, due to the bitmap.
>
> Later, if I run a check, usually a lot of mismatches
> show up.

What exactly do you mean by "check".

If you mean "look in /sys/block/md0/md/mismatch_cnt", then that is
exactly what I would expect.  The resync found some differences, just
as you would expect it to, and reported them.

However if by "check" you mean:
  echo check > /sys/block/md0/md/sync_action
  mdadm --wait /dev/md0
  cat /sys/block/md0/md/mismatch_cnt

then I would not expect any mismatches, and the resync should have
fixed them.

If it is the later, that is a real concern and I will need to look into it.
Please let me know exactly which kernel version and mdadm version you
are running.

Thanks,
NeilBrown


