From: Alberto Alonso <alberto@ggsys.net>
Subject: Re: Software RAID when it works and when it doesn't
Date: Sun, 14 Oct 2007 13:22:17 -0500
Message-ID: <1192386137.16416.313.camel@w100>
References: <1192300851.16416.265.camel@w100>  <471241F8.50205@harddata.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <471241F8.50205@harddata.com>
Sender: linux-raid-owner@vger.kernel.org
To: Maurice Hilarius <maurice@harddata.com>
Cc: vger majordomo for lists <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, 2007-10-14 at 10:21 -0600, Maurice Hilarius wrote:
> Alberto Alonso wrote: 
> >   
> PATA (IDE) with 
> Master and Slave drives is a "bad idea" as, when one drive fails, the
> other of the Master & Slave pair often is no longer usable.
> On discrete interfaces, with all drives configured as Master (single)
>  it is more tolerant.

Before SATA became the de-facto we used promise PCI boards on top
of the built in channels. As you mentioned, a single drive per
channel is a must. We only had small servers with up to 6 PATA
drives.

This was proved to be really reliable and handled all disk failures
without bringing the servers down.

What I am trying to determine in these posts is a combination of
hardware and software that will make software RAID a reliable solution
when disks fail.

> -- 
> With our best regards,
> 
> Maurice W. Hilarius         Telephone: 01-780-456-9771
> Hard Data Ltd.                FAX:          01-780-456-9772
> 11060 - 166 Avenue         email:maurice@harddata.com
> Edmonton, AB, Canada         http://www.harddata.com/
>      T5X 1Y3
> 


Thanks,

Alberto

