From: Maurice Hilarius <maurice@harddata.com>
Subject: RE: Single md physical device limit
Date: Mon, 19 Aug 2002 18:53:15 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <5.1.0.14.2.20020819185116.04655a70@mail.harddata.com>
References: <message from Rechenberg, Andrew on Monday August 19>
 <CDF05CB9FCA0C845B9778F9E463C476101FC63@cinshrexc01.shermfin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15713.23702.808856.809290@notabene.cse.unsw.edu.au>
To: linux-raid@vger.kernel.org
Cc: "Rechenberg, Andrew" <ARechenberg@shermanfinancialgroup.com>
List-Id: linux-raid.ids

With regards to your message at 03:01 PM 8/19/02, Neil Brown. Where you stated:
>On Monday August 19, ARechenberg@shermanfinancialgroup.com wrote:
> > Interesting, when I initially built my array (with RedHat raidtools-0.90
> > not mdctl/mdadm, on kernel 2.4.17) it stated that I could only stripe
> > across 12 devices.  Do you have any idea from which this number comes?
> > Is it an old limit?
>
>Yes, some old limit.  I don't remember the exact details, they were
>never important to me, but I think it involved some miscalculation
>about how many entries would actually fit in the 4096 byte superblock.


As shipped in Red Hat 7.2 and earlier that limit existed.
It was fixed in 7.3
If you need a copy of the srpm or rpm with the patches applied let me know.
If you are using Disk Druid from 7.2 or earlier, you will need to update 
that as well, as it does not recognize the fix.



With our best regards,

Maurice W. Hilarius       Telephone: 01-780-456-9771
Hard Data Ltd.               FAX:       01-780-456-9772
11060 - 166 Avenue        mailto:maurice@harddata.com
Edmonton, AB, Canada      http://www.harddata.com/
    T5X 1Y3

2.3TB RAID5 NAS server - dual AthlonMP CPU, Linux, $10,995 CAD / $6850 USD

