From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: [PATCH v2 mdadm 1/1] Specify nodes number when updating cluster
 nodes
Date: Sun, 26 Jul 2020 10:05:48 +0100
Message-ID: <5F1D476C.4090605@youngman.org.uk>
References: <1595503205-11129-1-git-send-email-xni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1595503205-11129-1-git-send-email-xni@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org, jes@trained-monkey.org
Cc: ncroxon@redhat.com, heinzm@redhat.com
List-Id: linux-raid.ids

On 23/07/20 12:20, Xiao Ni wrote:
> Now it allow updating cluster nodes without specify --nodes. It can write superblock
> with zero nodes. It can break the current cluster. Add this check to avoid this problem.
> 
> v2: It needs check c.update first to void NULL pointer reference
                                       ^^^^
Do you mean "avoid"?
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
Cheers,
Wol
