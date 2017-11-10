From: Christoph Hellwig <hch@infradead.org>
Subject: Re: When will Linux support new RAID controllers
Date: Fri, 10 Nov 2017 05:19:37 -0800
Message-ID: <20171110131937.GA26181@infradead.org>
References: <CAGRSmLs-Hr+FFfa4_29kidEeL2d7b+cEP6u1OkOUoYW6Cm15BA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGRSmLs-Hr+FFfa4_29kidEeL2d7b+cEP6u1OkOUoYW6Cm15BA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "David F." <df7729@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, linux-ide@vger.kernel.org, linux-nvme@lists.infradead.org, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

On Thu, Nov 09, 2017 at 10:24:54AM -0800, David F. wrote:
> It seems that Linux will not see any HD on Intel's 100 Series or newer
> chipsets (Z170, etc.) when in RAID mode.  (typically these systems
> have M2 NVMe devices ). This is problematic when wanting to use Linux
> on the system without having to disable RAID and when on their with
> Windows.   Maybe not a linux-raid issue, but is Linux RAID issue
> within the kernel device support.

Dan (on Cc) posted some patches to support the awkwared so called
"RAID" mode (it really should be Intel landgrab mode) in the client
chipsets more than a year ago.

It needed a bit of a rework to be present as a fake PCIe root port
instead of the platform driver magic, so I wonder what happened to
it - Dan any chance to get back to it?
