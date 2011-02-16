From: NeilBrown <neilb@suse.de>
Subject: Re: md road-map: 2011
Date: Thu, 17 Feb 2011 10:01:39 +1100
Message-ID: <20110217100139.7520893d@notabene.brown>
References: <20110216212751.51a294aa@notabene.brown>
	<ijgr9p$7v8$1@dough.gmane.org>
	<20110217083531.3090a348@notabene.brown>
	<ijhje3$ocd$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ijhje3$ocd$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 16 Feb 2011 23:34:43 +0100 David Brown <david.brown@hesbynett.no>
wrote:

> I thought there was some mechanism for block devices to report bad 
> blocks back to the file system, and that file systems tracked bad block 
> lists.  Modern drives automatically relocate bad blocks (at least, they 
> do if they can), but there was a time when they did not and it was up to 
> the file system to track these.  Whether that still applies to modern 
> file systems, I do not know - they only file system I have studied in 
> low-level detail is FAT16.

When the block device reports an error the filesystem can certainly record
that information in a bad-block list, and possibly does.

However I thought you were suggesting a situation where the block device
could succeed with the request, but knew that area of the device was of low
quality.
e.g. IO to a block on a stripe which had one 'bad block'.  The IO should
succeed, but the data isn't as safe as elsewhere.  It would be nice if we
could tell the filesystem that fact, and if it could make use of it. But we
currently cannot.   We can say "success" or "failure", but we cannot say
"success, but you might not be so lucky next time".



NeilBrown
