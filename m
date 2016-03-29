From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] mdadm:Add '--nodes' option in GROW mode
Date: Tue, 29 Mar 2016 11:43:06 -0400
Message-ID: <wrfj60w5war9.fsf@redhat.com>
References: <56F13020.8020900@suse.com> <wrfjshzi9z1l.fsf@redhat.com>
	<56F28046.9010801@suse.com> <wrfj7fgr4z3g.fsf@redhat.com>
	<56F4A0CB.1040609@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56F4A0CB.1040609@suse.com> (zhilong's message of "Fri, 25 Mar
	2016 10:22:03 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: zhilong <zlliu@suse.com>
Cc: Guoqing Jiang <gqjiang@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

zhilong <zlliu@suse.com> writes:
> mdadm:add '--nodes' option in GROW mode, because
> 'Cluster nodes' is set 4 by default if the nodes
> parameter is not specified when switch bitmap
> from none to clustered.
>
> Signed-off-by: Zhilong Liu <zlliu@suse.com>
> ---
>  mdadm.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/mdadm.c b/mdadm.c
> index d2afcb2..58ac32a 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -589,6 +589,7 @@ int main(int argc, char *argv[])
>  			ident.raid_disks = s.raiddisks;
>  			continue;
>  		case O(ASSEMBLE, Nodes):
> +		case O(GROW, Nodes):
>  		case O(CREATE, Nodes):
>  			c.nodes = parse_num(optarg);
>  			if (c.nodes <= 0) {

Applied!

Something funny happened to the formatting of your patch. Somehow it
ended up with an additional space at the beginning of each line. Not
sure if it is related to your mail client using format-flowed.

I manually fixed it up, so it's all good.

Thanks,
Jes
