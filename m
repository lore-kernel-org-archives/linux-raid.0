From: David Greaves <david@dgreaves.com>
Subject: Re: Raid5 assemble after dual sata port failure
Date: Sun, 18 Nov 2007 12:25:25 +0000
Message-ID: <47402F35.9020401@dgreaves.com>
References: <47321FDF.8060207@synplicity.com> <4732E5F0.7080805@dgreaves.com> <4734CFE5.8070305@synplicity.com> <4734FB4A.4070401@synplicity.com> <473576F9.6040602@dgreaves.com> <4735FC7E.7030601@synplicity.com> <47373746.9090701@dgreaves.com> <47373EB9.9050408@synplicity.com> <4737870D.5000906@dgreaves.com> <4737A5CC.8040105@tmr.com> <473E8AC2.9020701@synplicity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <473E8AC2.9020701@synplicity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Eddington <chrise@synplicity.com>
Cc: Bill Davidsen <davidsen@tmr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Chris Eddington wrote:
> Key questions:
> - I assume ddrescue will do a much better job of correcting errors when
> imaging a disk?  My colleague used ghost which is just a copy tool.  I
> don't understand the capabilities of ddrescue on raid partitions that well.
ddrescue should do a *much* better job.
It knows nothing about raid and operates on the underlying device. It retries
bad sectors in a clever manner.


> - fdisk -l reports that all the drives are exactly the same size with
> exactly the same # sectors shown below.  I don't quite follow the
> hpa_resize issue, but it appears the drives don't have hidden HPA
> sectors - I guess?  Note that sdc is the original drive, where sda, sdb,
> and sdd are the imaged drives.
> 
> So what do you recommend to do first?  Should I try xfs_repair on the
> ghost copy,
No
 or just re-copy myself using ddrescue?
Yes.
  Are there special
> settings to ddrescue I should consider to verify/correct potential HPA
> changes?
Ideally just ddrescue the entire device to a file and use loopback.

For the faulty disk then if you have space, make a second copy and xfs_repair
using that. If it fails then you can easily re-image the good disks but it may
not be so easy to re-image the bad one.

David
