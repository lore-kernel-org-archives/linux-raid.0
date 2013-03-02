From: Phil Turmel <philip@turmel.org>
Subject: Re: Periodically scanning RAID arrays for inconsistencies
Date: Sat, 02 Mar 2013 11:24:37 -0500
Message-ID: <513227C5.3010400@turmel.org>
References: <81526C3C-7F95-4A17-B91B-8FD45BED55DE@redhat.com> <1362175859.18278.76.camel@148>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1362175859.18278.76.camel@148>
Sender: linux-raid-owner@vger.kernel.org
To: tbayly@bluehost.com
Cc: Brassow Jonathan <jbrassow@redhat.com>, "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 03/01/2013 05:10 PM, Tregaron Bayly wrote:
> On Fri, 2013-03-01 at 15:50 -0600, Brassow Jonathan wrote:
>> Is there a way to periodically scan a RAID array to report any discrepancies?
> 
> Yes, it's possible - Redhat distributes a script called raid-check that
> is a good example of this very thing.
> 
> Documentation/md.txt talks about 'check' and 'repair' as valid words for
> sync_action in sysfs.  The number of errors found will be reported to
> mismatch_cnt.  These can be found at /sys/block/md#/md for your array.

In general, this is called "scrubbing" your array, and it is *vital* to
do this on a regular basis.  Weekly is good.  You should only use
"check" to find mismatches (and it will fix UREs).  If any mismatches
are found, use "repair" to synchronize the devices, then fsck to fix any
resulting errors.

There's lots of history on this in the archives...

Phil

