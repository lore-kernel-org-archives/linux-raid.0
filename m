From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] Add '--nodes' option in GROW mode
Date: Tue, 22 Mar 2016 13:56:38 -0400
Message-ID: <wrfjshzi9z1l.fsf@redhat.com>
References: <56F13020.8020900@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56F13020.8020900@suse.com> (zhilong's message of "Tue, 22 Mar
	2016 19:44:32 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: zhilong <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

zhilong <zlliu@suse.com> writes:
> Bug description:
> # mdadm -Cv /dev/md0 --bitmap=clustered -l1 -n2 /dev/sdd /dev/sdb
> --nodes=6 --assume-clean
> # mdadm --grow /dev/md0 --bitmap=none
> # mdadm --grow /dev/md0 --bitmap=clustered
>     -> cluster nodes would be changed to 4, here is my method to
> resolve it.
> # mdadm --grow /dev/md0 --bitmap=clustered --nodes=6
>
> Patch:
>
> Cluster nodes is set 4 as default when switch bitmap from
> none to clustered under GROW mode, so add '--nodes'
> option in GROW mode.
>
> Signed-off-by: Zhilong Liu <zlliu@suse.com>
> ---
>  mdadm.c | 1 +
>  1 file changed, 1 insertion(+)

Hi,

I have a question about this, since I simply do not have the knowledge
about clustering to judge this approach.

If you remove the bitmap, does that 'uncluster' the array? If not,
shouldn't mdadm be fixed to not set #nodes to 4 when adding a clustered
bitmap, if a number of cluster nodes is already present?

Thanks,
Jes

>
> diff --git a/mdadm.c b/mdadm.c
> index 51e16f3..b542b8c 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -592,6 +592,7 @@ int main(int argc, char *argv[])
>              ident.raid_disks = s.raiddisks;
>              continue;
>          case O(ASSEMBLE, Nodes):
> +        case O(GROW, Nodes):
>          case O(CREATE, Nodes):
>              c.nodes = parse_num(optarg);
>              if (c.nodes <= 0) {
