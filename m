From: Sam Bingner <sam@bingner.com>
Subject: Re: Odd --examine output
Date: Thu, 18 Apr 2013 06:32:50 +0000
Message-ID: <B4548F08-EC69-40F2-974C-68FE41D7FE87@bingner.com>
References: <CD917B51.41713%michael.vanhorn@wright.edu>,<10112252.14.1366051374769.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <10112252.14.1366051374769.JavaMail.root@zimbra>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: Mike Vanhorn <michael.vanhorn@wright.edu>, Phil Turmel <philip@turmel.org>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Apr 15, 2013, at 8:43 AM, "Roy Sigurd Karlsbakk" <roy@karlsbakk.net> wrote:

>>> NOT a guess. Back up what you can, while you can, and start over. Use
>>> "fdisk -u" so you can ensure partitions start on multiples of eight
>>> (8)
>>> sectors. (Modern fdisk uses 1MB alignment by default. Highly
>>> recommended.)
>> 
>> So, if I start the partition at sector 64 (rather than 63), that's
>> better,
>> right (since 64 is a multiple of 8)? Or is there more math to do and
>> I'm still not getting it?
> 
> I still don't understand why people use partitions for RAID when the whole drive is used anyway. Partitions were invented to partition things up and are of no use if you want to spend the whole drive's space for RAID use (or otherwise).
> 
I partition devices because it makes it much simpler to know what is on that device.  Granted there are other ways to do this but if I put a partition on it, during some random installer process it won't assume the drive is empty and happily write a partition table or otherwise screw over the device without my knowledge...

I tried going partition-less at one point, but it wasn't worth it to save 1MB of space while considering the previous issue and removing the flexibility to utilize any additional space due to uneven sized drives to, for example, hold a "boot" array that is on the same drives but is a raid1 instead of a raid6... 

Sam