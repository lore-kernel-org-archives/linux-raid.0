From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: raind-1 resync speed slow down to 50% by the time it finishes
Date: Thu, 30 Jul 2009 12:18:46 +0200
Message-ID: <20090730101846.GA17332@rap.rap.dk>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C07C7D7D6@SDCEXCHANGE01.ad.amcc.com> <20090730073554.GA17665@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090730073554.GA17665@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jul 30, 2009 at 08:35:54AM +0100, Robin Hill wrote:
> On Wed Jul 29, 2009 at 11:25:47PM -0700, Tirumala Reddy Marri wrote:
> 
> > Hi,
> >   I have two 1 tera byte disks in RAID-1 configuration. When I started
> > RAID-1 array initial speed was 100MBps by the time it finishes the speed
> > was <50MBps. Is there is any reason for this behavior ? Isn't speed
> > supposedly uniform. 
> > 
> No, the speed isn't uniform - it varies across the disk.  The
> _rotational_ speed is fixed (probably 7200 rpm), but that means the
> outer tracks are passing at a higher _linear_ speed (i.e. in a single
> rotation, there's more disk passing across the read head), so have a
> higher transfer rate.  Hard drives start writing from the outside, so
> the speed drops off as you progress.

there is a raid type which can be seen as a raid1 version, but avoids
some of the  performance problems of raid1. this is rai10,f2, which
performs like raid0 for reading, and for reading only uses the faster
half of the disks, thus not degrading as much as raid1.

I think raid10,f2 only degrades 10-20 % while raid1 can degrade as much
as 50 %. For writing it is about the same, given that you use a file
system on top of the raid. 


best regards
Keld
