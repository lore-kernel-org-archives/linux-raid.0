From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: DDF Trial Use draft specification now publicly available
Date: Fri, 12 Mar 2004 16:07:22 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4052268A.2000806@pobox.com>
References: <20040311154542.GA6173@lists.us.dell.com> <4050CF66.8090409@pobox.com> <4051667A.5010303@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4051667A.5010303@adaptec.com>
To: Scott Long <scott_long@adaptec.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Scott Long wrote:
> Complexity != brokenness

Agreed, but complexity is also something that is one of the key things 
to resist...  Favorite Linus maxims include "don't overdesign" and "do 
what you need to do, and no more"  ;-)


> Recording information about all disks and arrays on every disk means
> that you can detect when a whole array is missing.  The more complex
> array information means that you can express mutli-level arrays in a
> reasonable way.  We've already spoken a little bit about this.  There is

I think you're missing an overall point about scope.  DDF configuration 
is not global, from the standpoint of a Linux system.  md's 
configuration (raidtab, etc) is.

Therefore, from the standpoint from the entire Linux system, the 
definition "all disks and arrays" varies from one RAID "domain" to another.

This artificial partitioning into domains is obviously required for 
hardware RAID -- a single controller does not know anything more than 
what spindles are attached to it.

But...  this partitioning, the _initialization and ordering of domains_, 
varies from controller to controller, and sometimes AFAICS from one 
setup to setup.  The Linux kernel now has to organize all that into a 
coherent picture.

"Getting RAID domains right" is where I see a lot of complexity...  The 
simplicity of md's raidtab provides the same thing in userspace -- just 
list the ordering in a text file.  The kernel only really cares about 
auto-running the RAID upon which your root filesystem (and raidtab) lives.


> also quite a bit of information in the format that allows you to
> validate each disk and determine how much your 'trust' it.  While this
> certainly adds complexity, it also strengthens the notion that RAID is
> about ensuring integrety.  Of course it doesn't slow down the actual
> transform of a raid-0, so you can still measure it's worthiness that
> way =-)

Yeah, the basic r/w fast path isn't too tough, it's not only  error 
handling but also the minute variations in RAID formats where things 
gets fun :)


> As Matt Domsch mentioned earlier, Adaptec has been working on a DDF
> implementation for Linux under MD.  We are putting the final touches on
> it right now (as I type this at 12:30am) and getting it ready for formal
> testing.  After that, we will release it to the Linux community for
> review and inclusion.  As an added benefit, our Enhanced MD will also
> provide full (and Open) support for Adaptec HostRAID.

Yep, looking forward to it :)

	Jeff




