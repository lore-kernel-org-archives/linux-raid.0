From: Phil Turmel <philip@turmel.org>
Subject: Re: broken raid level 5 array caused by user error
Date: Tue, 10 Nov 2015 18:59:49 -0500
Message-ID: <564284F5.9080409@turmel.org>
References: <3c05d813e42324cdf95989784f6d7b17@pingofdeath.de>
 <56426499.8000205@turmel.org>
 <ceee2de5aba3ca77efc1146e19896b90@pingofdeath.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ceee2de5aba3ca77efc1146e19896b90@pingofdeath.de>
Sender: linux-raid-owner@vger.kernel.org
To: Mathias Mueller <raidfail@gmx.de>
Cc: Linux raid <linux-raid@vger.kernel.org>, linux-raid-owner@vger.kernel.org
List-Id: linux-raid.ids

On 11/10/2015 06:47 PM, Mathias Mueller wrote:
> Hi Phil

> sorry, here you go:
> 
> sdb -> sde  Serial Number: JK1170YBHYV6MD
> sdc -> sdf  Serial Number: JK1100YAG64A1T
> sdd -> sdg  Serial Number: JK1121YAG7YDLS
> sde -> sdh  Serial Number: ML0220F30PZUVD
> 
> 
>> We know the possible order combinations:
>>  sdc1 sdb1 sdd1 sde1
>>  sdc1 sdd1 sdb1 sde1
>>  sde1 sdb1 sdd1 sdc1
>>  sde1 sdd1 sdb1 sdc1
> 
> so I used this combinations:
> 
> sdf1 sde1 sdg1 sdh1
> sdf1 sdg1 sde1 sdh1
> sdh1 sde1 sdg1 sdf1
> sdh1 sdg1 sde1 sdf1
> 
> 
>> For now, use data offset 2048 for all of them.
> 
> output of all eight combinations:

Hmmm.  Very strange.  Let's see the dump of the start of the data area of all four partitions:

for x in /dev/sd[efgh]1 ; do echo -e "\n$x\n" ; dd if=$x skip=2048 count=16 2>/dev/null |hexdump -C ; done

Phil

