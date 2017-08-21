From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: Re: [PATCH 0/2] md: Add support for Multiple PPLs
Date: Mon, 21 Aug 2017 16:54:21 +0200
Message-ID: <4e72946d-3bdc-8a69-0b44-591570aae3a2@intel.com>
References: <20170816151346.23382-1-pawel.baldysiak@intel.com>
 <20170817180331.baxoqhgbqi5q6fvx@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170817180331.baxoqhgbqi5q6fvx@kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 08/17/2017 08:03 PM, Shaohua Li wrote:
> On Wed, Aug 16, 2017 at 05:13:44PM +0200, Pawel Baldysiak wrote:
>> Current Partial Parity Log implementation allows only single PPL to be
>> written to particular member drive. In such case PPL entry is
>> overwritten by every write as it's stored at the same sector of a drive.
>> Such approach is suboptimal for SSD drives as it leads to increased
>> write amplification factor due to write-after-write limitations.
>>
>> This patchset changes the implementation by extending PPL area to 1MB.
>> PPL is not stored at fixed location but multiple PPLs are written in a
>> circular buffer. There is at most one valid PPL at any time (latest
>> one). Recovery algorithm stays the same. The main benefits of this
>> approach are increased drive lifespan and in some cases improved
>> performance.
> 
> The patches look good. Is this in intel RST standard?

Hello,
Yes, this is a part of upcoming RSTe version.

> 
> I didn't get the point why this is helpful though. You mentioned reduce write
> amplification. Why does this reduce write amplification? As far as I know, SSD
> never does in-place write, write to the same sector or different sector has no
> difference.

Well, it depends on SSD drive and firmware implementation.

Thanks,
Pawel
