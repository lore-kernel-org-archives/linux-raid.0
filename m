From: Andy Smith <andy@strugglers.net>
Subject: Re: Can extremely high load cause disks to be kicked?
Date: Fri, 1 Jun 2012 19:25:24 +0000
Message-ID: <20120601192524.GH3867@bitfolk.com>
References: <20120531083158.GE3867@bitfolk.com>
 <4FC81B85.8090807@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4FC81B85.8090807@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Stan,

On Thu, May 31, 2012 at 08:31:49PM -0500, Stan Hoeppner wrote:
> On 5/31/2012 3:31 AM, Andy Smith wrote:
> > Now, is this sort of behaviour expected when under incredible load?
> > Or is it indicative of a bug somewhere in kernel, mpt driver, or
> > even flaky SAS controller/disks?
> 
> It is expected that people know what RAID is and how it is supposed to
> be used.  RAID is to be used for protecting data in the event of a disk
> failure and secondarily to increase performance.  That is not how you
> seem to be using RAID.

Just to clarify, this was the hypervisor host. The VMs on it don't
use RAID themselves as that would indeed be silly.

> There are a number of scenarios where md RAID is better than hardware
> RAID and vice versa.  Yours is a case where hardware RAID is superior,
> as no matter the host CPU load, drives won't get kicked offline as a
> result, as they're under the control of a dedicated IO processor (same
> for SAN RAID).

Fair enough, thanks.

Cheers,
Andy
