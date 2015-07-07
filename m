From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/1] RFC: Unreliable discard performance can cripple RAID1
Date: Tue, 7 Jul 2015 00:42:48 -0400
Message-ID: <CAMM=eLcd18_Vkx0O0VsmsJCbcs52Dj1hprA6u8_1CDkFQePGKQ@mail.gmail.com>
References: <1435105573-1373-1-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1435105573-1373-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: Neil Brown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: linux-raid.ids

On Tue, Jun 23, 2015 at 8:26 PM,  <Jes.Sorensen@redhat.com> wrote:
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>
> Neil,
>
> I have been hitting issues with discard being ridiculously slow on
> arrays with certain typs of SSDs that seem to serialize discard
> processing.
>
> This is particularly bad as I have seen systems where the IMSM BIOS
> defaults to 4KB chunk size, combined with these badly performing
> drives, it could bump the mkfs on an array from seconds to over 40
> minutes. Most users will stick to the defaults and then hit the
> problem during install without understanding why it goes wrong :(
>
> The problem is that there is no way to benchmark our way to this or
> somehow test if a drive performs discard at reasonable speed. I
> suggest we take an approach similar to that of RAID456 and default to
> disabling discard, except for the case where the user knows the drives
> are safe.
>
> Thoughts?
>
> Cheers,
> Jes
>
>
> Jes Sorensen (1):
>   raid0: Disable discard per default due to performance uncertainty
>
>  drivers/md/raid0.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)

As we've discussed in private (but for the benefit of others):

MD raid0 should do what dm-stripe does.  Which is calculate the full
extent to discard for each member in the raid0.
This avoids issuing lots of small discards and hoping the block layer
merges them back up.

See this DM commit for reference:
http://git.kernel.org/linus/7b76ec11fec40203836b488496d2df082d5b2022
