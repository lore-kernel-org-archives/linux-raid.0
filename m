From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 06/12] md-cluster: add the error check if failed to get
 dlm lock
Date: Wed, 29 Jul 2015 10:22:38 +1000
Message-ID: <20150729102238.5ecc2e96@noble>
References: <1436518453-12660-1-git-send-email-gqjiang@suse.com>
	<1436518883-12783-1-git-send-email-gqjiang@suse.com>
	<1436518883-12783-3-git-send-email-gqjiang@suse.com>
	<55B660CD.2030600@suse.de>
	<55B6F13F.7070100@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55B6F13F.7070100@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqJiang@suse.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 28 Jul 2015 11:04:31 +0800 Guoqing Jiang <gqJiang@suse.com>
wrote:

> Hi Goldwyn,
> 
> Goldwyn Rodrigues wrote:
> > Hi Guoqing,
> >
> > On 07/10/2015 04:01 AM, Guoqing Jiang wrote:
> >> In complicated cluster environment, it is possible that the
> >> dlm lock couldn't be get/convert on purpose, the related err
> >> info is added for better debug potential issue.
> >>
> >> For lockres_free, if the lock is blocking by a lock request or
> >> conversion request, then dlm_unlock just put it back to grant
> >> queue, so need to ensure the lock is free finally.
> >
> >
> > I cannot think of a scenario where a DLM_CANCEL will be returned.
> > Could you explain the situation a bit more?
> >
> Thanks for the review. When the node is receiving message where it needs
> to convert message
> lock, and lockres_free is invoked if user stop array meanwhile, then the
> message lock is put back
> to grant queue at the CR mode and message lock is not released, am I
> misunderstood the case?
> 
> Thanks,
> Guoqing

Thanks for these patches Guoqing and for the review Goldwyn.

I've queued all but the last one (which you both agree we don't need).

I have queued this one too for now, though it Goldwyn has further
comments I'd be very happy to see them.

I'm a bit bothered by:
+retry:
+	ret = dlm_unlock(res->ls, res->lksb.sb_lkid, 0, &res->lksb, res);
+	if (unlikely(ret != 0)) {
+		pr_info("%s: failed to unlock %s return %d\n", __func__, res->name, ret);
+
+		/* if a lock conversion is cancelled, then the lock is put
+		 * back to grant queue, need to ensure it is unlocked */
+		if (ret == -DLM_ECANCEL)
+			goto retry;
+	}

which looks like it could loop repeatedly.  Maybe if there was
documentation for DLM_LKF_CANCEL or DLM_ECANCEL somewhere, that might
make me feel more comfortable, but the only documentation that I can
find is the code ... is there real documentation that google doesn't
find for me?

Thanks,
NeilBrown
