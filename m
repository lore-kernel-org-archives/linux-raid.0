From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: [mdadm git pull] support for detecting platform raid capabilities and some fixes
Date: Fri, 28 Nov 2008 12:16:12 -0700
Message-ID: <e9c3a7c20811281116n5250b4bfv498c83de9710a414@mail.gmail.com>
References: <1227743100.31146.41.camel@dwillia2-linux.ch.intel.com>
	 <18735.12218.461012.396198@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18735.12218.461012.396198@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>
List-Id: linux-raid.ids

On Thu, Nov 27, 2008 at 4:39 PM, Neil Brown <neilb@suse.de> wrote:
> On Wednesday November 26, dan.j.williams@intel.com wrote:
>> Hi Neil,
>>
>> This is hopefully the tail of the feature additions from me for
>> mdadm-3.0-final.  It adds the capability for mdadm to detect platform
>> raid capabilities, and honor them when creating new arrays.  For example
>> here is the output of the new --detail-platform option on an imsm
>> enabled platform:
>>
>> # mdadm --detail-platform -e imsm
>>        Platform : Intel(R) Matrix Storage Manager
>>         Version : 7.6.0.1011
>>     RAID Levels : raid0 raid1 raid10 raid5
>>       Max Disks : 6
>>     Max Volumes : 2
>>  I/O Controller : /sys/devices/pci0000:00/0000:00:1f.2
>>           Port0 : /dev/sda (5RA4GKSS)
>>           Port1 : /dev/sdb (5RA4GKNC)
>>           Port2 : /dev/sdc (5RA4GKT8)
>>           Port3 : /dev/sdd (5RA4GQWR)
>>           Port5 : /dev/sde (5RA4GQYG)
>
> No "Port4" - seems odd.
>

Port4 is attached to a sata-dvd in this case.  I'll expand this output
to show empty ports, and non-disk attached ports.

> So what happens when you try to create an array on devices that aren't
> attached to a detected platform?  Or create an array that crosses two
> separate controllers?
> Just a warning?  Require --force?  Do nothing ??
>
> Sounds like a useful thing!

Right now it just returns errors from ->validate_geometry and
->add_to_super.  The environment variable IMSM_NO_PLATFORM turns off
this checking.  The --assemble case could take advantage of this as
well to warn or fail to assemble when disks are found on "non-raid"
ports, currently 'platform' checking is silent at assembly.  Different
environments could have different policies...

Here is a lingering idea that may be post mdadm-3.0 material: What
about exposing these policy decisions via a new configuration file
variable: HBA?
HBA device=<'platform' | sysfs device path | some other identification
tuple> enforce_ports=<no | yes | warn> auto_hotplug=<no | yes>

Where enforce_ports checks for assembly or create events talking to
HBA-attached disks and 'auto_hotplug' handles re-adding disks on a
hotplug event where the administrator expects this to happen for the
"raid controller" but not for example usb-storage.

>>
>> This implementation crawls through sysfs to put this information
>> together, I believe it is crawling in a future proof fashion, but here
>> are my assumptions:
>> 1/ /sys/bus/pci/drivers/ahci/<x>/device will identify a pci ahci device
>> with a bus id of 'x'.  This allows mdadm to detect which disks are
>> attached to which controller.
>> 2/ The 'scsi_host' objects in /sys/bus/pci/drivers/ahci/<x> are named
>> 'host%d' and there is one host per physical ahci port.  This is not
>> critical but allows the 'Port' information to be displayed.
>>
>
> IMSM is only ever ahci?  Never SCSI etc?

Yes, only ahci-sata.

> And I notice that you hunt through all of the option-rom memory to
> find the option from for the IMSM to read some details.
> Once you have the I/O Controller, can you just look in the "resource"
> file to get start/length info and read just that area ???

Scanning through option-rom memory was a bit unpalatable to me as
well, and I expected to find this region mapped via an expansion-rom
bar.  However this is not the case as there does not appear to be an
associated 'resource' file with this range.  /proc/iomem reports:
000c0000-000dffff : pnp 00:01

/sys/bus/pnp/devices/00:01/ does not contain anything that would point
me to the eventual 0xce840 in this case.

> What would you think of using the 'resource' info, either via libpci
> or more directly, possibly lifting the parser code from libpci?
> I think I'd feel more comfortable about that.

Me too, but I don't think this capability lends itself to generic discovery.

[..]
>> Other notables:
>> 1/ An attempt to cover the delay between mdadm creating an array and the
>> friendly-named device node showing up in /dev/md/ by calling 'udevadm
>> settle' before starting starting Incremental assembly.  This
>> specifically fixes scripts that do:
>> mdadm -A /dev/md/<container>
>> mdadm -I /dev/md/<container>
>> There is a good chance there is a better place to put this call, but
>> putting it in create_mddev didn't work, and moving it up in main()
>> resulted in a hang.  I didn't want to hold up the other patches for this
>> debug.
>
> I recently added "wait_for" to wait a little while for a device to
> appear in /dev.  I don't seem to be calling it at the end of
> --assemble.
> Maybe putting that in place will be enough?

I'll take a look.

[..]
>> Please have a look.
>
> I'll cherry-pick out the bits I definitely like and apply them.  Then
> we can discuss the rest.
>

Sounds good.

Thanks,
Dan
