From: "Justin T. Gibbs" <Justin_Gibbs@adaptec.com>
Subject: Re: [Fwd: "Enhanced" MD code avaible for review]
Date: Wed, 17 Mar 2004 12:05:51 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <2260532704.1079550351@aslan.btc.adaptec.com>
References: <405899E8.8070806@pobox.com> <20040317183756.GA23667@lst.de> <2241002704.1079549645@aslan.btc.adaptec.com> <20040317190117.GA23968@lst.de>
Reply-To: "Justin T. Gibbs" <Justin_Gibbs@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040317190117.GA23968@lst.de>
Content-Disposition: inline
To: Christoph Hellwig <hch@lst.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> On Wed, Mar 17, 2004 at 11:54:05AM -0700, Justin T. Gibbs wrote:
>> > On Wed, Mar 17, 2004 at 01:33:12PM -0500, Jeff Garzik wrote:
>> >> A patch to fs/partitions/check.c is also required for this
>> >> release to function correctly:
>> 
>> Hmm.  I don't think Jeff wrote that.
> 
> That's why it's doubly-quoted, right?

Hmm.  I didn't realize that Jeff was ever part of this thread.
I authored the text that you quoted and was just surprised to see
Jeff's name near it.  Never mind.

>> So do you speak for the entire community in expressing that auto-detection
>> will never make sense in the kernel?  Are you completely unwilling to
>> entertain even a minor discussion on the topic for those of us that don't
>> understand the concerns the community has in supporting it?
> 
> I speak about the concencus the 'community' has reached in the past.
> If you invested the tiniest amount of googling you'd have seen messages
> from Neil where he sais he'd rather get rid of autodetection ioctls
> in favour of mdadm doing the work, and patches extending autodetection
> beeing rejected.  Which pretty much fits into the general do it in
> userspace if you can rule.

I'm aware of Neil's past comments on the subject, but I was not aware
of a more full discussion on what this means in terms of lost functionality
for Linux.  I would like to have that discussion.  I'm more than willing
to adjust our strategy once that discussion takes place and a consensus
is reached.

--
Justin

