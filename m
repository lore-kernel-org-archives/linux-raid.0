From: Guoqing Jiang <gqJiang@suse.com>
Subject: Re: [PATCH V2 01/11] Create n bitmaps for clustered mode
Date: Mon, 18 May 2015 10:21:00 +0800
Message-ID: <55594C8C.904@suse.com>
References: <1431075029-5484-1-git-send-email-gqjiang@suse.com>	<1431075029-5484-2-git-send-email-gqjiang@suse.com> <20150515154527.7751f765@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150515154527.7751f765@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.de
List-Id: linux-raid.ids

NeilBrown wrote:
>> diff --git a/mdadm.c b/mdadm.c
>> index 3e8c49b..bd9382e 100644
>> --- a/mdadm.c
>> +++ b/mdadm.c
>> @@ -1097,6 +1097,15 @@ int main(int argc, char *argv[])
>>  				s.bitmap_file = optarg;
>>  				continue;
>>  			}
>> +			if (strcmp(optarg, "clustered")== 0) {
>> +				s.bitmap_file = optarg;
>> +				/* Set the default number of cluster nodes
>> +				 * to 4 if not already set by user
>> +				 */
>> +				if (c.nodes < 1)
>> +					c.nodes = 4;
>> +				continue;
>> +			}
>>     
>
>
> Please make sure than mdadm compiles after each patch is applied.
> You don't defined that 'nodes' field until a later patch.
>
>   
Oops, I will fix it in next version.

Thanks,
Guoqing
> NeilBrown
>
>   

