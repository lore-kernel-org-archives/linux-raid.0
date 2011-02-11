From: Iordan Iordanov <iordan@cdf.toronto.edu>
Subject: Re: raid related kernel hang in 2.6.36
Date: Fri, 11 Feb 2011 10:52:53 -0500
Message-ID: <4D555B55.1080906@cdf.toronto.edu>
References: <4CED17A4.7050604@perabytes.com>	 <AANLkTinfbPDQhmKRVibUv+Rm50wDkGizeYLGXQqY_xOu@mail.gmail.com>	 <4CED226D.6090602@perabytes.com>  <20101125070155.277a0d62@notabene.brown> <1290654763.5416.31.camel@dujun.perabytes.com> <4D541228.2090700@cdf.toronto.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D541228.2090700@cdf.toronto.edu>
Sender: linux-raid-owner@vger.kernel.org
To: dujun <dujun@perabytes.com>
Cc: Neil Brown <neilb@suse.de>, =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>, linux-raid@vger.kernel.org, CDF Admin <admin@cdf.toronto.edu>
List-Id: linux-raid.ids

Hi Neil,

As requested, here is more background.

On 02/10/11 11:28, Iordan Iordanov wrote:
> We are currently using 2.6.36 on a production machine running mdadm

Our distribution is Debian Lenny. We have 10 3-way RAID1 mirrors (30 1TB 
disks) striped together with LVM in one large volume group, out of which 
we create logical drives. The actual drives are iscsi targets we import 
from separate machines. The system is serving about 3500 active (not 
logged-in at the same time) accounts to our department. Also, we have a 
"development" platform, with no users using it, also with lvm, mdadm, 
and iscsi, but with 5 disks instead of 30. The development platform was 
sitting idle the whole time.

> this morning we experienced a very similar issue, but we didn't have the
> LOCKUP_DETECTOR config options set, so there was absolutely no output.

What I mean by a similar issue is that our development platform hung 
without any output in the logs and was completely unresponsive on Feb 7, 
and our production system hung and was completely unresponsive, save for 
pings, on Feb 10. I don't know if the two hangs were caused by the same 
issue.

I thought that the potential lock-up reported by Du Jun was acknowledged 
as reality. I was wrong. We will recompile a longterm kernel (this time) 
with the LOCKUP_DETECTOR flags set, and will wait to see if the issue 
recurs. Do you have any suggestions to us?

Many thanks,
Iordan
