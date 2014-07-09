From: Chris Murphy <lists@colorremedies.com>
Subject: Re: no automatic resync after device disconnect then reconnect
Date: Wed, 9 Jul 2014 17:57:03 -0600
Message-ID: <17DF6122-CD4A-4093-BA6B-4F1A98657655@colorremedies.com>
References: <883F6A2C-C8F6-4A27-B7BF-2FB98F395592@colorremedies.com> <20140710085840.78a65722@notabene.brown>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140710085840.78a65722@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Jul 9, 2014, at 4:58 PM, NeilBrown <neilb@suse.de> wrote:

> On Wed, 9 Jul 2014 16:44:27 -0600 Chris Murphy <lists@colorremedies.com>
> wrote:
> 
>> This is in a VM, no data at risk.
>> 
>> Two problems:
>> 
>> 1. I intentionally removed one of two md raid1 member devices, boot degraded succeeds, clean power off, reconnect the removed md member device, boot succeeds but an automatic resync does not occur for the previously disconnect md members. Maybe this is expected, I'm not sure, but I'd think a better user experience would be autoresync perhaps with a notification?
> 
> Do you?  Maybe the device was removed from the array because it is faulty.
> Do you *really* want a faulty device automatically added back into your array?

OK maybe not.

> It is quite possible to set up udev rules and configure mdadm policy to do
> this.  I just don't think it is a sensible default.

Fair enough.


> 
>> 
>> 2. For the raid set with a bitmap, this command succeeds
>> # mdadm --manage /dev/md126 --re-add /dev/sdb3
> 
> Good to know.
> 
>> 
>> However, for the raid set without bitmap (seems the same otherwise, same metadata version), it fails:
>> # mdadm --manage /dev/md127 --re-add /dev/sdb2
>> mdadm: --re-add for /dev/sdb2 to /dev/md127 is not possible
> 
> You need a bitmap to --re-add.

OK.

> Without a bit map, you are just adding an unused device to an array and
> "--add" is the command to use.
> If you set up the mdadm policy (in mdadm.conf) suitably then
>   mdadm -I /dev/sdb2
> 
> would find the add and --add it for you (I think).


[root@localhost ~]# mdadm -I /dev/sdb2
mdadm: not adding /dev/sdb2 to active array (without --run) /dev/md/boot
[root@localhost ~]# mdadm -I /dev/sdb2 --run /dev/md/boot
mdadm: --incremental can only handle one device.
[root@localhost ~]# mdadm --manage /dev/md127 --add /dev/sdb2
mdadm: added /dev/sdb2

/proc/mdstat
md127 : active raid1 sdb2[2] sda2[0]
      716224 blocks super 1.2 [2/2] [UU]



Thanks,

Chris Murphy