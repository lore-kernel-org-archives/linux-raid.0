From: Brad Campbell <brad@wasp.net.au>
Subject: Re: Using a disk image file as a device in a raid set (like a loopback
 device)
Date: Sun, 08 Jan 2006 14:33:31 +0400
Message-ID: <43C0EA7B.6020406@wasp.net.au>
References: <43C0E89D.3040209@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43C0E89D.3040209@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

David Greaves wrote:
> 
> mdadm -B /dev/md0 -l linear -n2 /dev/sdc2 /space/sdb2.dd_image
> 
> but of course mdadm correctly complains that /space/sdb2.dd_image isn't
> a block device.
> 
> Does anyone know how I can do this?

use the loopback device
man losetup

Good luck :)
Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
