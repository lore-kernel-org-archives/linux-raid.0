From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Question on RAID 10 setup
Date: Wed, 25 Mar 2009 01:52:25 +0100
Message-ID: <20090325005225.GA27265@rap.rap.dk>
References: <1183FAF84E86E244938C2174EE436BAC030FBE29@NYKPCMEU306VEUA.INTRANET.BARCAPINT.COM> <3513de790903241515m2eeff929x855322a51117c45b@mail.gmail.com> <49C97161.5020207@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49C97161.5020207@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Dylan Distasio <interzone@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Mar 24, 2009 at 11:48:49PM +0000, John Robinson wrote:
> On 24/03/2009 22:15, Dylan Distasio wrote:
> >Hi all-
> >
> >I would like to put together a RAID10 array utilizing 2x1TB drives and
> >2x500 gig drives I have in my home Linux server.  Is the best way to do
> >this to create 2 separate RAID1 arrays, one for each set of drives, and
> >then a RAID0 array made up of the RAID1 ones?   I just wanted to verify
> >that I am going about this correctly, and also get input on whether
> >there are any disadvantages to this setup.  I would prefer not to split
> >these up into two separate RAID10 arrays because I want the combined
> >space available under one.   Thanks for any comments.
> 
> I think you can mix drive sizes under md RAID-10 - much as you're 
> proposing to above with your RAID-0 of different-sized RAID-1s - and md 
> will just do the Right Thing. I'd go for testing that and play with 
> layouts (near, far, offset) to suit your requirements before worrying 
> about setting up RAID 1+0.

Hmm, the raid 0 will only use the space of all partitions that is equal
to the smallest partition, that is the 500 gig drives. I think you better
then only ude 500 gig partitions on the 1 TB disks for anything that
is combined with the 500 gig disks.


> Actually with your hardware I'd probably set up a 1TB RAID-0 with the 
> 500G drives then make a RAID-5 from the 3 1TB devices (2 raw drives plus 
> one md RAID-0). If you can be bothered try benchmarking that too; as 
> well as giving you more storage I think it'll probably match the RAID-10 
> or RAID 1+0 for performance.

In my book I would consider 2 setups:

1.  a raid5 of 4 500 gig partitions, total 1,5 GB plus a raid10,f2 of
two 500 gig partitions, total  2.0 GB

2. a raid10,f2 of 4 500 gig partitions, total 1.0 GB plus a raid10,f2 of
two 500 gig partitions, total  1.5 GB.

A small comparison table with my 2 scenarios, your own suggestion
and john robisons:

                                size     perf-rd    perf-wr
4x500 raid5     + 0.5 f2        1.5+0,5    3         3
4x500 raid10,f2 + 0.5 f2        1.0+0.5    4         2
4x500 raid1+0   + 0,5 f2        1.0+0.5    2         2
2x1tb+(500+500) raid5           2.0        2         2

So based on what your prefer, like most space vs most read or write
performance, each of these configurations have something to offer.

Best regards
keld
