From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [mdadm git pull] Intel metadata updates and some general fixes
Date: Thu, 16 Apr 2009 10:16:53 -0700
Message-ID: <e9c3a7c20904161016t48d2cdcew7c82dc14c715bd6d@mail.gmail.com>
References: <1239525557.7433.49.camel@dwillia2-linux.ch.intel.com>
	 <18915.58524.95857.14466@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18915.58524.95857.14466@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, Ed Ciechanowski <ed.ciechanowski@intel.com>, Jacek Danecki <jacek.danecki@intel.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-raid.ids

On Mon, Apr 13, 2009 at 6:19 PM, Neil Brown <neilb@suse.de> wrote:
> Do you have anything else in the works that you want to be in
> 3.0-final?
> My pending list is now:
> =A0- some more ddf self-tests
> =A0- think about Doug's opinion on 'homehost'
> =A0- review and update man pages.
>
> which is unlikely to be all done this week, but maybe next week.
> If you (or anyone else) has things that can be done in that time fram=
e
> and you want in 3.0-final, a heads-up would be appreciated.

Two items, although (2) is definitely post 3.0-final material.

1/ Modify the output of brief_examine_super_imsm() to specify
"auto=3Dmd" in cases where the kernel has extended block device numbers
(is there anyway to detect this other than by kernel version?).
Currently it is always "auto=3Dmdp".

2/ Introduce the HBA configuration file option to specify raid domains
and hotplug policies:

HBA=3D<platform | sysfs device path> domain=3D<platform | container uui=
d>
hotplug=3D<ignore | reattach | rebuild> enforce_ports=3D<yes | no | war=
n>

=2E..where:
"HBA" selects the I/O controller explicitly with a sysfs device path
or auto-detected in the 'platform' case.

"domain" selects which container disks attached to this controller
belong.  I currently can not think of a clean way to make this
capability available to native-md-metadata arrays because the
automatic hotplug handling would need to consider partitions.  Maybe
in the native case it can be limited it to 'whole disk' arrays, or
just the 'reattach' case?

"hotplug" sets the hotplug event policy: the difference between
'reattach' and 'rebuild' being that the drive must already be marked
as a spare or former member and rebuild will additionally write a
spare record to any new disks.

"enforce_ports" sets the policy on what to do when domain members are
found outside of the HBA path.  Specifying 'yes' tells mdadm to treat
disks outside of the HBA path as missing for create, assemble, and
hotplug.

Thanks,
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
