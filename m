From: Stephen Lee <splee@plexio.com>
Subject: Re: raid 1 vs raid 0+1
Date: 29 Oct 2002 08:16:06 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1035908166.6345.311.camel@ralph.plexio.private>
References: <200210291229.g9TCTcO05488@gg.cyberlab.de>
	<20021029131453.GB24171@unthought.net>
	<1035904587.13219.304.camel@ralph.plexio.private>
	<20021029153930.GA21099@smeagol>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20021029153930.GA21099@smeagol>
To: Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 2002-10-29 at 07:39, Adam Luter wrote:
> On Tue, Oct 29, 2002 at 07:16:26AM -0800, Stephen Lee wrote:
> Of course alternate conclusions are that my raid-5 array suffers from
> using two channels per drive (I know -- but when I put two promise
> cards they or linux has DMA problems) and that I'm still behind the
> pack when you throw 10krpm at me :) (2.2 seconds is nice!).

It's around 2.0 seconds if I direct stdout to /dev/null ;-)

I also have a system using a Promise raid controller with 2x7200rpm ide
drives in a raid1 configuration (AMD K7 1.4Gig, ext2, RH 2.4.2 kernel,
Promises proprietary driver) and the same test produced a speed of 2.6
seconds. 

Stephen


