From: Stephen Lee <splee@plexio.com>
Subject: Re: raid 1 vs raid 0+1
Date: 29 Oct 2002 07:16:26 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1035904587.13219.304.camel@ralph.plexio.private>
References: <200210291229.g9TCTcO05488@gg.cyberlab.de>
	<20021029131453.GB24171@unthought.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20021029131453.GB24171@unthought.net>
To: Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 2002-10-29 at 05:14, Jakob Oestergaard wrote:
> On Tue, Oct 29, 2002 at 01:29:23PM +0100, Antonello Piemonte wrote:
> > the question is: for performance, is it better a raid 1 or a 
> > raid 0+1 configuration? is the above load (number of files written
> > per second) a realistic goal to attain with a SCSI based uniprocessor PIII 
> > 800MHZ with ext3 file system (this I will tackle separately, perhaps
> > will use ext2 to increase performance) and 1 Gig of RAM? 
> 
> On a dual PIII-550 with 512 MB of memory, ext3, and a RAID-0+1 (four 40G
> 7200rpm IBM IDE Deathstar disks, 64k chunk-size on the RAID-0), I get:
> 
> $ time for i in {0,1,2,3,4,5,6,7,8,9}; do mkdir $i; for j in
> {0,1,2,3,4,5,6,7,8,9}{0,1,2,3,4,5,6,7,8,9}; do dd if=/dev/zero of=$j/$i
> bs=1k count=4; done done
> 
> real    0m5.024s
> 

My systems are very different than what you describe above but here are
some data points for reference. BTW, should that not be "of=$i/$j"?  

For a Dual P3/1.4Gig with 3x10000rpm SCSI drives running software raid5
and ext3 on a 2.4.18 (Redhat 7.3 2.4.18-17.7) kernel:

real	0m2.217s

For a P3/1Gig with 2x10000rpm SCSI drive running software raid1 and ext3
on a stock 2.4.18 kernel:

real	0m3.349s

Stephen





