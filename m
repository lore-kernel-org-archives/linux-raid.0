From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Limits of the 965 chipset & 3 PCI-e cards/southbridge? ~774MiB/s
 peak for read, ~650MiB/s peak for write?
Date: Sun, 1 Jun 2008 07:01:09 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0806010700170.10729@p34.internal.lan>
References: <alpine.DEB.1.10.0806010539430.24757@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0806010539430.24757@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-raid.ids


On Sun, 1 Jun 2008, Justin Piszcz wrote:

> I have 12 enterprise-class seagate 1TiB disks on a 965 desktop board and it 
> appears I have hit the limit, if I were able to get the maximum speed of all 
> drives, ~70MiB/avg * 12 = 840MiB/s but it seems to stop aound 774 MiB/s 
> (currently running badblocks on all drives)..

Small correction, they are 7200.11 Seagate Desktop Drives (ST31000340AS), 
not enterprise drives:

http://www.seagate.com/ww/v/index.jsp?vgnextoid=0732f141e7f43110VgnVCM100000f5ee0a0aRCRD
http://www.newegg.com/Product/Product.aspx?Item=N82E16822148274

