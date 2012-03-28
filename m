From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: [PULL REQUEST] two md updates for 3.3
Date: Wed, 28 Mar 2012 15:33:51 +0200
Message-ID: <CAGRgLy7Dq9g8Bj2_vWu5iYk9gboZ42nyswQNX4g6ziWMDou1Eg@mail.gmail.com>
References: <20120209121613.3392fb87@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120209121613.3392fb87@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux RAID <linux-raid@vger.kernel.org>, Jonathan Brassow <jbrassow@redhat.com>
List-Id: linux-raid.ids

Hi Neil,
aren't those resync fixes the ones we had a long discussion about?
Do you think those could be backported to 3.2 (which is picked by
Ubuntu Precise)?

Thanks,
  Alex.


On Thu, Feb 9, 2012 at 3:16 AM, NeilBrown <neilb@suse.de> wrote:
>
> Hi Linus,
>
> The following changes since commit 307729c8bc5b5a41361af8af95906eee75=
52acb1:
>
> =A0md/raid1: perform bad-block tests for WriteMostly devices too. (20=
12-01-11 08:35:17 +1100)
>
> are available in the git repository at:
>
> =A0git://neil.brown.name/md/ md-3.3-fixes
>
> for you to fetch changes up to db91ff55bdf06736b849afc1b1fce5763bbb8d=
5d:
>
> =A0md: two small fixes to handling interrupt resync. (2012-02-07 12:0=
1:51 +1100)
>
> ----------------------------------------------------------------
> (from the branch description for md-scratch local branch)
>
> for-linus
> Some simple md-related fixes.
>
> 1/ two small fixes to ensure we handle an interrupted resync properly=
=2E
> 2/ avoid loading the bitmap multiple times in dm-raid
>
> ----------------------------------------------------------------
> Jonathan Brassow (1):
> =A0 =A0 =A0Prevent DM RAID from loading bitmap twice.
>
> NeilBrown (1):
> =A0 =A0 =A0md: two small fixes to handling interrupt resync.
>
> =A0drivers/md/dm-raid.c | =A0 12 +++++++++---
> =A0drivers/md/md.c =A0 =A0 =A0| =A0 =A05 +++--
> =A02 files changed, 12 insertions(+), 5 deletions(-)
>
>
> Thanks,
> NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
