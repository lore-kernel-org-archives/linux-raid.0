From: Joe Landman <joe.landman@gmail.com>
Subject: Re: The chunk size paradox
Date: Thu, 02 Jan 2014 14:21:12 -0500
Message-ID: <52C5BC28.2020003@gmail.com>
References: <52C1C01A.7010407@ubuntu.com> <52C57C7B.80400@shiftmail.org> <52C588A7.6010207@hardwarefreak.com> <52C59468.6080200@ubuntu.com> <52C5A9AA.9090300@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52C5A9AA.9090300@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com, Phillip Susi <psusi@ubuntu.com>, joystick <joystick@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 01/02/2014 01:02 PM, Stan Hoeppner wrote:
> On 1/2/2014 10:31 AM, Phillip Susi wrote:
>> On 1/2/2014 10:41 AM, Stan Hoeppner wrote:
>>> First, there is no such thing as a 4K sector in Linux.  Sectors are
>>> 512 bytes.  Filesystem blocks and memory pages are 4K.
>>
>> Of course there is.  Disks with 4k sectors are becoming more and more
>> popular.
>
> Please read:  https://en.wikipedia.org/wiki/Advanced_Format
>
> There are no native 4K sector drives on the market.  Linux does not

Untrue.

http://storage.toshiba.eu/cms/en/hdd/hard_disk_drives/product_detail.jsp?productid=452

http://www.seagate.com/www-content/product-content/constellation-fam/constellation-cs/en-us/docs/terascale-hdd-data-sheet-ds1793-1-1306us.pdf

and many others.

512 byte sector native drives are now far less common, with many of the 
drives being native 4096 bytes with a translation layer for legacy 
systems that require 512 bytes.  This is infamous for wreaking havoc 
with alignment.


