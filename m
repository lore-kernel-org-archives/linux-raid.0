From: Roberto Fichera <kernel@tekno-soft.it>
Subject: Re: non-optimal RAID 5 performance with 8 drive array
Date: Tue, 01 Mar 2005 19:41:15 +0100
Message-ID: <6.2.1.2.2.20050301193656.05fb3720@mail.tekno-soft.it>
References: <42246D1F.3070407@variant.ch>
 <d029u5$65p$1@sea.gmane.org>
 <6.2.1.2.2.20050301190313.053f5d60@mail.tekno-soft.it>
 <d02b09$9ud$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
In-Reply-To: <d02b09$9ud$1@sea.gmane.org>
References: <42246D1F.3070407@variant.ch>
 <d029u5$65p$1@sea.gmane.org>
 <6.2.1.2.2.20050301190313.053f5d60@mail.tekno-soft.it>
 <d02b09$9ud$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Bowes <robin-lists@robinbowes.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

At 19.12 01/03/2005, Robin Bowes wrote:
>Roberto Fichera wrote:
>>At 18.53 01/03/2005, Robin Bowes wrote:
>>>[root@dude test]# dd if=/dev/zero of=/home/test/test.tmp bs=4096 
>>>count=100000
>>>100000+0 records in
>>>100000+0 records out
>>>
>>>Notice there is no timing information.
>>you have to use:
>>time dd if=/dev/zero of=/home/test/test.tmp bs=4096 count=100000
>
>Robert,
>
>That's not what I meant - I know I can use "time" to get CPU usage 
>information.
>
>I was meaning that I don't get the disk speed summary like Nicola did, e.g.:
>
>me@beast:$ dd if=/dev/zero of=/storagearray/test.tmp bs=4096
>1238865+0 records in
>1238864+0 records out
>5074386944 bytes transferred in 63.475536 seconds (79942404 bytes/sec)

Opss!!! Sorry! May be some recent coreutils have this nice feature :-)!


>R.
>--
>http://robinbowes.com
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

Roberto Fichera. 

