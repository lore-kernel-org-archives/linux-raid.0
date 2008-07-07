From: thomas62186218@aol.com
Subject: Re: md devices disappearing on system reboot
Date: Mon, 07 Jul 2008 15:11:53 -0400
Message-ID: <8CAAE7C73AB975E-26A8-1E6E@webmail-stg-d10.sysops.aol.com>
References: <8CAA9B1F81B8E21-614-D2D@webmail-nc09.sysops.aol.com> <20080702162108.GF4981@skl-net.de> <8CAAD37CC87F1BD-FD8-4A21@webmail-stg-d08.sysops.aol.com> <20080707093004.GQ23944@skl-net.de> <8CAAE4763AEB341-2F6C-570@webmailbeta-m07.sysops.aol.com> <20080707132319.GR23944@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080707132319.GR23944@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
To: maan@systemlinux.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Andre,

Thank you very much for the quick response.

My /dev/md0 device is using /dev/sdd1, /dev/sdg1, /dev/sdj1, and 
/dev/sdm1.

I did:
devices=/dev/sd[dgjm]
mdadm -A --run /dev/md0 $devices

I received:
mdadm: cannot open device /dev/sdd: Device or resource busy
mdadm: /dev/sdd has no superblock - assembly aborted

Any ideas?

-Thomas


-----Original Message-----
From: Andre Noll <maan@systemlinux.org>
To: thomas62186218@aol.com
Cc: linux-raid@vger.kernel.org
Sent: Mon, 7 Jul 2008 6:23 am
Subject: Re: md devices disappearing on system reboot










On 08:52, thomas62186218@aol.com wrote:

> Thank you for the response. When running:  mdadm -A /dev/md0   I get:
>
> mdadm: no devices found for /dev/md0
>
> But fdisk -l  shows all the devices present on the system...

Try to specify all component devices manually:

    devices=/dev/sd[abcd]
    mdadm -A --run /dev/md0 $devices

You'll probably need to modify the content of the above devices
variable.

Andre
--
The only person who always got his work done by Friday was Robinson 
Crusoe





