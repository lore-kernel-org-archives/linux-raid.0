From: Maurice Hilarius <maurice@harddata.com>
Subject: Re: Strange Kernel Problem
Date: Fri, 30 May 2003 16:01:12 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <5.1.1.6.2.20030530155636.09037a50@mail.harddata.com>
References: <5.1.1.6.2.20030528210447.04056b20@mail.harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5.1.1.6.2.20030528210447.04056b20@mail.harddata.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

With regards to your message at 09:05 PM 5/28/03, Maurice Hilarius. Where 
you stated:
>Does anyone recognize what is happening here?


Answering my own question:
The machine was built with Red Hat 9.0
At build time it was installed with CURRENT Red Hat kernel 2.4.20-13.9
Then the RAID1 and RAID5 arrays were built with mdadm

My customer decided to re-install Red Hat 9.0, from CD's, but neglected to 
install the current kernel RPM updates on to his new server.

It seems that some important md patches have been incorporated into the 
newer kernel.
With the new kernel installed it now behaves correctly.

A bit of regression testing reveals that these md devices built with the 
older kernel and used with the older kernel work fine.
BUT: If you build them with the newer kernel, then try to run the older 
kernel "Bad Things Happen" (tm)


So, live and learn, backwards compatibility may be an issue..



With our best regards,

Maurice W. Hilarius       Telephone: 01-780-456-9771
Hard Data Ltd.               FAX:       01-780-456-9772
11060 - 166 Avenue        mailto:maurice@harddata.com
Edmonton, AB, Canada      http://www.harddata.com/
    T5X 1Y3

