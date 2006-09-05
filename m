From: Neil Brown <neilb@suse.de>
Subject: Re: large copy to mdadm array fails, marks readonly
Date: Tue, 5 Sep 2006 20:19:15 +1000
Message-ID: <17661.20259.800623.470395@cse.unsw.edu.au>
References: <a2f3b2d90609050216g324d77e1n29f3debfb42e4c58@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Alan Gibson on Tuesday September 5
Sender: linux-raid-owner@vger.kernel.org
To: Alan Gibson <alan.gibson@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday September 5, alan.gibson@gmail.com wrote:
> hello all, first message to this group.
> 
> Ive recently created a 3 disk raid5 using mdadm. file copy to this
> array fails consistently after a few gigs. the array does not die
> completely, but rather it is marked readonly.

What kernel?

Have you tried running memtest?  It sounds a lot like a hardware
error, though there was a bug in 2.4.0 that could have caused this
sort of thing....

NeilBrown
