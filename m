From: Richard <richard@sauce.co.nz>
Subject: Re: recovering from a controller failure
Date: Sun, 30 May 2010 12:54:20 +1200
Message-ID: <4C01B73C.2050304@sauce.co.nz>
References: <20100529190751.GM2167@flews.lairds.us> <4C01849D.8080101@sauce.co.nz> <20100529213610.GC7501@flews.lairds.us> <4C01896A.7030705@sauce.co.nz> <20100529214532.GD7501@flews.lairds.us> <4C018C22.2090503@sauce.co.nz> <20100530001504.GE7501@flews.lairds.us> <4C01B11D.1040409@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C01B11D.1040409@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Richard wrote:
> Kyler Laird wrote:
> 
>> So...how do I get the UUIDs?  I tried blkid and got this.
>>     http://lairds.us/temp/ucmeng_md/uuids
>> Those UUIDs are far from unique.

Sorry, I just checked the link showing the blkid's.

These are almost certainly correct and they are onlu unique between arrays.

This is the whole point - all members of an array have the same UUID so 
that mdadm knows which devices are part of the same array.

UUID's should always be part of an mdadm.conf so that thewre can be no 
ambiguity.

Regards,

Richard
