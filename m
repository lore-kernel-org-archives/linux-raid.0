From: "Scott T. Smith" <scott@gelatinous.com>
Subject: RE: 3ware drive hotswapping
Date: Mon, 21 Jun 2004 18:20:56 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1087867256.9264.102.camel@tinny.home.foo>
References: <HZORLD00.NTI@hadar.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <HZORLD00.NTI@hadar.amcc.com>
To: Adam Radford <aradford@amcc.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2004-06-21 at 18:17, Adam Radford wrote:
> Please make sure that:
> 
> 1. You have support for /proc/scsi turned on in your kernel.

yup (cat /proc/scsi/scsi shows lots of stuff, and
remove-single-device/add-single-device work for other drives).

> 2. You have powered the drive back on after re-insertion.

uh..... ummm..... how do I do that?

I was told the drives are not programmed to power on when the machine
powers on, but instead by the controller in order to prevent a power
surge on start (we have 24 disks); though for the life of me I can't
figure out where that is set (the Alt-3 screen on startup doesn't seem
to show any option regarding that).

> 3. You have a 3ware driver >= v1.02.00.032.

yup

	Scott


