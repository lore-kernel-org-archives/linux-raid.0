From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: Re: mdadm --fail doesn't mark device as failed?
Date: Thu, 22 Nov 2012 10:43:46 +0100
Message-ID: <50ADF3D2.9030206@profitbricks.com>
References: <1353514677.5795.14.camel@corn.betterworld.us>  <50AD0726.9090509@profitbricks.com>  <1353517421.5795.58.camel@corn.betterworld.us>  <50AD0B01.7020300@profitbricks.com>  <1353518608.5795.76.camel@corn.betterworld.us>  <50AD13A3.5040709@profitbricks.com> <1353526912.5795.104.camel@corn.betterworld.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1353526912.5795.104.camel@corn.betterworld.us>
Sender: linux-raid-owner@vger.kernel.org
To: Ross Boylan <ross@biostat.ucsf.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21.11.2012 20:41, Ross Boylan wrote:
> On Wed, 2012-11-21 at 18:47 +0100, Sebastian Riemer wrote:
>
>> Yes, sometimes hardware has only a short issue and operates as expected
>> afterwards. Therefore, there is an error threshold. It could be very
>> annoying to zero the superblock and to resync everything only because
>> there was a short controller issue or something similar. Without this
>> you also couldn't remove and re-add devices for testing.
> So if my intention is to remove the "device" (in this case, partition)
> across reboots is using sysfs as you indicated sufficient? 

Yes, if you set a high number into sysfs file "errors", then you can
even keep the superblock but don't ask me how to revert this change. I
don't think that there is a "MakeGood" command.

> Zeroing the superblock (--zero-superblock)?

That's the alternative but you loose superblock data.

>  Removing the device (mdadm --remove)?

Here you need one of the methods above additionally.

> In this particular case the partition was fine, and my thought was I
> might add it back later.  But since the info would be dated, I guess
> there was no real benefit to preserving the superblock.  I did want to
> preserve the data in case things went catastrophically wrong.

You don't really have a benefit of keeping the superblock. The only
useful information is to which device it belonged to. In general you
replace the failed drive and the new device is synced from the remaining
good drive. Without the superblock you can read the actual data anyway
starting from the data offset.

