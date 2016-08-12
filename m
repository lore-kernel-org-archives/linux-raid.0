From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] mdadm: put journal device in right place of --detail
Date: Fri, 12 Aug 2016 10:59:41 -0400
Message-ID: <wrfjoa4y823m.fsf@redhat.com>
References: <1470960853-2859579-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1470960853-2859579-1-git-send-email-songliubraving@fb.com> (Song
	Liu's message of "Thu, 11 Aug 2016 17:14:13 -0700")
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, yizhan@redhat.com, Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

Song Liu <songliubraving@fb.com> writes:
> When there is failed HDDs, journal device showed in wrong place
> of --detail:
>
>     Number   Major   Minor   RaidDevice State
>        4       8       24        -      journal   /dev/sdb8
>        1       8       18        1      active sync   /dev/sdb2
>        2       8       19        2      active sync   /dev/sdb3
>        3       8       21        3      active sync   /dev/sdb5
>
>        0       8       17        -      faulty   /dev/sdb1
>
> This patch fixed the output as:
>
>     Number   Major   Minor   RaidDevice State
>        -       0        0        0      removed
>        1       8       18        1      active sync   /dev/sdb2
>        2       8       19        2      active sync   /dev/sdb3
>        3       8       21        3      active sync   /dev/sdb5
>
>        0       8       17        -      faulty   /dev/sdb1
>        4       8       24        -      journal   /dev/sdb8
>
> Reported-by: Yi Zhang <yizhan@redhat.com>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  Detail.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Applied, thanks!

Jes

PS: If you CC me directly in mdadm patches I am likely to see them
faster, ie. before I get to the linux-raid list.
