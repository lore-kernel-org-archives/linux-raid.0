From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Root Drive Mirroring and LVM.
Date: Thu, 5 Feb 2004 10:07:32 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16417.31540.78193.699721@notabene.cse.unsw.edu.au>
References: <20040204122317.K27780@forte.austin.ibm.com>
	<Pine.LNX.4.44.0402041726350.20232-100000@coffee.psychology.mcmaster.ca>
	<20040204164946.P27780@forte.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from linas@austin.ibm.com on Wednesday February 4
To: linas@austin.ibm.com
Cc: Mark Hahn <hahn@physics.mcmaster.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday February 4, linas@austin.ibm.com wrote:
> On Wed, Feb 04, 2004 at 05:32:01PM -0500, Mark Hahn wrote:
> > > So what's wrong with autodetect, again?
> > 
> > my guess is: in-kernel autodetect is the problem.  
> > out-of-kernel detection can be much smarter, 
> > and can be more easily tested/replaced.
> 
> Hm, yes, that makes sense.


Good :-)

Just to flesh out my thoughts a bit more:

 If the root filesystem is on an MD array, then I see the process of
 assembling that md array as quite similar to the process of finding
 the device for the root filesystem.

 We don't expect the kernel, or anyone else, to scan all devices
 looking for something that looks like a root filesystem, and loading
 that.  Rather we tell the kernel or boot loader exactly where to find
 the root filesystem.  And if the root filesystem moves, we get to
 explicitly tell the boot loader where it is (root=/dev/hdc1 or
 whatever).
 Assembling the root device should be handled the same way.  We tell
 the boot loader/kernel where to expect it, but can over-ride that if
 we need to:
   md=0,/dev/hdc1,/dev/hde4

 All other md arrays can, and so should, be assembled by code running
 out of the root filesystem.   This could be some program that
 assembles anything it finds after scanning all devices, or something
 a bit more focused, but it should be controllable by the sysadmin.

 It is true that in-kernel auto-detect can be controlled by fiddling
 with partition types, but the problem is that it runs *before* the
 root filesystem is mounted and so could conceivably confuse the
 assembly of the root device (if e.g. you plugged in some other device
 that also claimed to be part of /dev/md0, and it got scanned before
 your real root device).

NeilBrown
