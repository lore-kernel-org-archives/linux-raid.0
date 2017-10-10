From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [MDADM PATCH -v5 1/1] mdadm/test: Add one test case for raid5
 reshape
Date: Tue, 10 Oct 2017 16:23:48 -0400
Message-ID: <b1f81219-2b8c-2962-67e0-8bb086e48d0a@gmail.com>
References: <1507635172-7407-1-git-send-email-xni@redhat.com>
 <1507635172-7407-2-git-send-email-xni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1507635172-7407-2-git-send-email-xni@redhat.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org
Cc: zlliu@suse.com
List-Id: linux-raid.ids

On 10/10/2017 07:32 AM, Xiao Ni wrote:
> This case tries to allow raid5 reshape to use backwards direction.
> It changes chunksize after reshape and stops the raid. Then starts
> the raid again.
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> Suggested-by:  Jes Sorensen <jes.sorensen@gmail.com>
> Suggested-by:  Zhilong Liu <zlliu@suse.com>
> Suggested-by:  Paul Menzel <pmenzel@molgen.mpg.de>
> ---
>   test           |  7 +++++++
>   tests/02r5grow | 17 +++++++++++++++++
>   2 files changed, 24 insertions(+)

I find the choice of 1.1 metadata kinda odd for these tests, but 
otherwise I think it's fine, so I applied it.

Jes
