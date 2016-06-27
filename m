From: Chris Murphy <lists@colorremedies.com>
Subject: URE, link resets, user hostile defaults
Date: Mon, 27 Jun 2016 10:42:05 -0600
Message-ID: <CAJCQCtT1qi1yLjE3Lor3ScVJx7aX4A_S_iM_=VhDtDCD_C9uqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Drives with SCT ERC not supported or unset, result in potentially long
error recoveries for marginal or bad sectors: upwards of 180 second
recovers are suggested.

The kernel's SCSI command timer default of 30 seconds, i.e.

cat /sys/block/<dev>/device/timeout

conspires to  undermine the deep recovery of most drives now on the
market. This by default misconfiguration results in problems list
regulars are very well aware of. It affects all raid configurations,
and even affects the non-RAID single drive use case. And it does so in
a way that doesn't happen on either Windows or macOS. Basically it is
linux kernel induced data loss, the drive very possibly could present
the requested data upon deep recovery being permitted, but the
kernel's command timer is reached before recovery completes, and
obliterates any possibility of recovering that data. By default.

This now seems to affect the majority of use cases. At one time 30
seconds might have been sane for a world with drives that had less
than 30 second recoveries for bad sectors. But that's no longer the
case.

I'm wondering if anyone has floated the idea of changing the kernels
default SCSI command timer? And if so, if there's a thread discussing
where that was rejected upstream? Or if this exposes other liabilities
that merits an alternative work around for what now amounts to a
defect. Maybe it needs to be a udev rule?

Perhaps ideally what we'd like to have is two timers. A timer that
reports back "slowness" for a drive to complete a queued command,
which could be used by e.g. scrubs to preemptively overwrite those
sectors rather than wait for read errors to happen. And then a timer
with a longer value would be the present timer that results in a link
reset once it's reached.

Thanks,

-- 
Chris Murphy
