From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: Bug - native array blocks external container
Date: Fri, 21 Jan 2011 17:24:08 +0000
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010EAB48DC@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

Hi Neil,
Our validation reported it was not possible to move a spare from native array to imsm container.
After closer investigation it appears that this issue shows in kernels from 2.6.36 upwards.
It turns out even more serious: 
If a native array exists in the system it is not possible to create, assemble or add to an imsm container.
(confirmed on raid1 arrays, 2 disks for native, 2 disks for imsm + 1 spare)
In such case for some reason AllReserved is set in rdev->flags in rdev_size_store function in md.c
so writing to size file by sysfs_set_str always fails when native array exists.
The flag is not set when there is no native arrays and all actions can be completed normally.

This is just to inform about the issue.
It will be investigated further after the weekend.
Regards
Anna

