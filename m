From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH 1/4] raid5-ppl: use a single mempool for ppl_io_unit and
 header_page
Date: Tue, 11 Apr 2017 10:28:55 +0200
Message-ID: <87fd9082-46bb-0836-7882-f0f572904549@intel.com>
References: <20170404111358.14829-1-artur.paszkiewicz@intel.com>
 <20170404111358.14829-2-artur.paszkiewicz@intel.com>
 <20170410190948.v33qgv63r423zfbb@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170410190948.v33qgv63r423zfbb@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, songliubraving@fb.com
List-Id: linux-raid.ids

On 04/10/2017 09:09 PM, Shaohua Li wrote:
>> +static void *ppl_io_pool_alloc(gfp_t gfp_mask, void *pool_data)
>> +{
>> +	struct kmem_cache *kc = pool_data;
>> +	struct ppl_io_unit *io;
>> +
>> +	io = kmem_cache_alloc(kc, gfp_mask);
>> +	if (!io)
>> +		return NULL;
>> +
>> +	io->header_page = alloc_page(gfp_mask);
>> +	if (!io->header_page) {
>> +		kmem_cache_free(kc, io);
>> +		return NULL;
>> +	}
>> +
>> +	return io;
> 
> Maybe directly use GFP_NOWAIT here, we don't use other gfp

Do you mean ignore the gfp_mask parameter? I don't think we should do
that. It is provided by the mempool implementation. We only use
GFP_NOWAIT for explicit allocations, but GFP_KERNEL is used for
allocating initial items in mempool_create().

>> +}
>> +
>> +static void ppl_io_pool_free(void *element, void *pool_data)
>> +{
>> +	struct kmem_cache *kc = pool_data;
>> +	struct ppl_io_unit *io = element;
>> +
>> +	__free_page(io->header_page);
>> +	kmem_cache_free(kc, io);
>> +}
>> +
>>  static struct ppl_io_unit *ppl_new_iounit(struct ppl_log *log,
>>  					  struct stripe_head *sh)
>>  {
>> @@ -202,18 +228,19 @@ static struct ppl_io_unit *ppl_new_iounit(struct ppl_log *log,
>>  	struct ppl_io_unit *io;
>>  	struct ppl_header *pplhdr;
>>  
>> -	io = mempool_alloc(ppl_conf->io_pool, GFP_ATOMIC);
>> +	io = mempool_alloc(ppl_conf->io_pool, GFP_NOWAIT);
>>  	if (!io)
>>  		return NULL;
>>  
>> -	memset(io, 0, sizeof(*io));
>>  	io->log = log;
>> +	io->entries_count = 0;
>> +	io->pp_size = 0;
>> +	io->submitted = false;
> 
> I'd suggest moving the memset to ppl_io_pool_alloc. Don't think we need to
> optimize to avoid setting header_page. And doing memset is less error prone,
> for example adding new fields.

OK, I'll change this and resend.

Thanks,
Artur
