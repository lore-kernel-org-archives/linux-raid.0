From: Guoqing Jiang <gqJiang@suse.com>
Subject: Re: [PATCH 1/2] Safeguard against writing to an active device of
 another node
Date: Tue, 04 Aug 2015 18:23:34 +0800
Message-ID: <55C092A6.5040202@suse.com>
References: <1438601519-17919-1-git-send-email-gqjiang@suse.com> <55BF570A.6050403@suse.com> <55C08E5C.5090604@suse.com> <55C0918A.7010808@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55C0918A.7010808@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>, neilb@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Adam Goryachev wrote:
> On 04/08/15 20:05, Guoqing Jiang wrote:
>   
>> Hi Goldwyn,
>>
>> Thanks for review.
>>
>> Goldwyn Rodrigues wrote:
>>     
>>>> +    set_dlm_hookers(); /* get dlm funcs from libdlm_lt.so.3 */
>>>> +
>>>>         
>>> Universal Comment: Let call it set_dlm_hooks as opposed to hookers.
>>>
>>>       
>> Not sure I understood correctly, the second patch used set_hookers to
>> call set_dlm_hookers.
>>     
>
> I think Neil meant to ask you to please do a global s/hookers/hooks/
> because hooker has a particular meaning in english which is different to
> what you intended.
> http://www.urbandictionary.com/define.php?term=hooker
>
> Hope that helps.
>   
Got it, thanks for the website, will change it.

Thanks,
Guoqing


