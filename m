From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 0/2] Check node nums for cluster raid
Date: Wed, 04 May 2016 11:12:20 -0400
Message-ID: <wrfjinytx3fv.fsf@redhat.com>
References: <1462350824-9872-1-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1462350824-9872-1-git-send-email-gqjiang@suse.com> (Guoqing
	Jiang's message of "Wed, 4 May 2016 16:33:42 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guoqing Jiang <gqjiang@suse.com> writes:
> For cluster raid, we do need at least two nodes for it,
> the two patches add the checks before create and change
> bitmap.
>
> Thanks,
> Guoqing    
>
> Guoqing Jiang (2):
>   Create: check the node nums when create clustered raid
>   super1: don't update node nums if it is not more than 1
>
>  Create.c | 7 ++++++-
>  super1.c | 5 +++++
>  2 files changed, 11 insertions(+), 1 deletion(-)

Hi Guoqing,

I am a little confused on this one - albeit I haven't looked at it in
detail. Why should it not be possible to start a cluster with one node?
In theory you should be able to do that, and then add nodes later?

Cheers,
Jes
