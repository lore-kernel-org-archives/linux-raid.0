From: Richard <richard@sauce.co.nz>
Subject: Re: recovering from a controller failure
Date: Sun, 30 May 2010 12:28:13 +1200
Message-ID: <4C01B11D.1040409@sauce.co.nz>
References: <20100529190751.GM2167@flews.lairds.us> <4C01849D.8080101@sauce.co.nz> <20100529213610.GC7501@flews.lairds.us> <4C01896A.7030705@sauce.co.nz> <20100529214532.GD7501@flews.lairds.us> <4C018C22.2090503@sauce.co.nz> <20100530001504.GE7501@flews.lairds.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100530001504.GE7501@flews.lairds.us>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Kyler Laird wrote:

> So...how do I get the UUIDs?  I tried blkid and got this.
> 	http://lairds.us/temp/ucmeng_md/uuids
> Those UUIDs are far from unique.

How about mdadm --examine /dev/sdX

where sdX is a compont of the failed array. If the drive was partioned
prior to being md'ed you will need that partition eg sda1.

Regards,

Richard

