From: Mathias Mueller <raidfail@gmx.de>
Subject: Re: broken raid level 5 array caused by user error
Date: Mon, 18 Jan 2016 16:33:00 +0100
Message-ID: <44d28ec402622b25c4d4d7a32a8888d9@pingofdeath.de>
References: <3c05d813e42324cdf95989784f6d7b17@pingofdeath.de>
 <56426499.8000205@turmel.org>
 <ceee2de5aba3ca77efc1146e19896b90@pingofdeath.de>
 <564284F5.9080409@turmel.org>
 <b0cdddd4394bbc1356980bb61ac199c3@pingofdeath.de>
 <56429326.5030405@turmel.org>
 <a7d58e8e4c319c320bc531b8d2bf11e7@pingofdeath.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a7d58e8e4c319c320bc531b8d2bf11e7@pingofdeath.de>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Linux raid <linux-raid@vger.kernel.org>, linux-raid-owner@vger.kernel.org
List-Id: linux-raid.ids

Hi Phil,

first thanks a lot for all your help and time you already spent on me 
and my problem. I gathered some more information and hope you can help 
me a bit more.

I found this on serverfault.com and tried to figure out my raid layout 
using some image file that is stored on my raid for sure:
http://serverfault.com/questions/347606/recover-raid-5-data-after-created-new-array-instead-of-re-using

this is my current device mapping:

JK1100YAG64A1T -> sdc
ML0220F30PZUVD -> sdd (this is the disk I added last)
JK1121YAG7YDLS -> sde
JK1170YBHYV6MD -> sdf


First I  tried to figure out the chunk size. I used a jpg file that was 
stored on the raid for sure and read 8x32 Bytes with an offset of 64k 
from that file. Than I used bgrep to search for the bytestrings on my 
physical devices. I found five sequent byte strings on one physical 
device, so I think the chunk sice must be bigger than 256k.

Because I was pretty sure, that my chunk size is 512k, I was reading 
5x32Byte with an offset of 512k from my jpg file, to determine the order 
of the devices. After bgrep was done, I got the following results:

- Every bytestring was found 3x on my physical devices, I think it's 
because the file is existing 3x in different folders on my raid device 
(which is pretty certain, I know that the file is existing 2x at least)
- sdd1 seems to have a different offset as the other physical devices, 
it's the disk I added last after switching from debian to centos some 
years ago
- the following tables show at which offsets and on which physical 
devices the five byte strings have been found:


offset          sdc1      sdd1      sde1      sdf1
---------------------------------------------------
5400bd3000                 2
5400cc3000                           3         1
5400d43000       4                             5



offset          sdc1      sdd1      sde1      sdf1
---------------------------------------------------
87b4e52000                 3
87b4f42000       1                             2
87b4fc2000       5                   4



offset          sdc1      sdd1      sde1      sdf1
---------------------------------------------------
cb2d87f000                 2
cb2d96f000                                     1
cb2d9ef000       4                   3         5




So I think using the last table is the easiest one to figure out the 
partition order and the data offset between sdd1 and the other devices?


offset          sdc1      sdd1      sde1      sdf1
---------------------------------------------------
cb2d96f000                (2)        P         1
cb2d9ef000       4         P         3         5

If I am right, it would mean, that the order of my physical devices is 
sdf1 sdd1 sde1 sdc1 (without knowing which one is the first partition) 
and the offset between sdd1 and the other devices is f0000. Are my 
assumptions correct? How can I go on with this information?

Thanks a lot in advance

Best regards

Mathias












