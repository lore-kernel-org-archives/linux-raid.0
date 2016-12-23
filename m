From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: Raid5 performance issue
Date: Fri, 23 Dec 2016 19:27:20 +0000
Message-ID: <22621.31384.613162.17578@tree.ty.sabi.co.uk>
References: <"H0000071000db2da.1482500583.sx.f1-outsourcing.eu*"@MHS>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <"H0000071000db2da.1482500583.sx.f1-outsourcing.eu*"@MHS>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> I have grown a raid5 over the years with drives and resized
> partitions, now I have upgraded to centos7 (from centos5). And
> I have the impression the speed is not what it used to be.

Yes. Speed most likely has dropped a lot, while performance has
probably stayed the same or improved. There is a large tradeoff
between flexibility and speed.

> Can this be because of some missalignment?

Plus a couple of other major reasons.

> How can this be verified?

While reading (or even worse writing) files sequentially on the
filesystem contaioned in that RAID set the 'iostat -dkzyx 1'
output will show lots of random accesses and read-modify-write.

Your only sensible option is to dump the content, recreate the
RAID set and reformat the filesystem, and reload.
