From: Maurice Hilarius <maurice@harddata.com>
Subject: Re: SCSI - help
Date: Mon, 24 Mar 2003 10:21:58 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <5.1.1.6.2.20030324102010.06da31a0@mail.harddata.com>
References: <20030324102233.3c0978bf.skowalsk@us.edu.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20030324102233.3c0978bf.skowalsk@us.edu.pl>
To: Seweryn Kowalski <skowalsk@us.edu.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

With regards to your message at 02:22 AM 3/24/03, Seweryn Kowalski. Where 
you stated:
>On aic7xx I've soft raid5 (and it's o.k.) but when I try to make soft 
>raid5 on  atp870u (with 9 disk) this process crash, tranfser goes down and 
>in my log file I've:
>
>Mar  5 08:20:19  kernel: scsi : aborting command due to timeout : pid 
>46081, scsi1, channel 0, id 11, lun 0 Read (10) 00 00 15 89 67 00 00 f8 00
>Mar  5 08:20:19  kernel:  r3b=20
>Mar  5 08:20:19  kernel:
>Mar  5 08:20:19  kernel:  que 
>cdb=  28   0   0  15  88  6f   0   0  f8   0  last_lenu= 1f000
>Mar  5 08:20:19  kernel:  que 
>cdb=  28   0   0  15  89  67   0   0  f8   0  last_lenu= 1f000
>Mar  5 08:20:19  kernel:  que 
>cdb=  28   0   0  15  8c  4f   0   0  f8   0  last_lenu= 1f000 scsi : 
>aborting command due to timeout : pid 46082, scsi1, channel 0, id 10, lun 
>0 Read (10) 00 00 15 88 6f 00
>00 f8 00
>Where is proble?
>What I've to do?
>Thanks for help
>seweryn


In order of likelihood (IMHO):

Bad termination
Bad cabling
Bad drive(s)
SCSI Driver problem..
Lack of power ( too small or weak power supply in computer)

What "works" with one or two drives being used at a time will often fail 
when sufficiently stressed.



With our best regards,

Maurice W. Hilarius       Telephone: 01-780-456-9771
Hard Data Ltd.               FAX:       01-780-456-9772
11060 - 166 Avenue        mailto:maurice@harddata.com
Edmonton, AB, Canada      http://www.harddata.com/
    T5X 1Y3

