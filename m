From: Joe Landman <joe.landman@gmail.com>
Subject: Re: md road-map: 2011
Date: Wed, 16 Feb 2011 09:13:24 -0500
Message-ID: <4D5BDB84.8050706@gmail.com>
References: <20110216212751.51a294aa@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110216212751.51a294aa@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/16/2011 05:27 AM, NeilBrown wrote:
>
> I all,
>   I wrote this today and posted it at
> http://neil.brown.name/blog/20110216044002
>
> I thought it might be worth posting it here too...


Any possibility of getting a hook for a read/write/compare checksum in 
this?  I'd be happy to commit some time to this if I knew where to begin.

Also, very interested in hooks to do RAID and similar computations in 
user space (so we can play with functionality without causing problems 
with a kernel).  Does this external capability exist now?  Would it be 
hard to include?  Again, something we'd be interested in committing some 
time to if we could get a shove in the right direction.

Thanks!

Joe
