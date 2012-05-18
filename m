From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Creating a 3-disk RAID6 array
Date: Fri, 18 May 2012 00:30:47 -0700
Message-ID: <4FB5FAA7.4090401@zytor.com>
References: <4FB4534A.5070608@volatilevoid.net> <20120517113817.7faf9c1e@notabene.brown> <4FB4FAA9.7000100@hesbynett.no> <4FB50573.6020604@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FB50573.6020604@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: David Brown <david.brown@hesbynett.no>, NeilBrown <neilb@suse.de>, Oliver Martin <oliver@volatilevoid.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/17/2012 07:04 AM, John Robinson wrote:
> On 17/05/2012 14:18, David Brown wrote:
> [...]
>> Theoretically, a 3-disk RAID6 is like a 2-disk RAID5 or a 1-disk RAID1 -
> [...]
>> I can't think of any good reason for it /not/ to support 3-disk
>> RAID6, as there is nothing in the algorithms to hinder it.
> 
> I've a vague recollection of Peter Anvin saying the implementation is
> optimised in such a way that it won't work.
> 

Yes, it would have required introducing some odd special cases.  A
3-disk RAID-6 is bitwise identical to a 3-disk RAID-1, so if Neil wants
to he could add "instant reshaping" support in mdadm (add a disk to a
3-disk RAID-1 turning it into a 4-disk RAID-6; and similar for 2-disk
RAID-1 into 3-disk RAID-5.)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

