From: Dennis Mungai <dmngaie@gmail.com>
Subject: Re: When will Linux support new RAID controllers
Date: Fri, 10 Nov 2017 16:31:21 +0300
Message-ID: <CAKKYfmEqw48mjBsKoy=qeny6B1X8PKytSN4UwpvSupo87746kg@mail.gmail.com>
References: <CAGRSmLs-Hr+FFfa4_29kidEeL2d7b+cEP6u1OkOUoYW6Cm15BA@mail.gmail.com>
 <20171110131937.GA26181@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20171110131937.GA26181@infradead.org>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "David F." <df7729@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, linux-ide@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, linux-nvme@lists.infradead.org
List-Id: linux-raid.ids

That feature would be especially important on systems where the
BIOS/UEFI environment offers no option to toggle back the AHCI mode.
This "RAID" Intel features is also known as "Intel Premium RST mode"
on all current Clevo systems, and on such a platform (the Clevo
P751DM2-G, marketed by the likes of Schenker and Origin PC) is based
on this platform.

-Dennis.

On 10 November 2017 at 16:19, Christoph Hellwig <hch@infradead.org> wrote:
> On Thu, Nov 09, 2017 at 10:24:54AM -0800, David F. wrote:
>> It seems that Linux will not see any HD on Intel's 100 Series or newer
>> chipsets (Z170, etc.) when in RAID mode.  (typically these systems
>> have M2 NVMe devices ). This is problematic when wanting to use Linux
>> on the system without having to disable RAID and when on their with
>> Windows.   Maybe not a linux-raid issue, but is Linux RAID issue
>> within the kernel device support.
>
> Dan (on Cc) posted some patches to support the awkwared so called
> "RAID" mode (it really should be Intel landgrab mode) in the client
> chipsets more than a year ago.
>
> It needed a bit of a rework to be present as a fake PCIe root port
> instead of the platform driver magic, so I wonder what happened to
> it - Dan any chance to get back to it?
>
> _______________________________________________
> Linux-nvme mailing list
> Linux-nvme@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-nvme
