From: Phil Turmel <philip@turmel.org>
Subject: Re: Storage device enumeration script
Date: Fri, 27 May 2011 07:23:03 -0400
Message-ID: <4DDF8997.5090109@turmel.org>
References: <4DDDC301.7090608@turmel.org> <1306403130.9437.109.camel@torbjorn> <4DDE249C.7080004@anonymous.org.uk> <4DDF6B99.20602@anonymous.org.uk> <4DDF7296.6050706@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DDF7296.6050706@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/27/2011 05:44 AM, John Robinson wrote:
> On 27/05/2011 10:15, John Robinson wrote:
> [...]
>> I'm not entirely sure where dev.ID_ etc are supposed to be coming
>> from, but if it's that `blkid -p -o udev /dev/block/8:0` then I'm
>> afraid CentOS 5's blkid doesn't understand the -p or -o udev options,
>> it doesn't produce any output for whole drives with partition tables,
>> and there isn't a /dev/block directory. It's blkid 1.0.0 from
>> e2fsprogs 1.39-23.el5_5.1.
>>
>> If that knocks CentOS 5 support on the head then so be it...
> 
> Hmm, udevinfo might be of some use. Still doesn't say it's found a DOS
> partition table, but it does get you e.g. ID_FS_TYPE=linux_raid_member and perhaps `file -s` will tell you there's DOS partition table (sort of).

I'll look into this when I have a new CentOS 5 VM installed on my laptop.  I do want lsdrv to work with all of the CentOS 5 releases.

Phil
