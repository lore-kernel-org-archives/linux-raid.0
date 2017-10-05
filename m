From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: Linux Plumbers MD BOF discussion notes
Date: Thu, 5 Oct 2017 20:52:10 +0200
Message-ID: <4bc99226-0843-351b-dca6-7d0a083de925@intel.com>
References: <20170915142737.qafwl3vgl6vhfi5q@kernel.org>
 <871sn78pzt.fsf@notabene.neil.brown.name>
 <alpine.DEB.2.20.1709180852450.29378@uplift.swm.pp.se>
 <874ls0s7un.fsf@notabene.neil.brown.name>
 <alpine.DEB.2.20.1710010730210.31961@uplift.swm.pp.se>
 <87lgkr3fgj.fsf@notabene.neil.brown.name>
 <619758c0-9ca4-c25d-c61b-f411b095041d@intel.com>
 <87d162380v.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87d162380v.fsf@notabene.neil.brown.name>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/04/2017 11:41 PM, NeilBrown wrote:
> On Wed, Oct 04 2017, Artur Paszkiewicz wrote:
> 
>>
>> Also, our customers are asking specifically for an option to "hide" the
>> member drives. Making it impossible to write to the devices is ok, but
>> they would like to see only the md device, "like hardware raid". One of
>> the reasons is that some monitoring or inventory scan applications treat
>> md arrays and their components as separate storage devices. They should
>> probably modify their software but maybe that's not possible.
> 
> What exactly is meant by "hide".  How, exactly, does this software scan
> all devices?  /proc/partitions? /sys/block? /sys/class/block?
> /dev/disks?  All of the above.
> 
> Modifying their application *must* be on the table, else modify the
> kernel is *not* on the table.  I'm certainly open to enhancing the
> kernel so that it is easy to skip a particular class of devices, but if
> their application chooses to ignore the information the kernel provides,
> then the fact that the application doesn't work is their problem, not
> ours.
> 
> 
>>
>> I've been experimenting with different solutions and here is a patch
>> that allows to "hide" disk devices and their partitions by writing to a
>> sysfs attribute. It removes the device nodes (on devtmpfs), links in
>> /sys/block/ and removes the devices from the block class list, so they
>> won't be included in places like /proc/partitions, /sys/class/block/,
>> lsblk and so on. The device's "real" sysfs directory under /sys/devices/
>> is still available, also the links in /sys/dev/block/ are preserved.
>> Applications like mdadm can use this to hide/unhide their component
>> devices.
> 
> Can you confirm that this addresses the customer problem?  Do you know
> which of these lists their code looks at?

Yes, this is what they asked for. I know that at least /proc/partitions
and /sys/class/block are used. But this is not a single customer (or
application) case, this keeps coming up again and again... Of course
educating users about the specifics of md and that not hiding the drives
is actually an advantage always comes first. Some get it and would be ok
with just blocking write access to the drives, but others really want
this hiding approach.

Thanks,
Artur
