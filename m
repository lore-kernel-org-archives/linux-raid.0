From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: RE: Bad blocks are killing us!
Date: Wed, 17 Nov 2004 10:04:25 +1100
Message-ID: <16794.34681.356891.746036@cse.unsw.edu.au>
References: <16793.11589.337840.541169@cse.unsw.edu.au>
	<200411161818.iAGIIrN27121@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Guy on Tuesday November 16
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday November 16, bugzilla@watkins-home.com wrote:
> This sounds great!
> 
> But...
> 
> 2/  Do you intend to create a user space program to attempt to correct the
> bad block and put the device back in the array automatically?  I
> hope so.

Definitely.  It would be added to the functionality of "mdadm --monitor".

> 
> If not, please consider correcting the bad block without kicking the device
> out.  Reason:  Once the device is kicked out, a second bad block on another
> device is fatal to the array.  And this has been happening a lot
> lately.

This one of several things that makes it "a bit less trivial" than
simply using the bitmap stuff.  I will keep your comment in mind when
I start looking at this in more detail.  Thanks.

> 
> 3/  Maybe don't do the bad block scan if the array is degraded.  Reason: If
> a bad block is found, that would kick out a second disk, which is fatal.
> Since the stated purpose of this is to "check parity/copies are correct"
> then you probably can't do this anyway.  I just want to be sure.  Also, if
> during the scan, if a device is kicked, the scan should pause or abort.  The
> scan can resume once the array has been corrected.  I would be happy if the
> scan had to be restarted from the start.  So a pause or abort is fine with
> me.

I hadn't thought about that yet.  I suspect there would be little
point in doing a scan when there was no redundancy.  However a scan on
a degraded raid6 that could still safely loose one drive would
probably make sense.

NeilBrown
