From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: [PATCH 4/4] md-cluster: update document for raid10
Date: Mon, 30 Oct 2017 14:50:11 +0800
Message-ID: <59F6CBA3.1030801@suse.com>
References: <20171024071153.5275-1-gqjiang@suse.com>
 <20171024071153.5275-5-gqjiang@suse.com>
 <20171030054459.nntk6i2ntrejgqmr@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20171030054459.nntk6i2ntrejgqmr@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: shli@fb.com, linux-raid@vger.kernel.org, neilb@suse.com
List-Id: linux-raid.ids



On 10/30/2017 01:44 PM, Shaohua Li wrote:
> On Tue, Oct 24, 2017 at 03:11:53PM +0800, Guoqing Jiang wrote:
>> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
>> ---
>>   Documentation/md/md-cluster.txt | 3 ++-
>>   drivers/md/Kconfig              | 5 +++--
>>   drivers/md/md-cluster.c         | 2 +-
>>   3 files changed, 6 insertions(+), 4 deletions(-)
>>
>> diff --git a/Documentation/md/md-cluster.txt b/Documentation/md/md-cluster.txt
>> index 82ee51604e9a..e1055f105cf5 100644
>> --- a/Documentation/md/md-cluster.txt
>> +++ b/Documentation/md/md-cluster.txt
>> @@ -1,4 +1,5 @@
>> -The cluster MD is a shared-device RAID for a cluster.
>> +The cluster MD is a shared-device RAID for a cluster, it supports
>> +two levels: raid1 and raid10 (limited support).
>>   
>>   
>>   1. On-disk format
>> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
>> index 4a249ee86364..83b9362be09c 100644
>> --- a/drivers/md/Kconfig
>> +++ b/drivers/md/Kconfig
>> @@ -178,7 +178,7 @@ config MD_FAULTY
>>   
>>   
>>   config MD_CLUSTER
>> -	tristate "Cluster Support for MD (EXPERIMENTAL)"
>> +	tristate "Cluster Support for MD"
> Do we have confidence this is stable enough now?

We have enabled the feature for raid1 support since 12SP2, and it
also got heavily tested by our automation test and QA. So far, no
obvious problem happened, so I think it is time to remove the
  "EXPERIMENTIAL".

Thanks,
Guoqing

