From: NeilBrown <neilb@suse.de>
Subject: Re: disk order problem in a raid 10 array
Date: Sat, 19 Mar 2011 09:14:05 +1100
Message-ID: <20110319091405.2dfcad86@notabene.brown>
References: <201103181549.20835.xavier@alternatif.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201103181549.20835.xavier@alternatif.org>
Sender: linux-raid-owner@vger.kernel.org
To: Xavier Brochard <xavier@alternatif.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 18 Mar 2011 15:49:20 +0100 Xavier Brochard <xavier@alternatif.org>
wrote:

> Hello
> 
> trying to solve my problem with a unusable raid10 array, I discovered that 
> disk order is mixed between each boot - even with live-cd.
> Here's an extract from dmesg:
> [   12.5]  sda:
> [   12.5]  sdc:
> [   12.5]  sdd:
> [   12.5]  sde: sdd1
> [   12.5]  sdf: sdc1
> [   12.5]  sda1 sda2
> [   12.5]  sdg: sde1
> [   12.5]  sdf1
> 
> is that normal?
> could this be a sign of hardware controler problem?
> could this happen because all disks are sata-3 except 1 SSD which is sata-2?

You are saying that something changes between each boot, but only giving one
example so that we cannot see the change.  That is not particularly helpful.

The output above is a bit odd, but I think it is simply that the devices are
all being examined in parallel so the per-device messages are being mingled
together.
Certainly 'sdd1' is on 'sdd', not no 'sde' as the message seems to show.

NeilBrown
