From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Testing md modules?
Date: Fri, 27 Feb 2004 16:49:21 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16446.55905.531219.529867@notabene.cse.unsw.edu.au>
References: <6.0.1.1.2.20040226233706.0290bec0@mail.athenet.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Nathan Lewis on Thursday February 26
To: Nathan Lewis <nathapl@cs.okstate.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday February 26, nathapl@cs.okstate.edu wrote:
> I'm to the point now where my Reed-Solomon code appears to be working, at 
> least for some simple tests I've thrown at it.  I'd like to test it more 
> exhaustively - does anybody have any scripts or programs that work 
> deterministicly on a block device to test it for correctness?  What has 
> been done in the past to make sure the previous RAID modules worked, beside 
> sticking the code out there and waiting for bug reports?

untar a complete kernel source, and compile it.
Lots of times in parallel.

It certainly isn't guaranteed to find all problems, but it is easy to
do and will exercise a lot of code.

You should randomly fail drives and start rebuilds while that is
happening.

Also diff -r of two kernel trees after exploding them.

And make sure you are short of memory so that lots of reads go to
disk.

NeilBrown
