From: Scott Long <scott_long@adaptec.com>
Subject: Re: DDF Trial Use draft specification now publicly available
Date: Fri, 12 Mar 2004 15:27:05 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40523939.8030609@adaptec.com>
References: <20040311154542.GA6173@lists.us.dell.com> <4050CF66.8090409@pobox.com> <4051667A.5010303@adaptec.com> <4052268A.2000806@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4052268A.2000806@pobox.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jeff Garzik wrote:
> Scott Long wrote:
>  > Complexity != brokenness
> 
> Agreed, but complexity is also something that is one of the key things
> to resist...  Favorite Linus maxims include "don't overdesign" and "do
> what you need to do, and no more"  ;-)

Doing the job right might lead to complexity.  RAID is about doing the
job right.  The 'R' in RAID doesn't stand for 'Fast' or 'Simple'.

> 
> 
>  > Recording information about all disks and arrays on every disk means
>  > that you can detect when a whole array is missing.  The more complex
>  > array information means that you can express mutli-level arrays in a
>  > reasonable way.  We've already spoken a little bit about this.  There is
> 
> I think you're missing an overall point about scope.  DDF configuration
> is not global, from the standpoint of a Linux system.  md's
> configuration (raidtab, etc) is.
> 
> Therefore, from the standpoint from the entire Linux system, the
> definition "all disks and arrays" varies from one RAID "domain" to another.
> 
> This artificial partitioning into domains is obviously required for
> hardware RAID -- a single controller does not know anything more than
> what spindles are attached to it.
> 
> But...  this partitioning, the _initialization and ordering of domains_,
> varies from controller to controller, and sometimes AFAICS from one
> setup to setup.  The Linux kernel now has to organize all that into a
> coherent picture.
> 

The GUID _is_ unique, and is the authority.  The spec even details how
it is to be made unique so that it (hopefully) never collides between
domains.  Great care is taken in the spec to allow disks and arrays
to migrate between domains.  The only flaw is that it doesn't allow
the concept of overlapped domains, or disks with multiple parents.  But
that really isn't what you are talking about here.

As for domain scope within linux, it is a flaw of linux that the raid
raid stack can't reliably get pathing information to figure out it's
topology (and thus it's domain).

> "Getting RAID domains right" is where I see a lot of complexity...  The
> simplicity of md's raidtab provides the same thing in userspace -- just
> list the ordering in a text file.  The kernel only really cares about
> auto-running the RAID upon which your root filesystem (and raidtab) lives.

Linux raidtab doesn't allow you to boot off of your array.  Yes, there
are some hacks out there to boot off of a single disk of a mirror and
let MD/DM/whatever take over and supplant it with the real raid device.
That doesn't do anything for you when you are talking about RAID0 or
RAID10.

> 
> 
>  > also quite a bit of information in the format that allows you to
>  > validate each disk and determine how much your 'trust' it.  While this
>  > certainly adds complexity, it also strengthens the notion that RAID is
>  > about ensuring integrety.  Of course it doesn't slow down the actual
>  > transform of a raid-0, so you can still measure it's worthiness that
>  > way =-)
> 
> Yeah, the basic r/w fast path isn't too tough, it's not only  error
> handling but also the minute variations in RAID formats where things
> gets fun :)
> 

The role of the metadata is pretty insigificant in the scope of error
handling.  95% of the error handling code that we have in Enhanced MD
is independent of the metadata; the metadata code is only there to
record the state changes and decide if one state change leads to
another.

Scott

