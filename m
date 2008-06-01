From: "David Lethe" <david@santools.com>
Subject: Re: Limits of the 965 chipset & 3 PCI-e cards/southbridge? ~774MiB/s peak for read, ~650MiB/s peak for write?
Date: Sun, 1 Jun 2008 8:52:00 -0500
Message-ID: <13c501c8c3ee$c6a31318$330ef40a@exchange.rackspace.com>
Reply-To: <David@santools.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-raid.ids



-----Original Message-----

From:  "Justin Piszcz" <jpiszcz@lucidpixels.com>
Subj:  Re: Limits of the 965 chipset & 3 PCI-e cards/southbridge? ~774MiB/s peak for read, ~650MiB/s peak for write?
Date:  Sun Jun 1, 2008 6:02 am
Size:  793 bytes
To:  "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>; "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>; "xfs@oss.sgi.com" <xfs@oss.sgi.com>

 
On Sun, 1 Jun 2008, Justin Piszcz wrote: 
 
> I have 12 enterprise-class seagate 1TiB disks on a 965 desktop board and it  
> appears I have hit the limit, if I were able to get the maximum speed of all  
> drives, ~70MiB/avg * 12 = 840MiB/s but it seems to stop aound 774 MiB/s  
> (currently running badblocks on all drives).. 
 
Small correction, they are 7200.11 Seagate Desktop Drives (ST31000340AS),  
not enterprise drives: 
 
http://www.seagate.com/ww/v/index.jsp?vgnextoid=0732f141e7f43110VgnVCM100000f5ee0a0aRCRD 
http://www.newegg.com/Product/Product.aspx?Item=N82E16822148274 
 
-- 
To unsubscribe from this list: send the line "unsubscribe linux-raid" in 
the body of a message to majordomo@vger.kernel.org 
More majordomo info at  http://vger.kernel.org/majordomo-info.html 
 


