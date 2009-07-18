From: "NeilBrown" <neilb@suse.de>
Subject: RE: >16TB RAID0
Date: Sat, 18 Jul 2009 10:12:16 +1000 (EST)
Message-ID: <bf9e24f010515d7b75e48872edcf68df.squirrel@neil.brown.name>
References: <20090717223912025.ZZHZ5000@cdptpa-omta04.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090717223912025.ZZHZ5000@cdptpa-omta04.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, July 18, 2009 8:39 am, Leslie Rhorer wrote:
>> I'm not 100% sure, but a quick look at the code suggests that
>> 16TB is the upper limit for normal read/write operations on
>> a block device like /dev/md0 on a 32bit host.  This is because it uses
>> the page cache, and that uses 4K pages with a 32bit index, hence
>> 16TB.
>
> 	Uh-oh!  I hope this doesn't apply to a 64 bit host running
> 2.6.26-2-amd64, or is it a limitation of md?  In fairly short order (a
> year,
> maybe), I'm going to need to go beyond 16T employing RAID6 on some number
> more than eight 3T drives.  I know a lot can happen in a year, but when it
> comes to upgrading code, sometimes a lot doesn't happen, either.

No, this does not apply to 64bit hosts.  Only 32bit.

>
>> A filesystem using a 16TB device would not be limited in the same way
>> as it caches individual files, not the whole device (individual files
>> would still be limited to 16TB).
>> I think if you access the block device with O_DIRECT you might be
>> able to bypass the 16TB barrier.  Try hacking the program
>> to add O_DIRECT to the open mode.
>
> 	I'm running XFS, but perhaps I could get the developers to put in a
> switch for this, if need be.

If the filesystem uses the block device to cache metadata - as several do,
though I don't know about XFS - then no O_DIRECT change is useful.
If the filesystem doesn't depend on the block device's cache, then
there might be value in using O_DIRECT for e.g. mkfs/fsck on
>16TB devices on 32 bit systems.

I have just sent an Email to fs devel asking about this.

But just to repeat: on a 64bit host, this is not an issue.  You can have
devices so large that I don't know the correct greek prefix and they
should still work.  It is only on 32bit hosts where 16TB can be
a problem.

NeilBrown

