From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: [PATCH 3/3] Safeguard against writing to an active device of
 another node
Date: Sat, 1 Aug 2015 10:54:48 -0500
Message-ID: <55BCEBC8.4040306@suse.de>
References: <1436172732-21021-1-git-send-email-gqjiang@suse.com>
 <1436172732-21021-3-git-send-email-gqjiang@suse.com>
 <20150729172853.33d44808@noble> <55B8ADE1.1060708@suse.com>
 <20150730080247.20f03d23@noble> <55B96474.6080604@suse.de>
 <55BCEABF.6060505@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55BCEABF.6060505@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, NeilBrown <neilb@suse.com>, Guoqing Jiang <gqJiang@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 08/01/2015 10:50 AM, Wols Lists wrote:
> On 30/07/15 00:40, Goldwyn Rodrigues wrote:
>>>
>>> I was wondering if we could make it a run-time dependency though .. a
>>> bit like get_cluster_name.  We can still do that later I guess.  I'm
>>> not really sure what is best at the moment.
>>>
>>
>>
>> Yes, I would second that: Making these functions a run-time dependency.
>> We should have the ability for it to work by just installing libdlm
>> (with the proper flags set), rather than recompiling the package for
>> cluster features.
>
> Or - maybe unlikely but maybe not - what happens if somebody installs a
> binary that was built on a system WITH dlm, but is meant to run on a
> system WITHOUT dlm?
>
> Actually, wouldn't that be the typical case for a typical distro?
>


That's exactly the case we are trying to cover in the above explanation. 
IOw, we would be using -ldl for runtime compatibility. If libdlm is not 
present, cluster functions will be resolved to null and will not be 
executed/allowed.

-- 
Goldwyn
