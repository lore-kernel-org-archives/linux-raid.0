From: Robin Bowes <robin-lists@robinbowes.com>
Subject: Re: non-optimal RAID 5 performance with 8 drive array
Date: Tue, 01 Mar 2005 18:12:06 +0000
Message-ID: <d02b09$9ud$1@sea.gmane.org>
References: <42246D1F.3070407@variant.ch> <d029u5$65p$1@sea.gmane.org> <6.2.1.2.2.20050301190313.053f5d60@mail.tekno-soft.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <6.2.1.2.2.20050301190313.053f5d60@mail.tekno-soft.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Roberto Fichera wrote:
> At 18.53 01/03/2005, Robin Bowes wrote:
>> [root@dude test]# dd if=/dev/zero of=/home/test/test.tmp bs=4096 
>> count=100000
>> 100000+0 records in
>> 100000+0 records out
>>
>> Notice there is no timing information.
> 
> you have to use:
> 
> time dd if=/dev/zero of=/home/test/test.tmp bs=4096 count=100000

Robert,

That's not what I meant - I know I can use "time" to get CPU usage 
information.

I was meaning that I don't get the disk speed summary like Nicola did, e.g.:

me@beast:$ dd if=/dev/zero of=/storagearray/test.tmp bs=4096
1238865+0 records in
1238864+0 records out
5074386944 bytes transferred in 63.475536 seconds (79942404 bytes/sec)

R.
-- 
http://robinbowes.com

