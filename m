From: Luca Berra <bluca@comedia.it>
Subject: Re: Multipath problem in a SAN enviromnent
Date: Wed, 11 Jun 2003 21:24:16 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EE781E0.1020707@comedia.it>
References: <02d201c33023$13fd45a0$3351960a@EEL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <02d201c33023$13fd45a0$3351960a@EEL>
To: Ionut Nistor <ionut@modulo.ro>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ionut Nistor wrote:
> Hello,
> 
> I'm using a 2.4.18-ac3 kernel and the multipath module in order to ensure
> automatic IO path failover. The systems connect to a FC SAN environment.
> New logical disks are added/removed from the SAN periodically.
> 
> Unfortunatelly, linux's raid subsystem uses major and minor numbers in the
> superblock in order to identify members for all raid types - including
> multipath. This causes the multipath module to fail when attempting to
> identify the members. When the scsi driver is loaded, the bus is scanned and
> all the available devices/targets/luns are added to the scsi subsystem and
> are allocated a major and minor number.
> 
you mean autodetection fails? don't use autodetection.

regards,
Luca.

