From: Doug Ledford <dledford@redhat.com>
Subject: Re: RFC - new raid superblock layout for md driver
Date: Thu, 21 Nov 2002 15:38:29 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20021121203829.GH14063@redhat.com>
References: <15835.2798.613940.614361@notabene.cse.unsw.edu.au> <20021120160259.GW806@nic1-pc.us.oracle.com> <15836.7011.785444.979392@notabene.cse.unsw.edu.au> <20021121014625.GA14063@redhat.com> <20021121193424.GB770@nic1-pc.us.oracle.com> <20021121195406.GF14063@redhat.com> <3DDD3AB6.2010105@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3DDD3AB6.2010105@mvista.com>
To: Steven Dake <sdake@mvista.com>
Cc: Joel Becker <Joel.Becker@oracle.com>, Neil Brown <neilb@cse.unsw.edu.au>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Nov 21, 2002 at 12:57:42PM -0700, Steven Dake wrote:
> Doug,
> 
> EVMS integrates all of this stuff together into one cohesive peice of 
> technology.
> 
> But I agree, LVM should be modified to support RAID 1 and RAID 5, or MD 
> should be modified to support volume management.  Since RAID 1 and RAID 
> 5 are easier to implement, LVM is probably the best place to put all 
> this stuff.

Yep.  I tend to agree there.  A little work to make device mapping modular
in LVM, and a little work to make the md modules plug into LVM, and you
could be done.  All that would be left then is adding the right stuff into
the user space tools.  Basically, what irks me about the current situation
is that right now in the Red Hat installer, if I want LVM features I have
to create one type of object with a disk, and if I want reasonable
software RAID I have to create another type of object with partitions.  
That shouldn't be the case, I should just create an LVM logical volume,
assign physical disks to it, and then additionally assign the redundancy
or performance layout I want (IMNSHO) :-)


-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
