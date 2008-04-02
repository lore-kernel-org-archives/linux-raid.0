From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: performance problems with raid10,f2
Date: Wed, 2 Apr 2008 23:13:15 +0200
Message-ID: <20080402211315.GA7899@rap.rap.dk>
References: <20080314231151.GA14568@rap.rap.dk> <20080320172817.GA27070@rap.rap.dk> <18408.35320.92714.891870@notabene.brown> <20080325103656.GA4911@rap.rap.dk> <18408.64635.201923.65782@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18408.64635.201923.65782@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg_lxra@lxra.for.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Mar 25, 2008 at 01:22:03PM +0000, Peter Grandi wrote:
> >>>> I have a 4 drive array with 1 TB Hitachi disks, formatted
> >>>> as raid10,f2 I had some strange observations: 1. while
> >>>> resyncing I could get the raid to give me about 320 MB/s in
> >>>> sequential read, which was good. After resync had been
> >>>> done, and with all 4 drives active, I only get 115 MB/s.
> 
> [ ... ]
> 
> >> Is this with, or without, your patch to avoid "read-balancing"
> >> for raid10/far layouts?  It sounds like it is without that
> >> patch ????
> 
> > I tried both without the patch and with the patch, with almost
> > same resulte.
> 
> That could be the usual issue with apparent pauses in the stream
> of IO requests to the array component devices, with the usual
> workaround of trying 'blockdev --setra 65536 /dev/mdN' and see if
> sequential reads improve.

Yes, that did it! 

> > Is resync building some table, and could that be it?  Or could
> > it be some time of inode traffic?
> 
> One good way to see what is actually happening is to use either
> 'watch iostat -k 1 2' and look at the load on the individual MD
> array component devices, or use 'sysctl vm/block_dump=1' and look
> at the addresses being read or written.

Good advice. I added your info to the wiki.

best regards
keld
