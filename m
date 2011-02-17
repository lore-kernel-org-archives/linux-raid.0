From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: md road-map: 2011
Date: Thu, 17 Feb 2011 02:04:55 +0100
Message-ID: <20110217010455.GA16324@www2.open-std.org>
References: <20110216212751.51a294aa@notabene.brown> <ijgr9p$7v8$1@dough.gmane.org> <20110217083531.3090a348@notabene.brown> <ijhje3$ocd$1@dough.gmane.org> <20110217100139.7520893d@notabene.brown> <ijhq7p$pjv$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ijhq7p$pjv$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Feb 17, 2011 at 01:30:49AM +0100, David Brown wrote:
> On 17/02/11 00:01, NeilBrown wrote:
> >On Wed, 16 Feb 2011 23:34:43 +0100 David Brown<david.brown@hesbynett.no>
> >wrote:
> >
> >>I thought there was some mechanism for block devices to report bad
> >>blocks back to the file system, and that file systems tracked bad block
> >>lists.  Modern drives automatically relocate bad blocks (at least, they
> >>do if they can), but there was a time when they did not and it was up to
> >>the file system to track these.  Whether that still applies to modern
> >>file systems, I do not know - they only file system I have studied in
> >>low-level detail is FAT16.
> >
> >When the block device reports an error the filesystem can certainly record
> >that information in a bad-block list, and possibly does.
> >
> >However I thought you were suggesting a situation where the block device
> >could succeed with the request, but knew that area of the device was of low
> >quality.
> 
> I guess that is what I was trying to suggest, though not very clearly.
> 
> >e.g. IO to a block on a stripe which had one 'bad block'.  The IO should
> >succeed, but the data isn't as safe as elsewhere.  It would be nice if we
> >could tell the filesystem that fact, and if it could make use of it. But we
> >currently cannot.   We can say "success" or "failure", but we cannot say
> >"success, but you might not be so lucky next time".
> >
> 
> Do filesystems re-try reads when there is a failure?  Could you return 
> fail on one read, then success on a re-read, which could be interpreted 
> as "dying, but not yet dead" by the file system?

This should not be a file system feature. The file system is built upon
the raid, and in mirrorred rait types like raid1 and raid10, and also
other raid types, you cannot be sure which specific drive and sector the
data was read from - it could be one out of many (typically two) places.
So the bad blocks of a raid is a feature of the raid and its individual
drives, not the file system. If it was a property of the file system,
then the fs should be aware of the underlying raid topology, and know if
this was a parity block or data block of raid5 or raid6, or which
mirror instance of a raid1/10 type which  was involved. 

Best regards
keld
