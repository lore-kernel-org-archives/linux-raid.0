From: Martin Wilck <mwilck@arcor.de>
Subject: Re: [PATCH 07/27] DDF: find_vdcr: account for secondary RAID level
Date: Mon, 08 Jul 2013 23:03:39 +0200
Message-ID: <51DB292B.7000208@arcor.de>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>	<1372883287-8859-8-git-send-email-mwilck@arcor.de> <20130708161652.11d1c47f@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130708161652.11d1c47f@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/08/2013 08:16 AM, NeilBrown wrote:

>> -static struct vd_config *find_vdcr(struct ddf_super *ddf, unsigned int inst)
>> +static int find_index_in_bvd(const struct ddf_super *ddf,
>> +			     const struct vd_config *conf, unsigned int n,
>> +			     unsigned int *n_bvd)
>> +{
>> +	/*
>> +	 * Find the index of the n-th valid physical disk in this BVD
>> +	 */
>> +	unsigned int i, j;
>> +	for (i = 0, j = 0; i < ddf->mppe &&
>> +		     j < __be16_to_cpu(conf->prim_elmnt_count); i++) {
>> +		if (conf->phys_refnum[i] != 0xffffffff) {
> 
> Should that 0xffffffff be DDF_NOTFOUND?

I'd say rather not. Currently the DDF code is using 0xffffffff
explicitly for "invalid refnums" (value from the spec) in several
places. DDF_NOTFOUND is used by my code as a return code for functions
returning "unsigned int". It's similar but not quite the same.

The readability DDF code could be improved by using a symbolic name like
DDF_INVALID_REFNUM = 0xffffffff, and possibly using a different numeric
value for DDF_NOTFOUND. But that's the kind of stuff that I've avoided
so far.

> 
> (I glazed over reading the rest of this patch .. sorry.  Maybe I'll try again
> another day)

Thanks for reading it.
Martin
