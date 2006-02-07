From: Farkas Levente <lfarkas@bppiac.hu>
Subject: Re: with the latest mdadm
Date: Tue, 07 Feb 2006 16:35:23 +0100
Message-ID: <43E8BE3B.5010301@bppiac.hu>
References: <43E86468.8030508@bppiac.hu> <17384.26402.724978.284042@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17384.26402.724978.284042@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Tuesday February 7, lfarkas@bppiac.hu wrote:
> 
>>hi,
>>with the latest mdadm-2.3.1 we've got the following message:
>>-------------------------------------
>>md: md4: sync done.
>>RAID1 conf printout:
>> --- wd:2 rd:2
>> disk 0, wo:0, o:1, dev:sda2
>> disk 1, wo:0, o:1, dev:sdb2
>>md: mdadm(pid 8003) used obsolete MD ioctl, upgrade your software to use
>>new ictls.
>>-------------------------------------
>>this is just a warning or some kind of problem with mdadm?
> 
> 
> This is with a 2.4 kernel, isn't it.

no. it's rhel latest kernel 2.6.9-22.0.2.ELsmp.

> The md driver is incorrectly interpreting an ioctl that it doesn't
> recognise as an obsolete ioctl.  In fact it is a new ioctl that 2.4
> doesn't know about (I suspect it is GET_BITMAP_FILE).
> 
> The message should probably be removed from 2.4, but as 2.4 is in
> deep-maintenance mode, I suspect that is unlikely....

it's 2.6:-(

-- 
  Levente                               "Si vis pacem para bellum!"
