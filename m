From: Maurice Hilarius <maurice@harddata.com>
Subject: Re: ServerWorks chipset
Date: Mon, 26 Aug 2002 08:13:44 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <5.1.0.14.2.20020826080713.03a18390@mail.harddata.com>
References: <Pine.LNX.4.30.0208261440170.10850-100000@duplo.agenda.si>
 <Pine.LNX.4.30.0208261440170.10850-100000@duplo.agenda.si>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20020826151034.4e04e5d0.pegasus@telemach.net>
To: Jure Pecar <pegasus@telemach.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

With regards to your message at 07:10 AM 8/26/02, Jure Pecar. Where you stated:

>On Mon, 26 Aug 2002 14:45:27 +0200 (CEST)
>
>ServerWorks ide is known for its DMA brokeness. See
>http://www.uwsg.indiana.edu/hypermail/linux/kernel/0208.2/1137.html
>for reference.
>
>Personally i dont care much about ide on intel's server boards ... use scsi
>instead.

I think that is a bit strong.
Let' just say that the chip is a bit aggressive in timing, and the supplied 
cables are pretty cheap.
If one is to use decent teflon TPE cables, and be a bit selective about 
drive choices it works very well at full speed.
Look at it this way:
If you were to set up Ultra160 SCSI with cheap grey polyester cables and no 
terminator how well would it work.
Also, some of the Linux IDE driver is pretty timing sensitive.

If one wants to enjoy the cost savings and modern technology of IDE drives, 
without paying an exorbitant cost there are some very nice IDE cards out 
there that are not nearly so fussy..


With our best regards,

Maurice W. Hilarius       Telephone: 01-780-456-9771
Hard Data Ltd.               FAX:       01-780-456-9772
11060 - 166 Avenue        mailto:maurice@harddata.com
Edmonton, AB, Canada      http://www.harddata.com/
    T5X 1Y3

2.3TB RAID5 NAS server - dual AthlonMP CPU, Linux, $10,995 CAD / $6850 USD

