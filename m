From: Neil Brown <neilb@suse.de>
Subject: Re: RAID6 mdadm --grow bug?
Date: Thu, 13 Sep 2007 19:49:47 +0200
Message-ID: <18153.30779.865508.713927@notabene.brown>
References: <42161BFD-EAE6-4485-8DE6-05D0EBE51A06@fusion.gat.com>
	<18153.5726.377390.171544@notabene.brown>
	<B5D1BE90-0B04-472F-BC92-5AB446DA0C77@fusion.gat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David Miller on Thursday September 13
Sender: linux-raid-owner@vger.kernel.org
To: David Miller <millerdc@fusion.gat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday September 13, millerdc@fusion.gat.com wrote:
> Neil,
> 
> On RHEL5 the kernel is 2.6.18-8.1.8. On Ubuntu 7.04 the kernel is  
> 2.6.20-16. Someone on the Arstechnica forums wrote they see the same  
> thing in Debian etch running kernel 2.6.18. Below is a messages log  
> from the RHEL5 system. I have only included the section for creating  
> the RAID6, adding a spare and trying to grow it. There is a one line  
> error when I do the "mdadm --grow" command. It is "md: couldn't  
> update array info. -22."

reshaping raid6 arrays was not supported until 2.6.21.  So you'll need
a newer kernel.

NeilBrown
