From: Chris Murphy <lists@colorremedies.com>
Subject: Re: RAID performance
Date: Thu, 7 Feb 2013 15:03:48 -0700
Message-ID: <9DD5BA53-A9DF-4D8C-AE5C-BD6D69FAEF2C@colorremedies.com>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <5113A3D4.6000605@turmel.org> <5113A4E9.5020005@websitemanagers.com.au> <5113A628.6010304@turmel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5113A628.6010304@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Adam Goryachev <mailinglists@websitemanagers.com.au>, Dave Cundiff <syshackmin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Feb 7, 2013, at 6:03 AM, Phil Turmel <philip@turmel.org> wrote:

> 
> Trim is a per-sector property.  Once trimmed, it stays trimmed until you
> write to *that* sector.

I agree, although I think technically it is an attribute of the page, since that's the smallest structure on an SSD for read/write. The page sizes appear to be either 4KB or 8KB, while the SSD basically lies to the OS and says its physical sector size is 512 bytes.

Once all pages in an SSD erase block are flagged for erase, which could be done with a SATA TRIM command or (dynamic or static) wear leveling by the SSD itself, then those pages can be erased.

I think what the SSD vendors  have done is, since all requests by an OS are in 4KB blocks, whether or not those LBA's are 4K aligned (like is required for 512e AF disks), they can stuff any 4KB fs block into a 4KB or 8KB page, aligned.

> If you want to achieve something with trim, you would
> trim on your clients and hope it passes all the way down the stack
> through iSCSI to your LVs and then to MD and the SSDs.


TRIM probably does reduce the need for the firmware to do its own static wear leveling, but I don't know if it's that significant except for large deletions. If it were the case that SSD's reliably returned zeros for unassigned LBAs (i.e. LBAs previously TRIM'd), there could be some optimization for the lowest level to translate page sized writes of only zeros into TRIM commands.

But for performance purposes, I don't see that it makes much difference. Over provisioning and dynamic wear leveling take care of the performance concern. And it seems to me the usual rules of thumbs for chunk size apply; maybe being a bit more on the conservative size (tending to smaller) makes more sense, to avoid large unnecessary RMW.

On the one hand a chunk size exactly sized and aligned with an SSD erase block might seem ideal; but while it might improve the efficiency of the SSD garbage collecting those blocks, it translates into higher wear.

> You just have nothing useful on the server side for trim to do.
> (Although you should manually trim the unpartitioned space.  You only
> need to do so once.)


It's unclear to me that user over provisioning is necessary. The SSD is already over-provisioned. I can see where a mismatch in usage could be a problem, e.g. enterprise patterns while using consumer SSDs.


Chris Murphy