From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: ANNOUNCE: mdadm 1.8.0 - A tool for managing Soft RAID under
 Linux
Date: Tue, 30 Nov 2004 12:12:08 +1100
Message-ID: <16811.51432.38875.894801@cse.unsw.edu.au>
References: <16775.316.540974.984718@cse.unsw.edu.au>
	<Pine.LNX.4.61.0411282059360.19614@adsl.a2000.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Stephan van Hienen on Sunday November 28
Sender: linux-raid-owner@vger.kernel.org
To: Stephan van Hienen <raid@a2000.nu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday November 28, raid@a2000.nu wrote:
> On Tue, 2 Nov 2004, Neil Brown wrote:
> 
> > as a source tar-ball and (at the first site) as an SRPM,
> > and as an RPM for i386.
> 
> Neil,
> 
> today i tried to rebuild the src.rpm from 1.8 (which is the latest stable 
> release?)

Yes, 1.8.0 is the one to use.
> 
> but i got this error :
> 
> ]# rpmbuild --rebuild /tmp/mdadm-1.8.1-1.src.rpm
> Installing /tmp/mdadm-1.8.1-1.src.rpm
> warning: user neilb does not exist - using root
> warning: group neilb does not exist - using root
> warning: user neilb does not exist - using root
> warning: group neilb does not exist - using root
> error: line 54: second %install
> 
> i fixed the mdadm.spec file, and it compiled ok
> (removed the % on line 54)
I assume that is
   - change %install to use "make install"
changed to
   - change install to use "make install"

It's just that emacs counts it as line 53

> 
> maybe fix this in later releases ?
> 
> (i was compiling this on tao (based on rhes 3))

Thanks.
NeilBrown
