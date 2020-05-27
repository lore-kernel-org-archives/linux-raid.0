From: "John Stoffel" <john@stoffel.org>
Subject: Re: [PATCH v3 01/11] md/raid5: add CONFIG_MD_RAID456_STRIPE_SHIFT to
 set STRIPE_SIZE
Date: Wed, 27 May 2020 19:30:22 -0400
Message-ID: <24270.63502.994707.335011@quad.stoffel.home>
References: <20200527131933.34400-1-yuyufen@huawei.com>
        <20200527131933.34400-2-yuyufen@huawei.com>
        <5fe381f9-e3ce-c2f7-dfac-9f852316b38f@cloud.ionos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5fe381f9-e3ce-c2f7-dfac-9f852316b38f@cloud.ionos.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Cc: Yufen Yu <yuyufen@huawei.com>, song@kernel.org, linux-raid@vger.kernel.org, neilb@suse.com, colyli@suse.de, xni@redhat.com, houtao1@huawei.com
List-Id: linux-raid.ids

>>>>> "Guoqing" == Guoqing Jiang <guoqing.jiang@cloud.ionos.com> writes:

Guoqing> Hi,
Guoqing> On 5/27/20 3:19 PM, Yufen Yu wrote:
>> +config MD_RAID456_STRIPE_SHIFT
>> +	int "RAID4/RAID5/RAID6 stripe size shift"
>> +	default "1"
>> +	depends on MD_RAID456
>> +	help
>> +	  When set the value as 'N', stripe size will be set as 'N << 9',
>> +	  which is a multiple of 4KB.

Guoqing> If 'N  << 9', then seems you are convert it to sector, do you actually 
Guoqing> mean 'N << 12'?

Aren't there helpers that can be used here instead of semi-magic
numbers?  At the least, the 9 and 12 should be #defines with good
names, or using the standard PAGE_SIZE and other defines.  

>> +
>> +	  The default value is 1, that means the default stripe size is
>> +	  4096(1 << 9). Just setting as a bigger value when PAGE_SIZE is
>> +	  bigger than 4096. In that case, you can set it as 2(8KB),
>> +	  4(16K), 16(64K).

Guoqing> So with the above description, the algorithm should be 2 << 12 = 8KB and 
Guoqing> so on.

>> +
>> +	  When you try to set a big value, likely 16 on arm64 with 64KB
>> +	  PAGE_SIZE, that means, you know size of each io that issued to
>> +	  raid device is more than 4096. Otherwise just use default value.
>> +

Cheers,
John
