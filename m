From: greg@enjellic.com
Subject: Utility of IOATDMA for RAID5.
Date: Thu, 11 Mar 2010 15:09:40 -0600
Message-ID: <201003112109.o2BL9eJB003728@wind.enjellic.com>
Reply-To: greg@enjellic.com
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: dan.j.williams@intel.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Dan, hope this note finds your week going well.

We are starting to bring Nehalem/XEON server motherboards which have
the onboard DMA I/O offload support into our shop as part of our
current purchasing round.  We have spun up a 2.6.32 kernel for testing
and have been able to load the modules etc.

We use SCST to implement geographically isolated storage mirrors.  We
primarily use RAID5 since our redundancy architecture gives us a bit
of luxury which a single RAID5 implementation would not.

If I understand things correctly your current work supports RAID6
only.  Are there are any plans to support RAID5?  Or perhaps more
correctly is there any utility to supporting RAID5 given the memory
speeds and core counts which are now available?

Thanks in advance for any thoughts you may have.

Best wishes for a pleasant weekend.

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"I'm having a really crappy weekend -- my goldfish died and my RAID
 array crapped out."
                                -- jmolina
                                   linux-raid
