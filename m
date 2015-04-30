From: Guoqing Jiang <gqJiang@suse.com>
Subject: Re: [PATCH 09/10] mdadm: change the num of cluster node
Date: Thu, 30 Apr 2015 18:04:58 +0800
Message-ID: <5541FE4A.7010504@suse.com>
References: <1429860641-5839-1-git-send-email-gqjiang@suse.com>	<1429860641-5839-10-git-send-email-gqjiang@suse.com>	<20150429115151.0763e980@notabene.brown>	<5541A2AD.3030506@gmail.com> <20150430164742.6cf78f6c@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150430164742.6cf78f6c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Guoqing Jiang <jgq516@gmail.com>, linux-raid@vger.kernel.org, rgoldwyn@suse.de
List-Id: linux-raid.ids

NeilBrown wrote:
> On Thu, 30 Apr 2015 11:34:05 +0800 Guoqing Jiang <jgq516@gmail.com> wrote:
>
>   
>> NeilBrown wrote:
>>     
>>> On Fri, 24 Apr 2015 15:30:40 +0800 gqjiang@suse.com wrote:
>>>
>>>   
>>>       
>>>> From: Guoqing Jiang <gqjiang@suse.com>
>>>>
>>>> This extends nodes option for assemble mode, make the num of
>>>> cluster node could be change by user.
>>>>
>>>> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
>>>> ---
>>>>  Assemble.c | 4 ++++
>>>>  ReadMe.c   | 2 +-
>>>>  mdadm.c    | 3 +++
>>>>  mdadm.h    | 1 +
>>>>  super1.c   | 6 ++++++
>>>>  5 files changed, 15 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/Assemble.c b/Assemble.c
>>>> index e1b846c..22042a9 100644
>>>> --- a/Assemble.c
>>>> +++ b/Assemble.c
>>>> @@ -649,6 +649,10 @@ static int load_devices(struct devs *devices, char *devmap,
>>>>  							    devname, 0, 0, c->homecluster);
>>>>  				tst->ss->write_bitmap(tst, dfd, NameUpdate);
>>>>  			}
>>>> +			if (strcmp(c->update, "nodes") == 0) {
>>>> +				tst->nodes = c->nodes;
>>>> +				tst->ss->write_bitmap(tst, dfd, NodeNumUpdate);
>>>> +			}
>>>>     
>>>>         
>>> Doesn't there need to be some test that there is enough free space on all
>>> devices to store the extra bitmaps (when nodes is increasing)??
>>>
>>>   
>>>       
>> Agree, could you pls elaborate more about the test? I guess the test
>> need to be run
>> before write_bitmap1call the awrite(&afd, buf, n).
>>     
>
> Normally we don't increase the size of a bitmap while it is alive.
> When an array is reshaped, bitmap_resize in the kernel actually changes the
> bitmap chunk size if necessary so that the bitmap will fit in the available
> space. 
> To make the bitmap larger, the only current approach is to delete the bitmap
> and add a new one.  This is handled by add_internal_bitmap1 in mdadm.
> So make the bitmap bigger you will need to perform similar calculations taht
> add_internal_bitmap1 performs, though instead of choosing a size or
> chunksize, you see need to check if the space is sufficient.
>
>   
Thanks a lot for the detailed infos. Seems the size of bitmap is one of
4k, 64k and
128k (per choose_bm_space), is it ok to call choose_bm_space to get
current bitmap
size? And since the size of each bitmap can be get by bitmap_bits, then
we can
know the current size of bitmap is enough or not by something like

int room = choose_bm_space(__le64_to_cpu(sb->size));
int total_bm_size_byte = room / 2 * 1024;
if (total_bm_size_byte > nodenums * bitmap_bits() / 8) {
/* enough space */
continue the write_bitmap
} else {
/* no enough space*/
Just warn it.
}

I think we should not allocate more space for extra nodes if current
size is not bigger
than required, otherwise it is possible to violate the meaning of
choose_bm_space.
Please correct me if I misunderstood something.

Thanks,
Guoqing

> Hope that helps,
> NeilBrown
>   

