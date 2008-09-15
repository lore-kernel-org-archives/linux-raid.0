From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
Subject: Re: Raid6 array crashed-- 4-disk failure...(?)
Date: Mon, 15 Sep 2008 12:03:01 +0100
Message-ID: <18638.16613.435533.269946@tree.ty.sabi.co.uk>
References: <48CE250C.8000603@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48CE250C.8000603@ultratux.net>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


> This weekend I promoted my new 6-disk raid6 array to
> production use and was busy copying data to it overnight. The
> next morning the machine had crashed, and the array is down
> with an (apparent?) 4-disk failure, [ ... ]

Multiple drive failures are far more common than people expect,
and the problem lies in people's expectations, because they don't
do common mode analysis (what's what? many will think).

They typically happen all at once at power up, or in short
succession (e.g. 2nd drive fails while syncing to recover from
1st failure).

The typical RAID has N drives from the same manufacturer, of the
same model, with nearly contiguous serial numbers, from the same
shipping carton, in an enclosure where they all are started and
stopped at the same time, run on the same power circuit, at the
same temperature, on much the same load, attached to the same
host adapter or N of the same type. Expecting as many do to have
uncorrelated failures is rather comical.

1) Is my analysis correct so far ?

Not so sure :-). Consider this interesting discrepancy:

  /dev/sda1:
  [ ... ]
      Raid Devices : 7
     Total Devices : 6
  [ ... ]
    Active Devices : 5
  Working Devices : 5

  /dev/sdb1:
  [ ... ]
      Raid Devices : 7
     Total Devices : 6
  [ ... ]
    Active Devices : 6
  Working Devices : 6

Also note that member 0, 'sdk1' is listed as "removed", but not
faulty, in some member statuses. However you have been able to
actually get the status out of all members, including 'sdk1',
which reports itself as 'active', like all other drives as of
5:16. Then only 2 drives report themselves as 'active' as of
5:17, and those think that the array has 5 'active'/'working'
devices at that time. What happened between 5:16 and 5:17?

You should look at your system log to figure out what really
happened to your drives and then assess what the cause of the
failure was and its impact.

3) Should I say farewell to my ~2400 GB of data ? :-(

Surely not -- you have a backup of those 2400GB, as obvious from
"busy copying data to it". RAID is not backup anyhow :-).

4) If it was only a one-drive failure, why did it kill the array ?

The MD subsystem marked as bad more than one drive. Anyhow doing
a 5+2 RAID6 and then loading it with data with a checksum drive
missing and at the same time as it syncing seems a bit too clever
to me. Right now the array is running in effect in RAID0 mode, so
I would not trust it even if you are able to restart it.
