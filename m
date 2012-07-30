From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [RFC PATCH] fs/direct-io.c: Set bi_rw when alloc bio.
Date: Mon, 30 Jul 2012 09:31:37 -0400
Message-ID: <x49k3xl8jeu.fsf@segfault.boston.devel.redhat.com>
References: <201207271602081096921@gmail.com>
	<x496299708p.fsf@segfault.boston.devel.redhat.com>
	<201207300840005466080@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201207300840005466080@gmail.com> (majianpeng@gmail.com's message
	of "Mon, 30 Jul 2012 08:40:11 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: viro <viro@ZenIV.linux.org.uk>, Neil Brown <neilb@suse.de>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

majianpeng <majianpeng@gmail.com> writes:

> On 2012-07-27 22:21 Jeff Moyer <jmoyer@redhat.com> Wrote:
>>majianpeng <majianpeng@gmail.com> writes:
>>
>>> When exec bio_alloc, the bi_rw is zero.But after calling bio_add_page,
>>> it will use bi_rw.
>>> Fox example, in functiion __bio_add_page,it will call merge_bvec_fn().
>>> The merge_bvec_fn of raid456 will use the bi_rw to judge the merge.
>>>>> if ((bvm->bi_rw & 1) == WRITE)
>>>>>		return biovec->bv_len; /* always allow writes to be mergeable */
>>>
>>> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
>>
>>Good catch.  How did you find this?  Did you experience data corruption
>>as a result of this oversight, reduced performance due to missed merge
>>opportunities, or did you just notice it in reviewing the code?
>>
>>Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
>>
> Sorry for late to reply. When i analysed the performance of raid5, i found this bug.

OK, thanks.  In the future, it would be good to include that information
in the patch description.

Cheers,
Jeff
