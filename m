From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: SATA Raid0 in 2.4?
Date: Mon, 15 Mar 2004 09:35:54 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4055BF4A.3080103@pobox.com>
References: <Pine.LNX.4.58.0403150928140.21510@wormwood.cs.yorku.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.58.0403150928140.21510@wormwood.cs.yorku.ca>
To: Andrew Hogue <hogue@cs.yorku.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andrew Hogue wrote:
> Hi,
> 
> I am using a Via 8237 southbridge with serial ata support.  I noticed that
> this isn't supported in kernel 2.4 but it is in 2.6.x through libata.  I'm
> having issues with 2.6.4 with my hardware due to some strange
> incompatibility.
> 
> So, is there any way to get the via 8237 support into kernel 2.4?  Has
> anyone set up a Raid0 with this configuration?

A patch is available for 2.4...
http://www.kernel.org/pub/linux/kernel/people/jgarzik/libata/

