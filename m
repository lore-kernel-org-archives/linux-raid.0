From: Doug Ledford <dledford@redhat.com>
Subject: Re: RFC - new raid superblock layout for md driver
Date: Thu, 21 Nov 2002 16:22:51 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021121212251.GI14063@redhat.com>
References: <15835.2798.613940.614361@notabene.cse.unsw.edu.au> <20021120160259.GW806@nic1-pc.us.oracle.com> <15836.7011.785444.979392@notabene.cse.unsw.edu.au> <20021121014625.GA14063@redhat.com> <20021121193424.GB770@nic1-pc.us.oracle.com> <20021121195406.GF14063@redhat.com> <3DDD3AB6.2010105@mvista.com> <1037914176.9122.2.camel@irongate.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1037914176.9122.2.camel@irongate.swansea.linux.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Steven Dake <sdake@mvista.com>, Joel Becker <Joel.Becker@oracle.com>, Neil Brown <neilb@cse.unsw.edu.au>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Nov 21, 2002 at 09:29:36PM +0000, Alan Cox wrote:
> On Thu, 2002-11-21 at 19:57, Steven Dake wrote:
> > Doug,
> > 
> > EVMS integrates all of this stuff together into one cohesive peice of 
> > technology.
> > 
> > But I agree, LVM should be modified to support RAID 1 and RAID 5, or MD 
> > should be modified to support volume management.  Since RAID 1 and RAID 
> > 5 are easier to implement, LVM is probably the best place to put all 
> > this stuff.
> 
> User space issue. Its about the tools view not about the kernel drivers.

Not entirely true.  You could do everything in user space except online 
resize of raid0/4/5 arrays, that requires specific support in the md 
modules and it begs for integration between LVM and MD since the MD is 
what has to resize the underlying device yet it's the LVM that usually 
handles filesystem resizing.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
