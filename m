From: Brad Campbell <brad@wasp.net.au>
Subject: Re: split off + mount a partitionless RAID1 device?
Date: Tue, 27 May 2008 08:43:23 +0400
Message-ID: <483B916B.9060100@wasp.net.au>
References: <e03b90ae0805262100h9eb16cfq31fe9e0430154007@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e03b90ae0805262100h9eb16cfq31fe9e0430154007@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Breidenbach <jeff@jab.org>
Cc: linux-raid list <linux-raid@vger.kernel.org>, Jeff Marshall <marshman@frozenbear.com>
List-Id: linux-raid.ids

Jeff Breidenbach wrote:

> I'd love to split one of the drives off of the RAID1 and mount it
> directly. Then it can feed the ravenous Apache monster while the
> other five drives resync in peace. But foolishly and somewhat
> accidentally, this RAID is made up of devices (sdb, sdbf, etc..)
> instead of paritions (sdb1, sdf1, etc...). And I don't know how to
> mount a partitionless device. Do you?

Works just like mounting any other block device
You don't absolutely *require* a partition table on a device, you can get along fine without one if 
you are not worried about the kernel complaining from time to time about an invalid partition table.

mount /dev/sdb /mnt

Easy.

Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
