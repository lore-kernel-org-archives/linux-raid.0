From: spam@streefland.xs4all.nl (Dick Streefland)
Subject: Re: resync on every raidstart
Date: Sat, 27 Sep 2003 21:25:00 -0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <2572.3f76002c.42323@altium.nl>
References: <7e6d.3f6de874.1ece7@altium.nl> <16239.60542.191148.816664@notabene.cse.unsw.edu.au> <dad.3f70b057.ee5c4@altium.nl> <13ef.3f75a413.f153f@altium.nl>
Reply-To: dick.streefland@xs4all.nl (Dick Streefland)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

spam@streefland.xs4all.nl (Dick Streefland) wrote:
| I did some more tests, and it looks like my problem may be related to
| SMP. When I setup a RAID1 array on my SMP machine, the component
| devices stay "dirty", but when I do the same on an UP machine, the
| state is "clean". However, when I boot the SMP machine with "nosmp",
| or boot a non-SMP kernel, the problem persists. Both machines run a
| 2.6.0-test5 kernel (with your oops fix from 2003-09-12), and have
| mdadm-1.3.0.

It turns out that the problem is not related to SMP, but to
CONFIG_PREEMPT. I built two identical kernels for a non-SMP machine,
except for CONFIG_PREEMPT. With the CONFIG_PREEMPT kernel, the state
is dirty, with the other kernel, the state is clean.

-- 
Dick Streefland                    ////               De Bilt
dick.streefland@xs4all.nl         (@ @)       The Netherlands
------------------------------oOO--(_)--OOo------------------

