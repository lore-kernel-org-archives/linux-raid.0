From: "Scott T. Smith" <scott@gelatinous.com>
Subject: RE: 3ware drive hotswapping
Date: Mon, 21 Jun 2004 20:36:45 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1087875404.8757.110.camel@tinny.home.foo>
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
> 2. You have powered the drive back on after re-insertion.
> 3. You have a 3ware driver >= v1.02.00.032.

nevermind, I see that I was supposed to use the 3ware CLI to rescan the
controller.  I guess there's no automatic handling of reinserted disks.

	Scott


