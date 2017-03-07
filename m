From: Christoph Hellwig <hch@infradead.org>
Subject: Re: When will Linux support M2 on RAID ?
Date: Tue, 7 Mar 2017 07:15:28 -0800
Message-ID: <20170307151528.GA16216@infradead.org>
References: <CAGRSmLsqBF_7eGHdeA=FQbgbjSLMrbRK14mNQxyBcV0PoGYaRQ@mail.gmail.com>
 <20170307045200.GA1708@infradead.org>
 <a92c6f16-af2d-9d79-fb09-8490aac050db@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a92c6f16-af2d-9d79-fb09-8490aac050db@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, "David F." <df7729@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Mar 07, 2017 at 09:50:22AM -0500, Austin S. Hemmelgarn wrote:
> He's referring to the RAID mode most modern Intel chipsets have, which (last
> I checked) Linux does not support completely and many OEM's are setting by
> default on new systems because it apparently provides better performance
> than AHCI even for a single device.

It actually provides worse performance.  What it does it that it shoves
up to three nvme device bars into the bar of an AHCI device, and
requires the OS to handle them all using a single driver.  The Money's
on crack at Intel decided to do that to provide their "valueable" RSTe
IP (which is a windows ATA + RAID driver in a blob, which now has also
grown a NVMe driver).  The only remotely sane thing is to disable it
in the bios, and burn all people involved with it.  The next best thing
is to provide a fake PCIe root port driver untangling this before it
hits the driver, but unfortunately Intel is unwilling to either do this
on their own or at least provide enough documentation for others to do
it.
