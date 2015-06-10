From: Guoqing Jiang <jgq516@gmail.com>
Subject: Re: [PATCH 00/11] mdadm tool: add the support for cluster-md
Date: Wed, 10 Jun 2015 13:53:00 +0800
Message-ID: <5577D0BC.6080305@gmail.com>
References: <1433914934-21195-1-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1433914934-21195-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, rgoldwyn@suse.de
List-Id: linux-raid.ids

Hi Neil,

Sorry, I forgot to add V4 label in the subject.

Thanks,
Guoqing

Guoqing Jiang wrote:
> V4 changes:
> 1. update documation for syntax correct and add missed infos
> 2. code modification for remove duplicated code and coding style etc
> 3. make cluster name only appear in bitmap
> 4. add UUIDUpdate handling to write_bitmap0
>
> V3 changes:
> 1. re-orgnize some codes to ensure mdadm compiles after each patch is applied
> 2. change the code for super1.c for first patch since it has side effect for
> non-cluster condition
>
> V2 changes:
> 1. re-arrange the squence of patches
> 2. add some memembers into sb_le_to_cpu
> 3. handle some logic change and comments from Neil
>
> Basic background for Cluster MD: Cluster MD is a shared-device RAID for a
> cluster, currently, the implementation is limited to RAID1 but with further
> work (and some positive feedback), it could be extend to other RAID levels.
>
> The kernel part code of cluster-md has been sent to maillist several month
> ago by Goldywyn, and to make cluster-md works, the mdadm tools also need to
> do some changes accordingly.
>
> This patch set extends mdadm tool to aware cluster MD scenario, and handle
> related cluster-md scenario.
>
> 1. the first part (0001-0007) comes from Goldwyn, which add initial
> support for cluster-md, those changes included make mdadm awares nodes,
> home-cluster and n bitmaps for clustered mode, also let mdadm can 
> confirm disk which is added by another node.
>
>
> 2. the second part is for support change cluster-name and node nums under
> assemble mode. Which extend write-bitmap to handle above cases, and also
> use the extended write_bitmap for update uuid. [PATCH V2 10/10] is just compiled
> test only.
>
> BTW: this series could be apply on top of commit "2a6493 Grow: fix a couple of typos".
>
> Some reltated links:
> [1] http://marc.info/?l=linux-raid&m=141891941330336&w=2
> [2] http://marc.info/?l=linux-raid&m=141935561418770&w=2
>
> Guoqing Jiang (11):
>   Create n bitmaps for clustered mode
>   Add nodes option while creating md
>   home-cluster while creating an array
>   Show all bitmaps while examining bitmap
>   Add a new clustered disk
>   Convert a bitmap=none device to clustered
>   Skip clustered devices in incremental
>   mdadm: add the ability to change cluster name
>   mdadm: change the num of cluster node
>   Reuse calc_bitmap_size to reduce code size
>   Reuse the write_bitmap for update uuid
>
>  Assemble.c    |  12 ++++--
>  Create.c      |   5 ++-
>  Grow.c        |  12 ++++--
>  Incremental.c |   5 +++
>  Makefile      |   1 +
>  Manage.c      |  39 ++++++++++++++++--
>  ReadMe.c      |   3 ++
>  bitmap.c      |  71 +++++++++++++++++++--------------
>  bitmap.h      |   7 +++-
>  config.c      |  27 ++++++++++++-
>  md_p.h        |   7 ++++
>  md_u.h        |   1 +
>  mdadm.8.in    |  42 +++++++++++++++++++-
>  mdadm.c       |  64 ++++++++++++++++++++++++++++--
>  mdadm.h       |  20 +++++++++-
>  super0.c      |  15 ++++++-
>  super1.c      | 125 ++++++++++++++++++++++++++++++++++++++++++++++------------
>  util.c        |  60 ++++++++++++++++++++++++++++
>  18 files changed, 438 insertions(+), 78 deletions(-)
>
>   

