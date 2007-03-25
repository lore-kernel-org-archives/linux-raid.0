From: dean gaudet <dean@arctic.org>
Subject: Re: XFS sunit/swidth for raid10
Date: Sun, 25 Mar 2007 12:16:20 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0703251214460.30863@twinlark.arctic.org>
References: <4601BE85.8050005@rabbit.us> <Pine.LNX.4.64.0703220108270.13419@twinlark.arctic.org>
 <460270F4.1080604@rabbit.us> <Pine.LNX.4.64.0703222347450.9269@twinlark.arctic.org>
 <46038DD0.1060803@rabbit.us>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46038DD0.1060803@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit@rabbit.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 23 Mar 2007, Peter Rabbitson wrote:

> dean gaudet wrote:
> > On Thu, 22 Mar 2007, Peter Rabbitson wrote:
> > 
> > > dean gaudet wrote:
> > > > On Thu, 22 Mar 2007, Peter Rabbitson wrote:
> > > > 
> > > > > Hi,
> > > > > How does one determine the XFS sunit and swidth sizes for a software
> > > > > raid10
> > > > > with 3 copies?
> > > > mkfs.xfs uses the GET_ARRAY_INFO ioctl to get the data it needs from
> > > > software raid and select an appropriate sunit/swidth...
> > > > 
> > > > although i'm not sure i agree entirely with its choice for raid10:
> > > So do I, especially as it makes no checks for the amount of copies (3 in
> > > my
> > > case, not 2).
> > > 
> > > > it probably doesn't matter.
> > > This was essentially my question. For an array -pf3 -c1024 I get swidth =
> > > 4 *
> > > sunit = 4MiB. Is it about right and does it matter at all?
> > 
> > how many drives?
> > 
> 
> Sorry. 4 drives, 3 far copies (so any 2 drives can fail), 1M chunk.

my mind continues to be blown by linux raid10.

so that's like raid1 on 4 disks except the copies are offset by 1/4th of 
the disk?

i think swidth = 4*sunit is the right config then -- 'cause a read of 4MiB 
will stride all 4 disks...

-dean
