From: Maurice Hilarius <maurice@harddata.com>
Subject: Re: Real Time Mirroring of a NAS
Date: Mon, 10 Apr 2006 12:03:45 -0600
Message-ID: <443A9E01.2020300@harddata.com>
References: <44364336.7060704@aol.com> <8110058661.20060407200418@2ka.mipt.ru> <4436984A.9020803@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4436984A.9020803@aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: andy liebman <andyliebman@aol.com>
Cc: linux-raid@vger.kernel.org, klimov@2ka.mipt.ru
List-Id: linux-raid.ids

andy liebman wrote:
> ..
> Thanks for your reply, and the suggestions of others. I'm going to
> look into both NBD and DRBD.
>
> Actually, I see that my idea to export an iSCSI target from Server B,
> mount it on A, and just create a RAID1 array with the two block
> devices must be very similar to what DRBD is doing, but my guess is
> that DRBD, with it's "heartbeat" signal, is probably more robust at
> error handling. I'd love to hear from somebody who has experience with
> DRBD.
>
> By the way, I use 3ware 9550SX cards. On a 16 drive RAID-5 SATA array,
> I can get sequential reads that top 600 MBs/sec. That's megabytes, not
> megabits. And write speeds are close to 400 MB/sec with the new faster
> on-board XOR processing. And random reads are at least 200 MB/sec. So,
> 10 GbE is a must, really.
>
> Andy
>
Hi Andy.

A couple of other suggestions that may prove helpful:

1) EVMS
http://evms.sourceforge.net/


2) Lustre
http://www.clusterfs.com/
http://www.lustre.org/



-- 

With our best regards,


Maurice W. Hilarius        Telephone: 01-780-456-9771
Hard Data Ltd.  FAX:       01-780-456-9772
11060 - 166 Avenue         email:maurice@harddata.com
Edmonton, AB, Canada       http://www.harddata.com/
   T5X 1Y3

