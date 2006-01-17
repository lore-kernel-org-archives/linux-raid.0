From: Neil Brown <neilb@suse.de>
Subject: Re: blog entry on RAID limitation
Date: Wed, 18 Jan 2006 09:47:18 +1100
Message-ID: <17357.29686.842091.898632@cse.unsw.edu.au>
References: <8E5ACAE05E6B9E44A2903C693A5D4E8A097F6C86@hqemmail02.nvidia.com>
	<1137487538.309F9186@bd12.dngr.org>
	<17356.51593.481883.173707@cse.unsw.edu.au>
	<43CD1E5A.3050802@mungo.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jacob Madsen on Tuesday January 17
Sender: linux-raid-owner@vger.kernel.org
To: Jacob Madsen <jacob@mungo.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday January 17, jacob@mungo.dk wrote:
> Neil Brown wrote:
> > In general, I think increasing the connection between the filesystem
> > and the volume manager/virtual storage is a good idea.  Finding the
> > right balance is not going to be trivial.  ZFS has taken one very
> > interesting approach.  There are others.
> >   
> Just out of curiosity... When you say there are others, are you then
> refering to existing solutions or just saying other approaches will be
> developed in the future?

There was a paper given at the USENIX FAST conference
  
    http://www.cs.wisc.edu/adsl/Publications/fast05-journal-guided.pdf

which discussed modifications to ext3 so that after a crash, it would
tell the underlying raid which blocks might have been undergoing a
'write' at the time of the crash, so that raid5 could resync just
those stripes.  This reduces the resync time much more efficiently
that write-intent logging does.

I have had a project underway for some time (about half a day a week
at the moment) to create a file system which is raid-friendly.  When
configured on a raid5, it will always write a full stripe at a time,
and never over-write live data.  This means that there is no need to
pre-read parity or data, and it completely removes the "write hole".

NeilBrown

