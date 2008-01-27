From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: striping of a 4 drive raid10
Date: Sun, 27 Jan 2008 21:48:41 +0100
Message-ID: <20080127204841.GA10112@rap.rap.dk>
References: <20080127193345.GA5426@rap.rap.dk> <18332.58858.191866.347099@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18332.58858.191866.347099@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jan 28, 2008 at 07:13:30AM +1100, Neil Brown wrote:
> On Sunday January 27, keld@dkuug.dk wrote:
> > Hi
> > 
> > I have tried to make a striping raid out of my new 4 x 1 TB
> > SATA-2 disks. I tried raid10,f2 in several ways:
> > 
> > 1: md0 = raid10,f2 of sda1+sdb1, md1= raid10,f2 of sdc1+sdd1, md2 = raid0
> > of md0+md1
> > 
> > 2: md0 = raid0 of sda1+sdb1, md1= raid0 of sdc1+sdd1, md2 = raid01,f2
> > of md0+md1
> > 
> > 3: md0 = raid10,f2 of sda1+sdb1, md1= raid10,f2 of sdc1+sdd1, chunksize of 
> > md0 =md1 =128 KB,  md2 = raid0 of md0+md1 chunksize = 256 KB
> > 
> > 4: md0 = raid0 of sda1+sdb1, md1= raid0 of sdc1+sdd1, chunksize
> > of md0 = md1 = 128 KB, md2 = raid01,f2 of md0+md1 chunksize = 256 KB
> > 
> > 5: md0= raid10,f4 of sda1+sdb1+sdc1+sdd1
> 
> Try
>   6: md0 = raid10,f2 of sda1+sdb1+sdc1+sdd1

That I already tried, (and I wrongly stated that I used f4 in stead of
f2). I had two times a thruput of about 300 MB/s but since then I could
not reproduce the behaviour. Are there errors on this that has been
corrected in newer kernels?


> Also try raid10,o2 with a largeish chunksize (256KB is probably big
> enough).

I tried that too, but my mdadm did not allow me to use the o flag.

My kernel is 2.6.12  and mdadm is v1.12.0 - 14 June 2005.
can I upgrade the mdadm alone to a newer version, and then which is
recommendable?

best regards
keld
