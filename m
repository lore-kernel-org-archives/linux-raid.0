From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH 0/2] md: Add support for Multiple PPLs
Date: Mon, 28 Aug 2017 09:44:20 +0200
Message-ID: <110e9aa4-4215-7f29-dd05-7d00dde6da9b@intel.com>
References: <20170816151346.23382-1-pawel.baldysiak@intel.com>
 <20170817180331.baxoqhgbqi5q6fvx@kernel.org>
 <4e72946d-3bdc-8a69-0b44-591570aae3a2@intel.com>
 <20170821161426.of5z62r45unlh2en@kernel.org>
 <c9d77b2c-f1ab-bcce-5441-5b8fa9bede13@intel.com>
 <20170825215300.xgkdklgi4lxvhxrx@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170825215300.xgkdklgi4lxvhxrx@kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Pawel Baldysiak <pawel.baldysiak@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/25/2017 11:53 PM, Shaohua Li wrote:
> On Fri, Aug 25, 2017 at 10:02:07PM +0200, Pawel Baldysiak wrote:
>> On 08/21/2017 06:14 PM, Shaohua Li wrote> Can you elaborate more?
>>>
>> Storage presented to the host may have a RAID on the back-end. For NVMe
>> SSDs, the 1.3 specification provided a field to advertise chunk
>> boundaries: Identify Namespace NOIOB. We need to span the entire stripe
>> to utilize the total available capacity, otherwise we'll repeatedly
>> write to only a subset, increasing write amplification factor. The new
>> PPL approach is designed to access the full capacity.
> 
> Ok, this makes sense. The 1MB area looks arbitrary though. What if the
> chunk is 2MB? Could we make it configurable?

Actually, it is configurable by 'ppl_size' which comes from mdadm. The
1MB is what the current RSTe standard defines but it will be possible to
change it without affecting the kernel.

Thanks,
Artur
