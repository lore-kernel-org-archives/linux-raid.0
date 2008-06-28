From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
Subject: Suspected corruption on ACID databases due to no barrier support in ext3 on software raid-5 and hard resets
Date: Sat, 28 Jun 2008 10:53:01 +0200
Message-ID: <c384c5ea0806280153j426585f1q212c44f983a641e1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>, sandeen@sandeen.net
List-Id: linux-raid.ids

Hello all,

we are quite sure we are hitting data corruption on a few % of cases
on ACID* databases due to write caching enabled on drives in a
software RAID-5 configuration with ext3 in default data=ordered mode.

The machines are hard reset by a hardware watchdog when some esoteric
PCI device misbehaves.

We understand Linux software raid 5 does not pass-down barriers, is
that correct, and is this being implemented?

Also, our near-term direction of solution would be
0) disable write caches altogether, probably not feasible due to the
performance regression involved.
1) solve the misbehave (cause of reset).
2) use a shorter timed software watchdog to trigger the drives into
disabling their write caches, so that an imminent reboot has its
commits ordered.

Any other ideas?

Regards,
-- 
Leon

*http://en.wikipedia.org/wiki/ACID
