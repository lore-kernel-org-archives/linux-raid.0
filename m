From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: 95a05b3 broke mdadm --add on my superblock 1.0 array
Date: Wed, 21 Sep 2016 02:45:10 -0400
Message-ID: <57E22C76.6040600@suse.com>
References: <20160919163229.uccdr6bxiwetqvwo@derobert.net>
 <57E0CB6C.2040000@suse.com>
 <63417807-ae42-ed60-8c8b-3b699994c34c@derobert.net>
 <57E10311.7040601@suse.com>
 <1931152f-f5bc-bc1f-76a8-91921ffc1bed@derobert.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1931152f-f5bc-bc1f-76a8-91921ffc1bed@derobert.net>
Sender: linux-raid-owner@vger.kernel.org
To: Anthony DeRobertis <anthony@derobert.net>, linux-raid@vger.kernel.org, 837964@bugs.debian.org
List-Id: linux-raid.ids



On 09/20/2016 02:31 PM, Anthony DeRobertis wrote:
> Sorry for the amount of emails I'm sending, but I noticed something 
> that's probably important. I'm also appending some gdb log from 
> tracing through the function (trying to answer why it's doing cluster 
> mode stuff at all).
>
> While tracing through, I noticed that *before* the write-bitmap loop, 
> mdadm -E considers the superblock valid. That agrees with what I saw 
> from strace, I suppose. To my first glance, it figures out how much to 
> write by calling this function:
>
> static unsigned int calc_bitmap_size(bitmap_super_t *bms, unsigned int 
> boundary)
> {
>     unsigned long long bits, bytes;
>
>     bits = __le64_to_cpu(bms->sync_size) / 
> (__le32_to_cpu(bms->chunksize)>>9);
>     bytes = (bits+7) >> 3;
>     bytes += sizeof(bitmap_super_t);
>     bytes = ROUND_UP(bytes, boundary);
>
>     return bytes;
> }
>
> That code looked familiar, and I figured out where—it's also in 
> 95a05b37e8eb2bc0803b1a0298fce6adc60eff16, the commit that I found 
> originally broke it. But that commit is making a change to it: it 
> changed the ROUND_UP line from 512 to 4096 (and from the gdb trace, 
> boundary==4096).
>
> I tested changing that line to "bytes = ROUND_UP(bytes, 512);", and it 
> works. Adds the new disk to the array and produces no warnings or errors.

I think it is is a coincidence that above change works,  4a3d29e commit made
the change but it didn't change the logic at all. Also seems the problem 
is not
related to md-cluster code as your gdb debug shows it run into below part
because the version is 4.

/* no need to change bms->nodes for other bitmap types */

Thanks,
Guoqing
