From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: DDF Trial Use draft specification now publicly available
Date: Thu, 11 Mar 2004 17:07:06 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4050E30A.80301@pobox.com>
References: <20040311154542.GA6173@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040311154542.GA6173@lists.us.dell.com>
To: linux-raid@vger.kernel.org
Cc: Matt Domsch <Matt_Domsch@dell.com>
List-Id: linux-raid.ids


Ok, having read the whole spec...  it reads like DDF is basically an 
hardware RAID format.  That's not a bad thing, just something that must 
be understood from the beginning.

Thus, when considering this as a "format a hardware RAID controller 
would use, to store all its global and per-array state", here are some 
inherent limitations that apply to DDF, because the global state and 
per-array state is considered from the viewpoint of being limited in 
scope to that of a "controller" -- an entity whose definition is 
amorphous at best when considering things from a Linux blkdev 
perspective.  Linux block devices are quite controller-independent, 
leading to crazy (but flexible) combinations such as md RAID1, with 1 
SCSI disk component, 1 ATA disk component, and 1 remote server using 
nbd, the network block device, serving as the hot spare.

* the scope of some metadata is per-controller.  there doesn't appear to 
be a notion of RAID arrays that can span controllers.

* "minimal" metadata from RAID arrays B, C, D, .. might be stored in 
RAID array A.  This is perfectly understandable -- the hardware RAID 
controller must store its controller-wide state somewhere.  But it is 
unclear what happens to this metadata then a RAID array is moved from 
one vendor's hardware RAID to another.  It is also unclear what the 
behavior of a purely hardware-independent implementation should be.

* the definition/implementation of multiple controllers on a single HBA 
is unclear.

* single level of stacking.  To support RAID0+1 and other "stacked" 
solutions, DDF includes an awful hack:  "secondary RAID level."  Instead 
of truly supporting the notion of nested (stacked) RAID arrays, they 
instead supported a single additional level of stacking - secondary raid 
level.  Several of the limitations related secondary RAID level are 
unclear in the DDF spec.


There is also an IMO significant flaw:

The designers made a good move in choosing GUIDs.  Then they turned 
around and created a 32-bit identifier which is far less unique, and far 
more troublesome than the GUID.  Then 32-bit identifier is what is used 
in the virtual disk (a.k.a. RAID array) description, when listing its 
components.  Argh!  These identifiers need to be eliminated, and the 
GUIDs that each element _already_ provides should be used as the unique 
identifier of choice in all lists, etc.



