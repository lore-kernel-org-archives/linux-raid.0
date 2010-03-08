From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Weird Issue with raid 5+0
Date: Mon, 08 Mar 2010 15:14:39 -0500
Message-ID: <4B955AAF.3060809@tmr.com>
References: <31e44a111002202033m4a9dfba9yf8aef62b8b39933a@mail.gmail.com>	<20100221164805.5bdc2d60@notabene.brown>	<31e44a111002202326x407c814dsaa60e51a8a0ff049@mail.gmail.com>	<20100221191640.39b68b01@notabene.brown> <20100308165021.6529fe6d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100308165021.6529fe6d@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Sun, 21 Feb 2010 19:16:40 +1100
> Neil Brown <neilb@suse.de> wrote:
>
>   
>> On Sun, 21 Feb 2010 02:26:42 -0500
>> chris <tknchris@gmail.com> wrote:
>>
>>     
>>> That is exactly what I didn't want to hear :( I am running
>>> 2.6.26-2-xen-amd64. Are you sure its a kernel problem and nothing to
>>> do with my chunk/block sizes? If this is a bug what versions are
>>> affected, I'll build a new domU kernel and see if I can get it working
>>> there.
>>>
>>> - chris
>>>       
>> I'm absolutely sure it is a kernel bug.
>>     
>
> And I think I now know what the bug is.
>
> A patch was recently posted to dm-devel which I think addresses exactly this
> problem.
>
> I reproduce it below.
>
> NeilBrown
>
> -------------------
> If the lower device exposes a merge_bvec_fn,
> dm_set_device_limits() restricts max_sectors
> to PAGE_SIZE "just to be safe".
>
> This is not sufficient, however.
>
> If someone uses bio_add_page() to add 8 disjunct 512 byte partial
> pages to a bio, it would succeed, but could still cross a border
> of whatever restrictions are below us (e.g. raid10 stripe boundary).
> An attempted bio_split() would not succeed, because bi_vcnt is 8.
>
> One example that triggered this frequently is the xen io layer.
>   

And I bet this hasn't been fix in RHEL yet... I believe we saw this a 
while ago.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

