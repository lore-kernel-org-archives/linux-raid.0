From: "David F." <df7729@gmail.com>
Subject: Re: When will Linux support M2 on RAID ?
Date: Sat, 11 Mar 2017 16:52:29 -0800
Message-ID: <CAGRSmLszm7JHtjmu3yQdRRLDU9CAR6nvyR58M7LxqwFYqEDCNg@mail.gmail.com>
References: <CAGRSmLsqBF_7eGHdeA=FQbgbjSLMrbRK14mNQxyBcV0PoGYaRQ@mail.gmail.com>
 <20170307045200.GA1708@infradead.org> <a92c6f16-af2d-9d79-fb09-8490aac050db@gmail.com>
 <20170307151528.GA16216@infradead.org> <f37700c7-139d-2bf4-07da-4f0bf77c743d@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f37700c7-139d-2bf4-07da-4f0bf77c743d@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Very possible it affects other devices attached, but all consumer
reports and test systems here all have NVME drives on m2 and when in
RAID mode.  Listing PCI data linux will show Intel SATA controller
detected in RAID mode, but no drives detected, all you get is your
/dev/sda USB boot device.  A lot of places linux uses a table of known
ID's and if not listed doesn't support it, unlike Windows which always
supports the given generic device type when it can (keyboard, etc..)
and special drivers for special features.  RAID of course is different
an typically requires special drivers.   As mentioned, some system
don't let you change the mode, others you can't use linux as a
maintenance platform since it won't see any of the drives.  Just be
nice to have things "just work".

On Tue, Mar 7, 2017 at 7:54 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2017-03-07 10:15, Christoph Hellwig wrote:
>>
>> On Tue, Mar 07, 2017 at 09:50:22AM -0500, Austin S. Hemmelgarn wrote:
>>>
>>> He's referring to the RAID mode most modern Intel chipsets have, which
>>> (last
>>> I checked) Linux does not support completely and many OEM's are setting
>>> by
>>> default on new systems because it apparently provides better performance
>>> than AHCI even for a single device.
>>
>>
>> It actually provides worse performance.  What it does it that it shoves
>> up to three nvme device bars into the bar of an AHCI device, and
>> requires the OS to handle them all using a single driver.  The Money's
>> on crack at Intel decided to do that to provide their "valueable" RSTe
>> IP (which is a windows ATA + RAID driver in a blob, which now has also
>> grown a NVMe driver).  The only remotely sane thing is to disable it
>> in the bios, and burn all people involved with it.  The next best thing
>> is to provide a fake PCIe root port driver untangling this before it
>> hits the driver, but unfortunately Intel is unwilling to either do this
>> on their own or at least provide enough documentation for others to do
>> it.
>>
> For NVMe, yeah, it hurts performance horribly.  For SATA devices though,
> it's hit or miss, some setups perform better, some perform worse.
>
> It does have one advantage though, it lets you put the C drive for a Windows
> install on a soft-RAID array insanely easily compared to trying to do so
> through Windows itself (although still significantly less easily that doing
> the equivalent on Linux...).
>
> The cynic in me is tempted to believe that the OEM's who are turning it on
> by default are trying to either:
> 1. Make their low-end systems look even crappier in terms of performance
> while adding to their marketing checklist (Of the systems I've seen that
> have this on by default, most were cheap ones with really low specs).
> 2. Actively make it harder to run anything but Windows on their hardware.
