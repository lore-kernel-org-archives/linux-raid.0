From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Is this expected RAID10 performance?
Date: Fri, 07 Jun 2013 07:39:40 -0500
Message-ID: <51B1D48C.7050006@hardwarefreak.com>
References: <CAO9HMNH4eFyshhhohw0wQ13j98BTRELTiWF9uDLp3vmFsOEfwQ@mail.gmail.com> <CAAMCDefb7TFXDOD7=aK-FjHVCQXMdiQKdz=CFJT4+q9rKR3KGA@mail.gmail.com> <CAGqvA+svdBvWTbwnzQjoHWQz6n0iEaAZzmu-EqKqdPx-AK0Zkg@mail.gmail.com> <CAO9HMNE3F-ZN0fQmHW7yz2JLRFaUqSYSaVpZe3KaXuaLMojV8w@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAO9HMNE3F-ZN0fQmHW7yz2JLRFaUqSYSaVpZe3KaXuaLMojV8w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Bergman <sbergman27@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 6/7/2013 5:44 AM, Steve Bergman wrote:
> Stan, Roger, Alexander,
> 
> Thanks for the helpful posts. After posting, I decided to study up a
> bit on what SATA 3Gb/s actually means. It turns out that the 3Gbit/s
> bandwidth is aggregate per controller. 

I don't know what you read but it was unequivocally wrong.  SATA
specifies interface bandwidth per cable connection, i.e. per interface.
 A 4 port 3G SATA controller has aggregate one way SATA interface b/w of
12Gb/s. If you have a throughput limitation it would be the bus (slot)
connection.

> This is a 4-port SATA
> controller, so with 1 drive, the single drive gets all 3Gbit/s. With 4
> operating simultaneously, each would get 750Mbit/s. There is supposed
> to be about a 20% overhead involved in the SATA internals, so that
> number drops to ~600Mbit/s. This is 75MByte/s, which is about what I'm
> seeing on writes. For reads, I would expect to see ~300MBytes/s, and
> am seeing 260MBytes/s, which is not too far off.

What you're seeing is a limitation of either a PCIe 1.0 x1 bus
connection, 250MB/s, or a 66MHz/32bit or 33MHz/64bit PCI/-x slot,
264MB/s.  You didn't mention the bus type.  Gotta be one of these three
given your data.

> This is not really a problem for me, as the workloads I'm concerned
> about are seekier than this, and are not bandwidth limited....

Until you have to perform a rebuild or some other b/w intensive
operation.  Then having full b/w per drive comes in handy.

> BTW Stan, for ext4 stride and stripe-width are specified in filesystem
> blocks rather than in K. In this case, I'm using the default 4k block
> size....

This is what happens when XFS people try to help folks using inferior
filesystems. ;)  Yes, you're absolutely correct.  I should have read
mke2fs(8) before responding.  You can blame Ted et al for stealing XFS
concepts and then changing the names and value quantities (out of guilt
I guess).  FYI, in modern XFS, bytes are used for stripe unit/width
values.  The whole point of alignment is matching RAID geometry.  RAID
geometry is in bytes, not fs block size multiples.  Which is exactly why
XFS moved away from this arcane system many years ago.

If your workload has any parallelism, reformat that sucker with XFS with
the defaults.  You'll get better random IOPS performance that with EXT4,
and without alignment.  Many folks don't realize that with some
workloads alignment is actually detrimental to performance, especially
with small file workloads.

-- 
Stan

