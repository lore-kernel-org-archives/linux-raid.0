From: "David F." <df7729@gmail.com>
Subject: Re: When will Linux support new RAID controllers
Date: Mon, 4 Dec 2017 18:01:10 -0800
Message-ID: <CAGRSmLto7dG19zgUkdZjuhacWXo=ju6WdS0YVjC5xOOsGjV9kg@mail.gmail.com>
References: <CAGRSmLs-Hr+FFfa4_29kidEeL2d7b+cEP6u1OkOUoYW6Cm15BA@mail.gmail.com>
 <20171110131937.GA26181@infradead.org> <CAKKYfmEqw48mjBsKoy=qeny6B1X8PKytSN4UwpvSupo87746kg@mail.gmail.com>
 <CAGRSmLsvAR6wth7tPd5J2kAydy64uQ+h45Yu-SUeOAHkfOHXHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRSmLsvAR6wth7tPd5J2kAydy64uQ+h45Yu-SUeOAHkfOHXHA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dennis Mungai <dmngaie@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, linux-ide@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, linux-nvme@lists.infradead.org
List-Id: linux-raid.ids

Hi,

Any word if the patch is available?

Is this going mainline anytime soon?


On Fri, Nov 10, 2017 at 11:06 AM, David F. <df7729@gmail.com> wrote:
> A patch would be great.  There has been several cases where no option
> to use AHCI mode available, or where a box seller would offer Linux as
> an alternate boot option against Windows in RAID mode (on the mobo)
> but could no longer provide Linux with their systems (without
> additional costs for add-in raid controller).
>
> On Fri, Nov 10, 2017 at 5:31 AM, Dennis Mungai <dmngaie@gmail.com> wrote:
>> That feature would be especially important on systems where the
>> BIOS/UEFI environment offers no option to toggle back the AHCI mode.
>> This "RAID" Intel features is also known as "Intel Premium RST mode"
>> on all current Clevo systems, and on such a platform (the Clevo
>> P751DM2-G, marketed by the likes of Schenker and Origin PC) is based
>> on this platform.
>>
>> -Dennis.
>>
>> On 10 November 2017 at 16:19, Christoph Hellwig <hch@infradead.org> wrote:
>>> On Thu, Nov 09, 2017 at 10:24:54AM -0800, David F. wrote:
>>>> It seems that Linux will not see any HD on Intel's 100 Series or newer
>>>> chipsets (Z170, etc.) when in RAID mode.  (typically these systems
>>>> have M2 NVMe devices ). This is problematic when wanting to use Linux
>>>> on the system without having to disable RAID and when on their with
>>>> Windows.   Maybe not a linux-raid issue, but is Linux RAID issue
>>>> within the kernel device support.
>>>
>>> Dan (on Cc) posted some patches to support the awkwared so called
>>> "RAID" mode (it really should be Intel landgrab mode) in the client
>>> chipsets more than a year ago.
>>>
>>> It needed a bit of a rework to be present as a fake PCIe root port
>>> instead of the platform driver magic, so I wonder what happened to
>>> it - Dan any chance to get back to it?
>>>
>>> _______________________________________________
>>> Linux-nvme mailing list
>>> Linux-nvme@lists.infradead.org
>>> http://lists.infradead.org/mailman/listinfo/linux-nvme
