From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: [PATCH 4/4] md-cluster: re-add
Date: Fri, 10 Apr 2015 08:37:13 -0500
Message-ID: <5527D209.1020900@suse.de>
References: <20150408192414.GA9693@shrek.lan> <55279B26.1090402@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55279B26.1090402@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <GQJiang@suse.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 04/10/2015 04:43 AM, Guoqing Jiang wrote:
> Hi Goldwyn,
>> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
>> index d036c83..afffbee 100644
>> --- a/drivers/md/md-cluster.c
>> +++ b/drivers/md/md-cluster.c
>> @@ -50,6 +50,7 @@ struct md_cluster_info {
>>   	/* dlm lock space and resources for clustered raid. */
>>   	dlm_lockspace_t *lockspace;
>>   	int slot_number;
>> +	int total_slots;
>>
> There are two "nodes"  in bitmap_info and bitmap_super_t, is it possible
> to use
> the existed nodes? Instead of introduce a new member in md_cluster_info.

Yes, incorporated. Thanks.

-- 
Goldwyn
