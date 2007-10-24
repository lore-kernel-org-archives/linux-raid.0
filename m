From: Neil Brown <neilb@suse.de>
Subject: Re: Time to  deprecate old RAID formats?
Date: Thu, 25 Oct 2007 09:55:21 +1000
Message-ID: <18207.56169.769976.512617@notabene.brown>
References: <18200.49267.763509.924873@stoffel.org>
	<Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>
	<18200.53593.687483.120827@stoffel.org>
	<1192810534.1666.68.camel@firewall.xsintricity.com>
	<18200.56684.14194.630264@stoffel.org>
	<1192813877.1666.79.camel@firewall.xsintricity.com>
	<18200.63987.514073.184865@stoffel.org>
	<471E7DC6.7050206@tmr.com>
	<1193184555.10336.3.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Doug Ledford on Tuesday October 23
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Bill Davidsen <davidsen@tmr.com>, John Stoffel <john@stoffel.org>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday October 23, dledford@redhat.com wrote:
> On Tue, 2007-10-23 at 19:03 -0400, Bill Davidsen wrote:
> > John Stoffel wrote:
> > > Why do we have three different positions for storing the superblock?  
> > >   
> > Why do you suggest changing anything until you get the answer to this 
> > question? If you don't understand why there are three locations, perhaps 
> > that would be a good initial investigation.
> > 
> > Clearly the short answer is that they reflect three stages of Neil's 
> > thinking on the topic, and I would bet that he had a good reason for 
> > moving the superblock when he did it.
> 
> I believe, and Neil can correct me if I'm wrong, that 1.0 (at the end of
> the device) is to satisfy people that want to get at their raid1 data
> without bringing up the device or using a loop mount with an offset.
> Version 1.1, at the beginning of the device, is to prevent accidental
> access to a device when the raid array doesn't come up.  And version 1.2
> (4k from the beginning of the device) would be suitable for those times
> when you want to embed a boot sector at the very beginning of the device
> (which really only needs 512 bytes, but a 4k offset is as easy to deal
> with as anything else).  From the standpoint of wanting to make sure an
> array is suitable for embedding a boot sector, the 1.2 superblock may be
> the best default.
> 

Exactly correct.

Another perspective is that I chickened out of making a decision and
chose to support all the credible possibilities that I could think of.
And showed that I didn't have enough imagination.  The other
possibility that I should have included (as has been suggested in this
conversation, and previously on this list) is to store the superblock
both at the beginning and the end for redundancy.  However I cannot
decide whether to combine the 1.0 and 1.1 locations, or the 1.0 and
1.2.  And I don't think I want to support both (maybe I've learned my
lesson).

As for where the metadata "should" be placed, it is interesting to
observe that the SNIA's "DDFv1.2" puts it at the end of the device.
And as DDF is an industry standard sponsored by multiple companies it
must be ......
Sorry.  I had intended to say "correct", but when it came to it, my
fingers refused to type that word in that context.

DDF is in a somewhat different situation though.  It assumes that the
components are whole devices, and that the controller has exclusive
access - there is no way another controller could interpret the
devices differently before the DDF controller has a chance.

DDF is also interesting in that it uses 512 byte alignment for
metadata.  The 'anchor' block is in the last sector of the device.
This contrasts with current md metadata which is all 4K aligned.
Given that the drive manufacturers seem to be telling us that "4096 is
the new 512", I think 4K alignment was a good idea.
It could be that DDF actually specifies the anchor to reside in the
last "block" rather than the last "sector", and it could be that the
spec allows for block size to be device specific - I'd have to hunt
through the spec again to be sure.

For the record, I have no intention of deprecating any of the metadata
formats, not even 0.90.
It is conceivable that I could change the default, though that would
require a decision as to what the new default would be.  I think it
would have to be 1.0 or it would cause too much confusion.

I think it would be entirely appropriate for a distro (especially an
'enterprise' distro) to choose a format and location that it was going
to standardise on and support, and make that the default on that
distro (by using a CREATE line in mdadm.conf).  Debian has already
done this by making 1.0 the default.

I certainly accept that the documentation is probably less that
perfect (by a large margin).  I am more than happy to accept patches
or concrete suggestions on how to improve that.  I always think it is
best if a non-developer writes documentation (and a developer reviews
it) as then it is more likely to address the issues that a
non-developer will want to read about, and in a way that will make
sense to a non-developer. (i.e. I'm to close to the subject to write
good doco).

NeilBrown

