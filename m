From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Proposed Enhancements to MD
Date: Tue, 13 Jan 2004 10:13:50 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040113171350.GI1437@schnapps.adilger.int>
References: <40036902.8080403@adaptec.com>
 <20040113081932.A721@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20040113081932.A721@lists.us.dell.com>
Content-Disposition: inline
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: Scott Long <scott_long@adaptec.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Jan 13, 2004  08:19 -0600, Matt Domsch wrote:
> On Mon, Jan 12, 2004 at 08:41:54PM -0700, Scott Long wrote:
> > - DDF Metadata support: Future products will use the 'DDF' on-disk
> >    metadata scheme.  These products will be bootable by the BIOS, but
> >    must have DDF support in the OS.  This will plug into the abstraction
> >    mentioned above.
> 
> For those unfamiliar with DDF (Disk Data Format), it is a Storage
> Networking Industry Association (SNIA) project ("Common RAID DDF
> TWG"), designed to provide a single metadata format to be used by all
> the RAID vendors (hardware and software alike).  It removes vendor
> lock-in by having a metadata format that all can use, thus in theory
> you could move disks from an Adaptec hardware RAID controller to an
> LSI software RAID solution without reformatting the disks or touching
> your file systems in any way.  Dell has been championing the DDF
> concept for quite a while, and is driving vendors from which we
> purchase RAID solutions to use DDF instead of their own individual
> metadata formats.
> 
> I haven't seen the spec yet myself, but I'm lead to believe that
> DDF allows for multiple logical drives to be created across a single
> set of disks (e.g. a 10GB RAID1 LD and a 140GB RAID0 LD together on
> two 80GB spindles), as well as whole disks be used.  It has a
> mechanism to support reconstruction checkpointing, so you don't have
> to restart a reconstruct from the beginning after a reboot, but from
> where you left off.  And other useful features too that you'd expect
> in a common RAID solution.  

So, why not use EVMS and/or Device Mapper to read the DDF metadata and
set up the mappings that way?

Cheers, Andreas
--
Andreas Dilger
http://sourceforge.net/projects/ext2resize/
http://www-mddsp.enel.ucalgary.ca/People/adilger/

