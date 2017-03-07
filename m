From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Subject: Re: When will Linux support M2 on RAID ?
Date: Tue, 7 Mar 2017 10:54:54 -0500
Message-ID: <f37700c7-139d-2bf4-07da-4f0bf77c743d@gmail.com>
References: <CAGRSmLsqBF_7eGHdeA=FQbgbjSLMrbRK14mNQxyBcV0PoGYaRQ@mail.gmail.com>
 <20170307045200.GA1708@infradead.org>
 <a92c6f16-af2d-9d79-fb09-8490aac050db@gmail.com>
 <20170307151528.GA16216@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170307151528.GA16216@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "David F." <df7729@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 2017-03-07 10:15, Christoph Hellwig wrote:
> On Tue, Mar 07, 2017 at 09:50:22AM -0500, Austin S. Hemmelgarn wrote:
>> He's referring to the RAID mode most modern Intel chipsets have, which (last
>> I checked) Linux does not support completely and many OEM's are setting by
>> default on new systems because it apparently provides better performance
>> than AHCI even for a single device.
>
> It actually provides worse performance.  What it does it that it shoves
> up to three nvme device bars into the bar of an AHCI device, and
> requires the OS to handle them all using a single driver.  The Money's
> on crack at Intel decided to do that to provide their "valueable" RSTe
> IP (which is a windows ATA + RAID driver in a blob, which now has also
> grown a NVMe driver).  The only remotely sane thing is to disable it
> in the bios, and burn all people involved with it.  The next best thing
> is to provide a fake PCIe root port driver untangling this before it
> hits the driver, but unfortunately Intel is unwilling to either do this
> on their own or at least provide enough documentation for others to do
> it.
>
For NVMe, yeah, it hurts performance horribly.  For SATA devices though, 
it's hit or miss, some setups perform better, some perform worse.

It does have one advantage though, it lets you put the C drive for a 
Windows install on a soft-RAID array insanely easily compared to trying 
to do so through Windows itself (although still significantly less 
easily that doing the equivalent on Linux...).

The cynic in me is tempted to believe that the OEM's who are turning it 
on by default are trying to either:
1. Make their low-end systems look even crappier in terms of performance 
while adding to their marketing checklist (Of the systems I've seen that 
have this on by default, most were cheap ones with really low specs).
2. Actively make it harder to run anything but Windows on their hardware.
