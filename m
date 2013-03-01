From: Tregaron Bayly <tbayly@bluehost.com>
Subject: Re: Periodically scanning RAID arrays for inconsistencies
Date: Fri, 01 Mar 2013 15:10:59 -0700
Message-ID: <1362175859.18278.76.camel@148>
References: <81526C3C-7F95-4A17-B91B-8FD45BED55DE@redhat.com>
Reply-To: tbayly@bluehost.com
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <81526C3C-7F95-4A17-B91B-8FD45BED55DE@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brassow Jonathan <jbrassow@redhat.com>
Cc: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 2013-03-01 at 15:50 -0600, Brassow Jonathan wrote:
> Is there a way to periodically scan a RAID array to report any discrepancies?

Yes, it's possible - Redhat distributes a script called raid-check that
is a good example of this very thing.

Documentation/md.txt talks about 'check' and 'repair' as valid words for
sync_action in sysfs.  The number of errors found will be reported to
mismatch_cnt.  These can be found at /sys/block/md#/md for your array.

hth,

Tregaron

