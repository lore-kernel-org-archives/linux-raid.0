From: Brian Candler <B.Candler@pobox.com>
Subject: Re: Removing a failing drive from multiple arrays
Date: Thu, 26 Apr 2012 14:23:36 +0100
Message-ID: <20120426132336.GA12692@nsrc.org>
References: <4F905F66.6070803@tmr.com>
 <20369.29756.761374.308057@quad.stoffel.home>
 <4F918F5C.2000607@anonymous.org.uk>
 <CAK2H+efwgznsS4==Rrtm6UE=uOb25-Q0Qm84i8yAJEJJ2JLdgg@mail.gmail.com>
 <4F9450D1.40305@anonymous.org.uk> <4F98B4FE.5010101@tmr.com>
 <20120426073607.GA11590@nsrc.org> <4F994695.9010509@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4F994695.9010509@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Apr 26, 2012 at 08:59:01AM -0400, Bill Davidsen wrote:
> >Another option, although I've not done this for a long time, is PXE boot.
> >You need a DHCP server giving out the correct parameters and a TFTP server
> >for the kernel (and ramdisk?)
> >
> 
> I think that's addressing one point of failure while adding more.

Alternate point of view: you need reliable DNS anyway, and it's no harder to
make reliable DHCP than reliable DNS (you just have two of them).
Furthermore, this only needs to be available at the time a server boots up.

I worked in one place where they made all the servers (which were VMs) pick
up their IPs via DHCP.  This allowed them to dump the images across to the
disaster recovery site, boot them up there, and bring them all up on new IPs
without touching any configs.  It worked well.  They ran DHCP service on the
Cisco L3 switches that the VM hosts were plugged into, on the basis that
this was the most reliable kit that they had.

Like you say, it's a balancing act of cost, complexity, and reliability, and
is also coloured by experience.  I've had not-so-good experiences with USB
thumb drives.

Regards,

Brian.
