From: Neil Brown <neilb@suse.de>
Subject: Re: striping of a 4 drive raid10
Date: Mon, 28 Jan 2008 08:57:18 +1100
Message-ID: <18332.65086.285198.477921@notabene.brown>
References: <20080127193345.GA5426@rap.rap.dk>
	<18332.58858.191866.347099@notabene.brown>
	<20080127204841.GA10112@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Keld Jorn Simonsen on Sunday January 27
Sender: linux-raid-owner@vger.kernel.org
To: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday January 27, keld@dkuug.dk wrote:
> On Mon, Jan 28, 2008 at 07:13:30AM +1100, Neil Brown wrote:
> > On Sunday January 27, keld@dkuug.dk wrote:
> > > Hi
> > > 
> > > I have tried to make a striping raid out of my new 4 x 1 TB
> > > SATA-2 disks. I tried raid10,f2 in several ways:
> > > 
> > > 1: md0 = raid10,f2 of sda1+sdb1, md1= raid10,f2 of sdc1+sdd1, md2 = raid0
> > > of md0+md1
> > > 
> > > 2: md0 = raid0 of sda1+sdb1, md1= raid0 of sdc1+sdd1, md2 = raid01,f2
> > > of md0+md1
> > > 
> > > 3: md0 = raid10,f2 of sda1+sdb1, md1= raid10,f2 of sdc1+sdd1, chunksize of 
> > > md0 =md1 =128 KB,  md2 = raid0 of md0+md1 chunksize = 256 KB
> > > 
> > > 4: md0 = raid0 of sda1+sdb1, md1= raid0 of sdc1+sdd1, chunksize
> > > of md0 = md1 = 128 KB, md2 = raid01,f2 of md0+md1 chunksize = 256 KB
> > > 
> > > 5: md0= raid10,f4 of sda1+sdb1+sdc1+sdd1
> > 
> > Try
> >   6: md0 = raid10,f2 of sda1+sdb1+sdc1+sdd1
> 
> That I already tried, (and I wrongly stated that I used f4 in stead of
> f2). I had two times a thruput of about 300 MB/s but since then I could
> not reproduce the behaviour. Are there errors on this that has been
> corrected in newer kernels?

No, I don't think any performance related changes have been made to
raid10 lately.

You could try increasing the read-ahead size.  For a 4-drive raid10 it
defaults to 4 times the read-ahead setting of a single drive, but
increasing substantially (e.g. 64 times) seem to increase the speed of
"dd" reading a gigabyte.
Whether that will actually affect your target workload is a different question.

> 
> 
> > Also try raid10,o2 with a largeish chunksize (256KB is probably big
> > enough).
> 
> I tried that too, but my mdadm did not allow me to use the o flag.
> 
> My kernel is 2.6.12  and mdadm is v1.12.0 - 14 June 2005.
> can I upgrade the mdadm alone to a newer version, and then which is
> recommendable?

You would need a newer kernel and a newer mdadm to get raid10 - offset
mode.

NeilBrown
