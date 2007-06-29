From: David Chinner <dgc@sgi.com>
Subject: Re: [linux-pm] Re: [linux-lvm] 2.6.22-rc4 XFS fails after hibernate/resume
Date: Fri, 29 Jun 2007 15:00:24 +1000
Message-ID: <20070629050024.GO31489@sgi.com>
References: <46744065.6060605@dgreaves.com> <200706281727.35430.rjw@sisk.pl> <20070628220045.GA4521@elf.ucw.cz> <200706290016.45719.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200706290016.45719.rjw@sisk.pl>
Sender: linux-raid-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, David Chinner <dgc@sgi.com>, linux-pm <linux-pm@lists.osdl.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, LinuxRaid <linux-raid@vger.kernel.org>, LVM general discussion and development <linux-lvm@redhat.com>, David Robinson <zxvdr.au@gmail.com>, David Greaves <david@dgreaves.com>, Oleg Nesterov <oleg@tv-sign.ru>
List-Id: linux-raid.ids

On Fri, Jun 29, 2007 at 12:16:44AM +0200, Rafael J. Wysocki wrote:
> There are two solutions possible, IMO.  One would be to make these workqueues
> freezable, which is possible, but hacky and Oleg didn't like that very much.
> The second would be to freeze XFS from within the hibernation code path,
> using freeze_bdev().

The second is much more likely to work reliably. If freezing the
filesystem leaves something in an inconsistent state, then it's
something I can reproduce and debug without needing to
suspend/resume.

FWIW, don't forget you need to thaw the filesystem on resume.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
