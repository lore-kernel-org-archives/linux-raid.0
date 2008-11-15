From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: 2.6.27.6 question: ata_sff_hsm_move: ata15 (why always ata15)?
Date: Fri, 14 Nov 2008 21:22:58 -0600
Message-ID: <491E4092.5030804@shaw.ca>
References: <alpine.DEB.1.10.0811141850590.6217@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753778AbYKODXW@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0811141850590.6217@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-ide@vger.kernel.org, linux-raid@vger.kernel.orglinux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz wrote:
> I am trying to find out what the root cause of this error/problem is:
> https://bugzilla.redhat.com/show_bug.cgi?id=462425

The problem is that people assume that timeouts with DRDY like that bug 
refers to must be the same problem when it is often not, and so bug 
reports like this end up conflated with all manner of different issues. 
It's one of the most generic errors imaginable. Also, as one of the 
posters mentions, "I think this problem tends to get ignored because 
there are so many things that can cause it (bad drives, cables, power 
supplies, or any combination thereof).."  Just because older kernels did 
work doesn't necessarily prove anything, if they didn't do NCQ (which in 
the Marvell case, I think older kernels didn't) or are pushing the disk 
subsystem harder this may expose hardware issues that didn't show up on 
older kernels.

One really needs to isolate individual problems and try some hardware 
debugging before looking into the kernel for such problems..

> 
> It seems like every week or other week someone else reports this on the 
> linux-raid mailing list.
> 
> I have enabled debugging in the libata.h file and I find that ata15 is 
> constantly being accessed for some reason, why is this?

Presumably ata15 is the port the DVD-RW is connected to, likely HAL is 
polling for media or something..
