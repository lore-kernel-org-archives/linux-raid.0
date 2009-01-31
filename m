From: David Greaves <david@dgreaves.com>
Subject: Re: some ?? re failed disk and resyncing of array
Date: Sat, 31 Jan 2009 10:38:22 +0000
Message-ID: <49842A1E.1090105@dgreaves.com>
References: <1233389816.28363.1297740563@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1233389816.28363.1297740563@webmail.messagingengine.com>
Sender: linux-raid-owner@vger.kernel.org
To: whollygoat@letterboxes.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

whollygoat@letterboxes.org wrote:
> On a boot a couple of days ago, mdadm failed a disk and
> started resyncing to spare (raid5, 6 drives, 5 active, 1
> spare).  smartctl -H <disk> returned info (can't remember
> the exact text) that made me suspect the drive was
> fine, but the data connection was bad.  Sure enough the
> data cable was damaged.  Replaced the cable and smartctl
> sees the disk just fine and reports no errors.
> 
> - I'd like to readd the drive as a spare.  Is it enough
> to "mdadm --add /dev/hdk" or do I need to prep the drive to
> remove any data that said where it previously belonged
> in the array?
That should work.
Any issues and you can zero the superblock (man mdadm)
No need to zero the disk.

> - When I tried to list some files on one of the filesystems
> on the array (the fact that it took so long to react to
> the ls is how I discovered the box was in the middle of
> rebuiling to spare)
This is OK - resync involves a lot of IO and can slow things down. This is tuneable.

> it couldn't find the file (or many 
> others).  I thought that resyncing was supposed to be
> transparent, yet parts of the fs seemed to be missing.
> Everything was there afterwards.  Is that normal?
No. This is nothing to do with normal md resyncing and certainly not expected.

> - On a subsequent boot I had to run e2fsck on the three
> filesystems housed on the array.  Many stray blocks, 
> illegal inodes, etc were found.  An artifact of the rebuild
> or unrelated?
Well, you had a fault in your IO system there's a good chance your O broke.

Verify against a backup.

David


-- 
"Don't worry, you'll be fine; I saw it work in a cartoon once..."
