From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: Deleting an raid device
Date: Tue, 25 May 2004 21:17:25 +0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0405252115280.6990@praktifix.dwd.de>
References: <002501c44257$7135dd80$6705a8c0@a30>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <002501c44257$7135dd80$6705a8c0@a30>
To: me@heyjay.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 25 May 2004 me@heyjay.com wrote:

> Hi,
> 
> What are the proper steps for deleting all remnants of a previous raid
> install?
> 
> I've done:
> mdadm --stop /dev/md0
> mdadm --zero-superblock /dev/md0
> 
> But I still see it getting stopped on shutdown.
> 
Are the partitions system id still fd (raid autodetect)?

Holger
