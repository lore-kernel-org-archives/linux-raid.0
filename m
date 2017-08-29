From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH 0/2] mdadm patches for r5cache and mdadm.spec
Date: Tue, 29 Aug 2017 13:40:01 -0400
Message-ID: <9bc710d6-b4da-521c-31f7-67feb32cb55f@gmail.com>
References: <20170828222036.3278481-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170828222036.3278481-1-songliubraving@fb.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>, linux-raid@vger.kernel.org
Cc: shli@fb.com, kernel-team@fb.com, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

On 08/28/2017 06:20 PM, Song Liu wrote:
> These two patches are not related to each other. I just found
> them recently.
> 
> The first patch is found when building rpm with mdadm.spec.
> 
> The send patch fixes an --incremental issue when there is
> mismatch in "Events" in an array with r5cache.
> 
> Thanks,
> Song
> 
> Song Liu (2):
>    mdadm: install two more udev rules in mdadm.spec
>    mdadm: save previous journal_clean when reload super
> 
>   Incremental.c | 3 +++
>   mdadm.spec    | 2 ++
>   2 files changed, 5 insertions(+)

Hi,

I applied the first one, but leaving the second one out for now, per 
Neil's comments.

Cheers,
Jes

