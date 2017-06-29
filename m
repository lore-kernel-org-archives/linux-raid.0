From: Shaohua Li <shli@kernel.org>
Subject: Re: Big Endian RAID discovery problem (metadata 1!)
Date: Thu, 29 Jun 2017 14:54:53 -0700
Message-ID: <20170629215453.oswihni5xwcsbihq@kernel.org>
References: <3667530.kn15F7ggIU@daneel.sf-tec.de>
 <AE3DE84B-9DF9-40DD-8DE2-1DD3D3CE3650@athompso.net>
 <10863311.m9o1njCPed@daneel.sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <10863311.m9o1njCPed@daneel.sf-tec.de>
Sender: linux-raid-owner@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Adam Thompson <athompso@athompso.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jun 28, 2017 at 10:14:21PM +0200, Rolf Eike Beer wrote:
> Am Mittwoch, 28. Juni 2017, 13:55:09 schrieb Adam Thompson:
> > If you search the archives, I had a very similar problem a few months ago.
> > There is already an option to mdadm to update a v1 superblock in the wrong
> > byte order.  It just wasn't obvious when looking at the mdadm man page.
> > Going from memory, search for "byte order" instead of "endian" to find the
> > option. -Adam
> 
> If you refer to --update=byteorder, the documentation says it is only for 
> v0.90 metadata. Also it's only the super_offset field so far, other fields like 
> magic are correct.

There are patches in this side to correctly handle endian:

1345921393ba md: fix incorrect use of lexx_to_cpu in does_sb_need_changing
3fb632e40d76 md: fix super_offset endianness in super_1_rdev_size_change

probably we should make these into -stable tree, but I never got reports on
this side. can you try?

Thanks,
Shaohua
