From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Which controller is recommended for a hardware-raid
Date: Tue, 02 Dec 2003 10:00:20 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3FCCA904.5060302@pobox.com>
References: <Pine.LNX.4.44.0312020837410.23341-100000@praktifix.dwd.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0312020837410.23341-100000@praktifix.dwd.de>
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Holger Kiehl wrote:
> On Fri, 28 Nov 2003, Jeff Garzik wrote:
> 
> 
>>There is an open source driver for the FastTrak now...
>>(assuming it's SATA not PATA)
>>
> 
> Where can I find this driver? I have an onboard Promise 378 setup as
> raid 1 with two SATA disks and with kernel 2.6.0-test9 it only sees the
> two individual drives, not the raid 1 mirror.


Right.  My driver presents only the individual drives.

In 2.4.x, you need the additional "pdcraid" driver to use Promise RAID 
0/1.  In 2.6.x, you must use md RAID to achieve RAID 0/1/5.

	Jeff



