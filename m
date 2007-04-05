From: Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: raid6 rebuild
Date: Thu, 5 Apr 2007 08:21:14 +0200
Message-ID: <20070405062114.GB6978@xi.wantstofly.org>
References: <20070404194638.GB3712@xi.wantstofly.org> <Pine.LNX.4.64.0704050701310.20368@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704050701310.20368@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Gordon Henderson <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Apr 05, 2007 at 07:03:08AM +0100, Gordon Henderson wrote:

> > While my RAID6 array was rebuilding after one disk had failed (which
> > I replaced), a second disk failed[*], and this caused the rebuild
> > process to start over from the beginning.
> >
> > Why would the rebuild need to start over from the beginning in this
> > case?  Why couldn't it just continue from where it was?
> 
> I can't answer your question, just make the comment: Hurrah for RAID-6!

Agreed, although I'm still only just in the testing phase with this
array.  It isn't in production yet, and I don't have any important data
on the array that I don't have backups of.


> I presume the restarted rebuild went OK?

Yep, it had just finished when I just woke up, so now it's back from
double-degraded to degraded.  Just in time for the third disk to start
failing, which will probably fail during the rebuild of the second
failed disk after I swap that one out in a couple of minutes..


> > [*] probably an entirely defective batch of 14 Samsung Spinpoint
> > 500G disks
> 
> Lets hope not... Keep checking those SMART values...

Failed disk #2 still reports a SMART status of "PASSED"..
