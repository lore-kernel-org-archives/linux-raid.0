From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: The chunk size paradox
Date: Thu, 02 Jan 2014 16:42:42 -0600
Message-ID: <52C5EB62.1090807@hardwarefreak.com>
References: <52C1C01A.7010407@ubuntu.com> <52C57C7B.80400@shiftmail.org> <52C588A7.6010207@hardwarefreak.com> <52C59468.6080200@ubuntu.com> <52C5A9AA.9090300@hardwarefreak.com> <52C5BC28.2020003@gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52C5BC28.2020003@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Landman <joe.landman@gmail.com>, Phillip Susi <psusi@ubuntu.com>, joystick <joystick@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 1/2/2014 1:21 PM, Joe Landman wrote:
> On 01/02/2014 01:02 PM, Stan Hoeppner wrote:
>> On 1/2/2014 10:31 AM, Phillip Susi wrote:
>>> On 1/2/2014 10:41 AM, Stan Hoeppner wrote:
>>>> First, there is no such thing as a 4K sector in Linux.  Sectors are
>>>> 512 bytes.  Filesystem blocks and memory pages are 4K.
>>>
>>> Of course there is.  Disks with 4k sectors are becoming more and more
>>> popular.
>>
>> Please read:  https://en.wikipedia.org/wiki/Advanced_Format
>>
>> There are no native 4K sector drives on the market.  Linux does not
> 
> Untrue.
> 
> http://storage.toshiba.eu/cms/en/hdd/hard_disk_drives/product_detail.jsp?productid=452

From that page:

Physical parameters	
Bytes/sector (Host)		512
Bytes/sector (Disk)		4096 kByte

> 
> http://www.seagate.com/www-content/product-content/constellation-fam/constellation-cs/en-us/docs/terascale-hdd-data-sheet-ds1793-1-1306us.pdf

From that page:

Configuration
Heads/Disks				8/4
Bytes per Sector (512-byte emulation)	4096

Damn, you had me salivating Joe.  These are both AF 512e drives, not
native 4K.

> and many others.

I've not yet seen an announcement from anyone.  I'm not all seeing, but
I'd think such an announcement would cross my RADAR.

> 512 byte sector native drives are now far less common, with many of the
> drives being native 4096 bytes with a translation layer for legacy
> systems that require 512 bytes.  This is infamous for wreaking havoc
> with alignment.

Exactly.  Which is why so many of us wish native 4K drives would be
released.  And, again, AFAIK, nobody is shipping a native drive.
They're all still 512e.  I'd love for someone to prove me wrong here by
pointing one out that is available, preferably more than one.

-- 
Stan


