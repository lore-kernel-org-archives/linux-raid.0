From: Maurice Hilarius <maurice@harddata.com>
Subject: Re: how to which to bigger disk (md can do it?)
Date: Sun, 16 Nov 2003 10:38:53 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <6.0.0.22.2.20031116103534.03dd9350@mail.harddata.com>
References: <3FB75992.3020608@bnap.hu>
 <20031116133137.GF25876@hvs.envisage.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20031116133137.GF25876@hvs.envisage.co.za>
References: <3FB75992.3020608@bnap.hu>
 <20031116133137.GF25876@hvs.envisage.co.za>
To: Hendrik Visage <hvisage@envisage.co.za>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

With regards to your message at 06:31 AM 11/16/03, Hendrik Visage. Where 
you stated:
>On Sun, Nov 16, 2003 at 12:03:46PM +0100, Farkas Levente wrote:
> > hi,
> > we've got a server with 3ware 7500-8 and 8 pieces of 120 GB maxtor hd
> > and software raid-5. the 1TB disk is running out of the space so we
>
>Are you sure about the Software RAID on this 3ware adapater?? I was
>under the impression it's a HW Raid adapter?
>(I have a preference to HW RAID if available...)
The 3Ware is a very good hardware RAID device.
That is irrelevant in this context.
One of the many advantages of  software RAID is the ability to use multiple 
controllers in separate PCI slots ( and in many cases on multiple PCI 
buses) to accomplish much better throughput and I/O rates.
I could perhaps agree with your preference for HWare RAID IF:
1) It could be spanned over multiple controllers
2) It could allow one to create non-RAID boot partitions on the disks used.
3) It could compete for RAID5 performance with software RAID on a modern 
machine.



With our best regards,

Maurice W. Hilarius       Telephone: 01-780-456-9771
Hard Data Ltd.               FAX:       01-780-456-9772
11060 - 166 Avenue        mailto:maurice@harddata.com
Edmonton, AB, Canada      http://www.harddata.com/
    T5X 1Y3

