From: Scott Long <scott_long@adaptec.com>
Subject: Re: DDF Trial Use draft specification now publicly available
Date: Fri, 12 Mar 2004 00:55:12 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40516CE0.2020707@adaptec.com>
References: <20040311154542.GA6173@lists.us.dell.com> <4050E30A.80301@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4050E30A.80301@pobox.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-raid@vger.kernel.org, Matt Domsch <Matt_Domsch@dell.com>
List-Id: linux-raid.ids

Jeff Garzik wrote:
> 
> Ok, having read the whole spec...  it reads like DDF is basically an
> hardware RAID format.  That's not a bad thing, just something that must
> be understood from the beginning.
> 

That's funny, since I know of no less than two software implementations
of DDF that work fine.

> Thus, when considering this as a "format a hardware RAID controller
> would use, to store all its global and per-array state", here are some
> inherent limitations that apply to DDF, because the global state and
> per-array state is considered from the viewpoint of being limited in
> scope to that of a "controller" -- an entity whose definition is
> amorphous at best when considering things from a Linux blkdev
> perspective.  Linux block devices are quite controller-independent,
> leading to crazy (but flexible) combinations such as md RAID1, with 1
> SCSI disk component, 1 ATA disk component, and 1 remote server using
> nbd, the network block device, serving as the hot spare.
> 
> * the scope of some metadata is per-controller.  there doesn't appear to
> be a notion of RAID arrays that can span controllers.

It's pretty non-typical for a RAID controller to support chaining.
However, the flaw that I see is that there seems to be an assumption
that there will only be one controller in a DDF domain.  Thus,
Active-Active configurations that are common in the FC/SAN world make no
sense to DDF.  Same goes for clustered SCSI, and SAS.  It's unfortunate
that this is such a gaping hole in the spec.  We'll have to see if
it's a fatal flaw or if it can be fixed in a future version of the
spec.

In the context of software raid, the definition is a little less
defined and depends only on how inter-operable you want to be.  Does
a 'controller' mean the whole system, or just some logical segment
of it?  Unfortunately, the linux SCSI layer provides no concept of
a 'path', so it's very, very hard to determine the topology of your
storage from software.  This is a limitation of Linux, not DDF.

> 
> * "minimal" metadata from RAID arrays B, C, D, .. might be stored in
> RAID array A.  This is perfectly understandable -- the hardware RAID
> controller must store its controller-wide state somewhere.  But it is
> unclear what happens to this metadata then a RAID array is moved from
> one vendor's hardware RAID to another.  It is also unclear what the
> behavior of a purely hardware-independent implementation should be.

What parts are you unclear on?  DDF is meant to be a transportable
format; you can take disks from one DDF-compliant domain to another and
it 'Just Works'.  Whether the recieving domain chooses to migrate the
metadata is up to the policy of the controller so as long as the
migration retains DDF compliance.

> 
> * the definition/implementation of multiple controllers on a single HBA
> is unclear.

I'm not sure what you mean here.  Are you talking about multiple 
controllers talking to the same disk, like I mentioned above?

> 
> * single level of stacking.  To support RAID0+1 and other "stacked"
> solutions, DDF includes an awful hack:  "secondary RAID level."  Instead
> of truly supporting the notion of nested (stacked) RAID arrays, they
> instead supported a single additional level of stacking - secondary raid
> level.  Several of the limitations related secondary RAID level are
> unclear in the DDF spec.

In practice, arbitrary n-level stacking isn't terribly useful.  Yes, it
would be nice if it cleanly supported this, but you've already
complained that the spec is too complex as it is ;-)

> 
> 
> There is also an IMO significant flaw:
> 
> The designers made a good move in choosing GUIDs.  Then they turned
> around and created a 32-bit identifier which is far less unique, and far
> more troublesome than the GUID.  Then 32-bit identifier is what is used
> in the virtual disk (a.k.a. RAID array) description, when listing its
> components.  Argh!  These identifiers need to be eliminated, and the
> GUIDs that each element _already_ provides should be used as the unique
> identifier of choice in all lists, etc.

Yeah, it is strange that they mix GUIDs and Unique Identifiers, but it
is not a fatal flaw.  The GUID can be used to resolve collisions of
the Unique Id, since you know about every disk in your domain.

Anyways, DDF is certainly not perfect, but it's decent for the target
market and not terribly difficult to implement in software.

Scott

