From: Luca Berra <bluca@comedia.it>
Subject: Re: Bitmaps & Kernel Versions
Date: Thu, 16 Mar 2006 00:43:33 +0100
Message-ID: <20060315234333.GC25405@percy.comedia.it>
References: <4417DA8B.3040306@unix-scripts.info> <17431.59281.909724.299333@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17431.59281.909724.299333@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Mar 15, 2006 at 09:08:17PM +1100, Neil Brown wrote:
>On Wednesday March 15, lcaron@unix-scripts.info wrote:
>> Hi,
>> 
>> I'm planning to use bitmaps on some of our RAID1 arrays.
>> 
>> I'm wondering how bitmaps are handeled by older kernels.
>> 
>> Eg: I create a raid array with a bitmap under a 2.6.15 kernel.
>> 
>> I now want to boot under 2.6.12, or even 2.4
>> 
>> 
>> Hos is it handeled?
>> Will it work even if this is my / partition?
>
>On older kernel will not notice the bitmap and will behave
>'normally'. 
>
strange,
last time i tried an older kernel would refuse to activate an md with a
bitmap on it.
I am far from home on a business trip and i don't have kernel-sources at
hand, but i seem to remember that the kernel was very strict on the
feature bitmap in the superblock.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
