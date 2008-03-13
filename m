From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Useful benchmarking tools for RAID
Date: Fri, 14 Mar 2008 10:17:43 +1300
Message-ID: <47D999F7.3020608@sauce.co.nz>
References: <1205360878.30451.134.camel@atlantis.cc.ndsu.nodak.edu> <18393.37268.150207.688089@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18393.37268.150207.688089@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Peter Grandi wrote:

> for example. XFS also has the advantages that it supports write
> barriers (but not sure if the one in 2.6.18 already does), so you
> could probably enable the host adapter cache, and that it handles
> well very parallel access patterns. It has the disadvantage that
> it can require several GB of memory to 'fsck' (like 1GB per 1TB
> of filesystem, or more), and does not work as well with lots of
> small files (while ReiserFS is very good, and JFS not too bad).

This no longer need be the case, (xfs_repair memory usage).

Improvements were made in xfs_repair 2.9.2 and later - quoting one of
the develpoers:

"Right now, I can repair a 9TB filesystem with ~150 million inodes
in 2GB of RAM without going to swap using xfs_repair 2.9.4 and
with no custom/tuning/config options."

Regards,

Richard

