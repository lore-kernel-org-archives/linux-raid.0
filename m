From: Roberto Fichera <kernel@tekno-soft.it>
Subject: Re: non-optimal RAID 5 performance with 8 drive array
Date: Tue, 01 Mar 2005 19:04:21 +0100
Message-ID: <6.2.1.2.2.20050301190313.053f5d60@mail.tekno-soft.it>
References: <42246D1F.3070407@variant.ch>
 <d029u5$65p$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
In-Reply-To: <d029u5$65p$1@sea.gmane.org>
References: <42246D1F.3070407@variant.ch>
 <d029u5$65p$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Bowes <robin-lists@robinbowes.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

At 18.53 01/03/2005, Robin Bowes wrote:
>Nicola Fankhauser wrote:
>>see [3] for a description of what I did and more details.
>
>Hi Nicola,
>
>I read your description with interest.
>
>I thought I'd try some speed tests myself but dd doesn't seem to work the 
>same for me (on FC3). Here's what I get:
>
>[root@dude test]# dd if=/dev/zero of=/home/test/test.tmp bs=4096 count=100000
>100000+0 records in
>100000+0 records out
>
>Notice there is no timing information.
>
>For the read test:
>
>[root@dude test]# dd of=/dev/null if=/home/test/test.tmp bs=4096
>100000+0 records in
>100000+0 records out
>
>Again, no timing information.
>
>Anyone know if this is a quirk of the FC3 version of dd?

you have to use:

time dd if=/dev/zero of=/home/test/test.tmp bs=4096 count=100000


>R.
>--
>http://robinbowes.com
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

Roberto Fichera. 

