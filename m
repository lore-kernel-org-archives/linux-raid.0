From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: BUG: possible array corruption when adding a component to a degraded
 raid5 (possibly other levels too)
Date: Mon, 28 Jan 2008 12:54:23 +0100
Message-ID: <479DC26F.1030008@rabbit.us>
References: <479DA8E6.6040209@rabbit.us> <18333.48601.218262.452373@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18333.48601.218262.452373@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Monday January 28, rabbit+list@rabbit.us wrote:
>> Hello,
>>
>> It seems that mdadm/md do not perform proper sanity checks before adding a 
>> component to a degraded array. If the size of the new component is just right, 
>> the superblock information will overlap with the data area. This will happen 
>> without any error indications in the syslog or otherwise.
> 
> I thought I fixed that.... What versions of Linux kernel and mdadm are
> you using for your tests?
> 

Linux is 2.6.23.14 with everything md related compiled in (no modules)
mdadm - v2.6.4 - 19th October 2007 (latest in debian/sid)

Peter
