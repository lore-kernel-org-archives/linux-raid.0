From: "Rechenberg, Andrew" <ARechenberg@shermanfinancialgroup.com>
Subject: RE: Single md physical device limit
Date: Tue, 20 Aug 2002 09:45:22 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <CDF05CB9FCA0C845B9778F9E463C4761255544@cinshrexc01.shermfin.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Class: urn:content-classes:message
To: Maurice Hilarius <maurice@harddata.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Can I just download the SRC RPM from 7.3 and build and install the
binary RPM with the libs, etc. in Red Hat 7.1 and get the intended
functionality or do most people recommend mdadm in place of raidtools?
We currently have to run Red Hat 7.1 because of the database
requirements for an application we are running on the box and cannot
upgrade to 7.3 as of now.

Thanks again to everyone for their help.

Regards,
Andy.

-----Original Message-----
From: Maurice Hilarius [mailto:maurice@harddata.com] 
Sent: Monday, August 19, 2002 8:53 PM
To: linux-raid@vger.kernel.org
Cc: Rechenberg, Andrew
Subject: RE: Single md physical device limit


With regards to your message at 03:01 PM 8/19/02, Neil Brown. Where you
stated:
>On Monday August 19, ARechenberg@shermanfinancialgroup.com wrote:
> > Interesting, when I initially built my array (with RedHat
raidtools-0.90
> > not mdctl/mdadm, on kernel 2.4.17) it stated that I could only
stripe
> > across 12 devices.  Do you have any idea from which this number
comes?
> > Is it an old limit?
>
>Yes, some old limit.  I don't remember the exact details, they were
>never important to me, but I think it involved some miscalculation
>about how many entries would actually fit in the 4096 byte superblock.


As shipped in Red Hat 7.2 and earlier that limit existed.
It was fixed in 7.3
If you need a copy of the srpm or rpm with the patches applied let me
know.
If you are using Disk Druid from 7.2 or earlier, you will need to update

that as well, as it does not recognize the fix.



With our best regards,

Maurice W. Hilarius       Telephone: 01-780-456-9771
Hard Data Ltd.               FAX:       01-780-456-9772
11060 - 166 Avenue        mailto:maurice@harddata.com
Edmonton, AB, Canada      http://www.harddata.com/
    T5X 1Y3

2.3TB RAID5 NAS server - dual AthlonMP CPU, Linux, $10,995 CAD / $6850
USD

