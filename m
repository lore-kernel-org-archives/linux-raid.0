From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: RFC - new raid superblock layout for md driver
Date: 21 Nov 2002 21:29:36 +0000
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1037914176.9122.2.camel@irongate.swansea.linux.org.uk>
References: <15835.2798.613940.614361@notabene.cse.unsw.edu.au>
	<20021120160259.GW806@nic1-pc.us.oracle.com>
	<15836.7011.785444.979392@notabene.cse.unsw.edu.au>
	<20021121014625.GA14063@redhat.com>
	<20021121193424.GB770@nic1-pc.us.oracle.com>
	<20021121195406.GF14063@redhat.com>  <3DDD3AB6.2010105@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <3DDD3AB6.2010105@mvista.com>
To: Steven Dake <sdake@mvista.com>
Cc: Doug Ledford <dledford@redhat.com>, Joel Becker <Joel.Becker@oracle.com>, Neil Brown <neilb@cse.unsw.edu.au>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 2002-11-21 at 19:57, Steven Dake wrote:
> Doug,
> 
> EVMS integrates all of this stuff together into one cohesive peice of 
> technology.
> 
> But I agree, LVM should be modified to support RAID 1 and RAID 5, or MD 
> should be modified to support volume management.  Since RAID 1 and RAID 
> 5 are easier to implement, LVM is probably the best place to put all 
> this stuff.

User space issue. Its about the tools view not about the kernel drivers.
