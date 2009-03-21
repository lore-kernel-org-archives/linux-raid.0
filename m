From: Ilya Yanok <yanok@emcraft.com>
Subject: Re: [PATCH 06/13] async_tx: add support for asynchronous GF multiplication
Date: Sat, 21 Mar 2009 23:05:01 +0300
Message-ID: <49C5486D.9020103@emcraft.com>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com> <20090318192046.20375.89854.stgit@dwillia2-linux.ch.intel.com> <49C26D91.10804@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49C26D91.10804@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <h.peter.anvin@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, neilb@suse.de, maciej.sosnowski@intel.com, Yuri Tikhonov <yur@emcraft.com>
List-Id: linux-raid.ids

Hi H.Peter,

H. Peter Anvin wrote:
>> + * @scfs: array of source coefficients used in GF-multiplication
>>     
>
> Array of source coefficients?  Are you doing a vector-vector
> multiplication here?
>
> Given this code:
>
>   
>> 	for (d = 0; d < len; d++) {
>> +		wq = wp = ptrs[0][d];
>> +		for (z = 1; z < src_cnt; z++) {
>> +			wd = ptrs[z][d];
>> +			wp ^= wd;
>> +			wq ^= raid6_gfmul[scfs[z]][wd];
>> +		}
>>     
>
> ... it kinds of looks like that.
>
> This is really quite expensive!  The whole point of the restore code
> that exists is that we never do a two-dimensional lookup, instead
> caching a pointer to the multiplication table that we intend to use,
> because the RAID-6 code only ever contains scalar-vector multiplications.
>
> I really don't get this, and I think it's broken.
>   
Well, that code IS broken. Dan, I think you over-optimized this part.
Have you ever tested this code path? Besides of doing two-dimensional
lookup at every step it ignores scfs[0] completely so if it's not equal
to one the result is wrong.

Regards, Ilya.

