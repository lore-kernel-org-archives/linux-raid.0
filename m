From: Jes Sorensen <jes@trained-monkey.org>
Subject: Re: [PATCH v3 mdadm 1/1] Specify nodes number when updating cluster
 nodes
Date: Fri, 7 Aug 2020 09:41:40 -0400
Message-ID: <bfac39dd-d8cd-6cb1-2f57-9f1b1d847724@trained-monkey.org>
References: <1595812460-3929-1-git-send-email-xni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1595812460-3929-1-git-send-email-xni@redhat.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org
Cc: antlists@youngman.org.uk, ncroxon@redhat.com, heinzm@redhat.com
List-Id: linux-raid.ids

On 7/26/20 9:14 PM, Xiao Ni wrote:
> Now it allows updating cluster nodes without specify --nodes. It can write superblock
> with zero nodes. It can break the current cluster. Add this check to avoid this problem.
> 
> v2: It needs check c.update first to avoid NULL pointer reference
> v3: Wol points the typo error
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  mdadm.c | 5 +++++
>  1 file changed, 5 insertions(+)

Applied!

Thanks,
Jes
