From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH] Create: don't default to bitmap=internal when it is not
 supported
Date: Wed, 30 Apr 2014 13:34:31 +0200
Message-ID: <5360DFC7.2040906@intel.com>
References: <1397548904-31199-1-git-send-email-artur.paszkiewicz@intel.com> <20140428141922.02c361eb@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140428141922.02c361eb@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/28/2014 06:19 AM, NeilBrown wrote:
> On Tue, 15 Apr 2014 10:01:44 +0200 Artur Paszkiewicz
> <artur.paszkiewicz@intel.com> wrote:
> 
>> For large arrays (component size > 100GB) if write-intent bitmap is not
>> enabled, then it is set by default to "internal", even if the metadata
>> format does support internal bitmaps, which causes Create to fail.
>>
>> This patch adds checking if add_internal_bitmap is set in the
>> superswitch before setting bitmap_file to "internal".
>>
>> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
>> ---
>>  Create.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/Create.c b/Create.c
>> index e42627c..602f79c 100644
>> --- a/Create.c
>> +++ b/Create.c
>> @@ -509,6 +509,7 @@ int Create(struct supertype *st, char *mddev,
>>  
>>  	if (!s->bitmap_file &&
>>  	    s->level >= 1 &&
>> +	    st->ss->add_internal_bitmap &&
>>  	    (s->write_behind || s->size > 100*1024*1024ULL)) {
>>  		if (c->verbose > 0)
>>  			pr_err("automatically enabling write-intent bitmap on large array\n");
> 
> Applied (at last:-)
> 
> Thanks,
> NeilBrown

Thanks, but it seems it is not applied yet. I don't see it in the
repository.

Artur

