From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Bad blocks are killing us!
Date: Tue, 16 Nov 2004 18:07:42 -0500
Message-ID: <200411162307.iAGN7lN28260@www.watkins-home.com>
References: <16794.34681.356891.746036@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16794.34681.356891.746036@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: 'Neil Brown' <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil said:
"I hadn't thought about that yet.  I suspect there would be little
point in doing a scan when there was no redundancy.  However a scan on
a degraded raid6 that could still safely loose one drive would
probably make sense."

I agree.

Also a RAID1 with 2 or more working devices.  Don't forget, some people have
3 or more devices on the RAID1 arrays.  From what I have read anyway.

Thanks,
Guy

-----Original Message-----
From: Neil Brown [mailto:neilb@cse.unsw.edu.au] 
Sent: Tuesday, November 16, 2004 6:04 PM
To: Guy
Cc: linux-raid@vger.kernel.org
Subject: RE: Bad blocks are killing us!

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
> If not, please consider correcting the bad block without kicking the
device
> out.  Reason:  Once the device is kicked out, a second bad block on
another
> device is fatal to the array.  And this has been happening a lot
> lately.

This one of several things that makes it "a bit less trivial" than
simply using the bitmap stuff.  I will keep your comment in mind when
I start looking at this in more detail.  Thanks.

> 
> 3/  Maybe don't do the bad block scan if the array is degraded.  Reason:
If
> a bad block is found, that would kick out a second disk, which is fatal.
> Since the stated purpose of this is to "check parity/copies are correct"
> then you probably can't do this anyway.  I just want to be sure.  Also, if
> during the scan, if a device is kicked, the scan should pause or abort.
The
> scan can resume once the array has been corrected.  I would be happy if
the
> scan had to be restarted from the start.  So a pause or abort is fine with
> me.

I hadn't thought about that yet.  I suspect there would be little
point in doing a scan when there was no redundancy.  However a scan on
a degraded raid6 that could still safely loose one drive would
probably make sense.

NeilBrown

