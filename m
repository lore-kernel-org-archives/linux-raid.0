From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID halting
Date: Wed, 8 Apr 2009 09:17:52 -0500
Message-ID: <20090408141756.SJCK26228.cdptpa-omta04.mail.rr.com@Leslie>
References: <F2C688D6A021E34CB81C0E631EF4C09301864D15@34093-C4-EVS1.exchange.rackspace.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F2C688D6A021E34CB81C0E631EF4C09301864D15@34093-C4-EVS1.exchange.rackspace.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> There is also a SMART error log reporting mechanism.  The disks have
> ability to report the last 5 commands that errored on each disk, which
> includes timestamp, op code, input parameters and reason for error.

I pulled the logs from the drives.  Four showed no errors whatsoever, and
three showed 1, 2, and 3 errors, respectively.  The others ranged from 408
to 1871.  I then triggered a halt with a mv command, and checked the logs
again.  The values all remain the same, with no new errors reported
whatsoever.

> This runs instantly, and it is possible that just having these last 5
> errors will tell you exactly what problem is. The errors are also

I presume a sector remapping would be caught by the log file, yes?  If so,
bad sector mapping is pretty much completely eliminated as a cause for this
issue.

