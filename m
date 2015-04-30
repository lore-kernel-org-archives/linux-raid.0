From: Guoqing Jiang <jgq516@gmail.com>
Subject: Re: [PATCH 09/10] mdadm: change the num of cluster node
Date: Thu, 30 Apr 2015 11:34:05 +0800
Message-ID: <5541A2AD.3030506@gmail.com>
References: <1429860641-5839-1-git-send-email-gqjiang@suse.com>	<1429860641-5839-10-git-send-email-gqjiang@suse.com> <20150429115151.0763e980@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150429115151.0763e980@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: gqjiang@suse.com, linux-raid@vger.kernel.org, rgoldwyn@suse.de
List-Id: linux-raid.ids

NeilBrown wrote:
> On Fri, 24 Apr 2015 15:30:40 +0800 gqjiang@suse.com wrote:
>
>   
>> From: Guoqing Jiang <gqjiang@suse.com>
>>
>> This extends nodes option for assemble mode, make the num of
>> cluster node could be change by user.
>>
>> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
>> ---
>>  Assemble.c | 4 ++++
>>  ReadMe.c   | 2 +-
>>  mdadm.c    | 3 +++
>>  mdadm.h    | 1 +
>>  super1.c   | 6 ++++++
>>  5 files changed, 15 insertions(+), 1 deletion(-)
>>
>> diff --git a/Assemble.c b/Assemble.c
>> index e1b846c..22042a9 100644
>> --- a/Assemble.c
>> +++ b/Assemble.c
>> @@ -649,6 +649,10 @@ static int load_devices(struct devs *devices, char *devmap,
>>  							    devname, 0, 0, c->homecluster);
>>  				tst->ss->write_bitmap(tst, dfd, NameUpdate);
>>  			}
>> +			if (strcmp(c->update, "nodes") == 0) {
>> +				tst->nodes = c->nodes;
>> +				tst->ss->write_bitmap(tst, dfd, NodeNumUpdate);
>> +			}
>>     
>
> Doesn't there need to be some test that there is enough free space on all
> devices to store the extra bitmaps (when nodes is increasing)??
>
>   
Agree, could you pls elaborate more about the test? I guess the test
need to be run
before write_bitmap1call the awrite(&afd, buf, n).

Thanks,
Guoqing
