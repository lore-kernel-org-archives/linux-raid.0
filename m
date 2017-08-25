From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: Re: [PATCH 0/2] md: Add support for Multiple PPLs
Date: Fri, 25 Aug 2017 22:02:07 +0200
Message-ID: <c9d77b2c-f1ab-bcce-5441-5b8fa9bede13@intel.com>
References: <20170816151346.23382-1-pawel.baldysiak@intel.com>
 <20170817180331.baxoqhgbqi5q6fvx@kernel.org>
 <4e72946d-3bdc-8a69-0b44-591570aae3a2@intel.com>
 <20170821161426.of5z62r45unlh2en@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170821161426.of5z62r45unlh2en@kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/21/2017 06:14 PM, Shaohua Li wrote> Can you elaborate more?
> 
Storage presented to the host may have a RAID on the back-end. For NVMe 
SSDs, the 1.3 specification provided a field to advertise chunk 
boundaries: Identify Namespace NOIOB. We need to span the entire stripe 
to utilize the total available capacity, otherwise we'll repeatedly 
write to only a subset, increasing write amplification factor. The new 
PPL approach is designed to access the full capacity.

Thanks
Pawel
