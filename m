From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: [PATCH 01/14] md-cluster: remove unnecessary header files
Date: Wed, 1 Mar 2017 10:47:43 +0800
Message-ID: <58B6364F.7050308@suse.com>
References: <1487906124-20107-1-git-send-email-gqjiang@suse.com>
 <1487906124-20107-2-git-send-email-gqjiang@suse.com>
 <20170228180337.j7qakl7kbf5lapup@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170228180337.j7qakl7kbf5lapup@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, shli@fb.com, neilb@suse.de
List-Id: linux-raid.ids



On 03/01/2017 02:03 AM, Shaohua Li wrote:
> On Fri, Feb 24, 2017 at 11:15:11AM +0800, Guoqing Jiang wrote:
>> md-cluster.h is already included in md.h, so remove
>> the redundant one and we don't want to cross include
>> header file too.
>>
>> Reviewed-by: NeilBrown <neilb@suse.com>
>> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> It would be better md.h doesn't include md-cluster.h and include md-cluster.h
> in required .c files.

Currently, there are compile dependency since md_cluster_operations and
md_cluster_info (though it need to move from md-cluster.c to md-cluster.h
in future) are used inside md.h. Anyway, I will consider about how to 
improve
this.

Thanks,
Guoqing
