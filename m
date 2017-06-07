From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH] mdadm: Send version text to stdout rather than stderr
Date: Wed, 7 Jun 2017 11:21:50 -0400
Message-ID: <321080ab-7d03-ddc0-1685-ae318d505238@gmail.com>
References: <1496735987-10653-1-git-send-email-zlliu@suse.com>
 <877f0od124.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <877f0od124.fsf@notabene.neil.brown.name>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Zhilong Liu <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/06/2017 09:44 PM, NeilBrown wrote:
> On Tue, Jun 06 2017, Zhilong Liu wrote:
> 
>> This helps with piping to a paper.
> 
> It might help you, but it is an API change and could cause problems for
> others.
> 
> Some programs, such as "mount -V", send version info to stdout.
> Others, like "gcc -v", send it to stderr.
> There is no uniform standard, it is best to leave the behavior
> unchanged.
> 
> If you need to capture the output use
>     mdadm -V |& ...
> or
>     mdadm -V 2>&1
> 
> or similar.
> 
> NeilBrtown

I agree with mr Brtown here :)

Changing the API is a big issue. We need to avoid this unless it is 
absolutely necessary, so we don't break things for people trying to run 
newer mdadm on older distros or those relying on third party scripts.

Jes
