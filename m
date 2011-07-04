From: Werner Fischer <devlists@wefi.net>
Subject: Re: Software RAID and TRIM
Date: Mon, 04 Jul 2011 18:26:52 +0200
Message-ID: <1309796812.2046.13.camel@werner-t410>
References: <alpine.OSX.2.00.1106281628320.257@trogdor.csi.cam.ac.uk>
	 <BANLkTimswAVra6qnMS4g8WRzs=dhi_f7OQ@mail.gmail.com>
	 <alpine.OSX.2.00.1106291133060.257@trogdor.csi.cam.ac.uk>
	 <iuf6me$9us$1@dough.gmane.org>
	 <alpine.OSX.2.00.1106291348430.257@trogdor.csi.cam.ac.uk>
	 <alpine.DEB.2.00.1106300746460.19581@uplift.swm.pp.se>
	 <alpine.OSX.2.00.1107041011110.4557@trogdor.csi.cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.OSX.2.00.1107041011110.4557@trogdor.csi.cam.ac.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Tom De Mulder <tdm27@cam.ac.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Tom,

1) regarding Software RAID and TRIM:
there is a script raid1ext4trim.sh-1.4 from Chris Caputo that does a
TRIM for Ext4 file systems on a software RAID 1. According to the
comments in the script it only supports RAID volumes which reside on
complete disks (e.g. /dev/sdb and /dev/sdc), not on RAID partitions
(e.g. /dev/sdb1 and /dev/sdc1)
The script is shipped with hdparm, get hdparm 9.37 at
http://sourceforge.net/projects/hdparm/ and you'll find the script in
the subfolder hdparm-9.37/wiper/contrib/
I have not tested the script yet, maybe I could do some tests tomorrow

2) regarding choosing the right SSD:
I would strongly recommend a SSD with integrated power-outage
protection, Intel's 320 series has this inside:
http://newsroom.intel.com/servlet/JiveServlet/download/38-4324/Intel_SSD_320_Series_Enhance_Power_Loss_Technology_Brief.pdf
I have done some power-outage tests today, including a Vertex-3 and an
Intel 320 series. I used diskchecker.pl from
http://brad.livejournal.com/2116715.html

result:
-> for the Vertex 3 diskchecker.pl reported lost data:
        [root@f15-ocz-vertex3 ~]# ./diskchecker.pl -s 10.10.30.199 verify testfile2
         verifying: 0.00%
         verifying: 1.42%
          Error at page 52141, 0 seconds before end.
         verifying: 6.31%
          Error at page 83344, 0 seconds before end.
         verifying: 11.12%
          Error at page 163555, 0 seconds before end.
        [...]
        Total errors: 12
        Histogram of seconds before end:
             0   12
        [root@f15-ocz-vertex3 ~]# 
-> for the Intel 320 Series diskchecker.pl did not report data loss:
        [root@f15-intel-320 ~]# ./diskchecker.pl -s 10.10.30.199 verify
        testfile2 
         verifying: 0.00%
         verifying: 0.12%
         [...]
         verifying: 99.82%
         verifying: 100.00%
        Total errors: 0
        [root@f15-intel-320 ~]# 
I did the tests multiple times, I had also some runs on the Vertex 3
without errors, but with the Intel 320 Series no single test reported an
error.

I did the tests with fedora 15 on the SSDs, here are the details of
hdparm -I

OCZ Vertex 3:
	Model Number:       OCZ-VERTEX3                             
	Serial Number:      OCZ-OQZF2I45DYZ47T3C
	Firmware Revision:  2.06
	Transport:          Serial, ATA8-AST, SATA 1.0a, SATA II Extensions, SATA Rev 2.5, SATA Rev 2.6, SATA Rev 3.0
	[...]
	device size with M = 1000*1000:      120034 MBytes (120 GB)

Intel 320 Series:
	Model Number:       INTEL SSDSA2CW160G3                     
	Serial Number:      CVPR112601AL160DGN  
	Firmware Revision:  4PC10302
	Transport:          Serial, ATA8-AST, SATA 1.0a, SATA II Extensions, SATA Rev 2.5, SATA Rev 2.6
	[...]
	device size with M = 1000*1000:      160041 MBytes (160 GB)

Regards,
Werner

On Mon, 2011-07-04 at 10:13 +0100, Tom De Mulder wrote:
> On Thu, 30 Jun 2011, Mikael Abrahamsson wrote:
> 
> > From the tests I have read, the Intel 510 are actually worse than the Intel 
> > X-25 G1/G2/320 models, with exactly the symptoms you're describing. It's fast 
> > for linear reads and writes, but not so good for random writes, especially not 
> > when it's getting full.
> 
> Yes; that's why I'm looking forward to also getting some SandForce 22xx 
> based drives (probably OCZ Vertex 3) to test.
> 
> > Include the Intel 320 as well, I think it should be viable for your usage 
> > pattern.
> 
> I wasn't too impressed by the Anandtech review of the 320, and (as 
> everywhere) my funds are limited. :-)
> 
> 
> --
> Tom De Mulder <tdm27@cam.ac.uk> - Cambridge University Computing Service
> +44 1223 3 31843 - New Museums Site, Pembroke Street, Cambridge CB2 3QH
> -> 04/07/2011 : The Moon is Waxing Crescent (17% of Full)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


