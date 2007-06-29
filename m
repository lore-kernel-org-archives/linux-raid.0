From: David Chinner <dgc@sgi.com>
Subject: Re: [linux-pm] Re: [linux-lvm] 2.6.22-rc4 XFS fails after hibernate/resume
Date: Fri, 29 Jun 2007 17:43:22 +1000
Message-ID: <20070629074322.GT31489@sgi.com>
References: <46744065.6060605@dgreaves.com> <200706281727.35430.rjw@sisk.pl> <20070628220045.GA4521@elf.ucw.cz> <200706290016.45719.rjw@sisk.pl> <20070629050024.GO31489@sgi.com> <4684B750.5030001@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4684B750.5030001@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: David Chinner <dgc@sgi.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>, linux-pm <linux-pm@lists.osdl.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, LinuxRaid <linux-raid@vger.kernel.org>, LVM general discussion and development <linux-lvm@redhat.com>, David Robinson <zxvdr.au@gmail.com>, Oleg Nesterov <oleg@tv-sign.ru>
List-Id: linux-raid.ids

On Fri, Jun 29, 2007 at 08:40:00AM +0100, David Greaves wrote:
> What happens if a filesystem is frozen and I hibernate?
> Will it be thawed when I resume?

If you froze it yourself, then you'll have to thaw it yourself.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
