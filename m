From: Guoqing Jiang <jgq516@gmail.com>
Subject: Re: [PATCH 05/10] Add a new clustered disk
Date: Thu, 30 Apr 2015 11:20:27 +0800
Message-ID: <55419F7B.3070502@gmail.com>
References: <1429860641-5839-1-git-send-email-gqjiang@suse.com>	<1429860641-5839-6-git-send-email-gqjiang@suse.com> <20150429114532.568d58bd@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150429114532.568d58bd@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: gqjiang@suse.com, linux-raid@vger.kernel.org, rgoldwyn@suse.de
List-Id: linux-raid.ids

NeilBrown wrote:
> On Fri, 24 Apr 2015 15:30:36 +0800 gqjiang@suse.com wrote:
>
>   
>> From: Guoqing Jiang <gqjiang@suse.com>
>>
>> A clustered disk is added by the traditional --add sequence.
>> However, other nodes need to acknowledge that they can "see"
>> the device. This is done by --cluster-confirm:
>>
>> --cluster-confirm Y:/dev/whatever (if disk is found)
>> or
>> --cluster-confirm Y:missing (if disk is not found)
>>
>> The node initiating the --add, has the disk state tagged with
>> MD_DISK_CLUSTER_ADD and the one confirming tag the disk with
>> MD_DISK_CANDIDATE.
>>     
>
> You haven't explained 'Y' here.  It looks like it means 'Yes', but it doesn't.
>
>
>   
Right, actually 'Y' stands for the slot, will modify it.
>> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
>> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
>>
>>     
[snip]
>>  
>> +int parse_cluster_confirm_arg(char *input, char **devname, int *slot)
>> +{
>> +	char *dev;
>> +	*slot = strtoul(input, &dev, 10);
>> +	if (dev[0] == ':')
>> +		*devname = dev+1;
>> +	else
>> +		return -1;
>> +	return 0;
>> +}
>>     
>
> The logic here hurts my brain :-(
>
>  *slot = strtoul(input, &dev, 10);
>  if (dev == input || dev[0] != ':')
>      return -1;
>  *devname = dev+1;
>  return 0;
>
>   
Thanks for above, :)

Regards,
Guoqing
