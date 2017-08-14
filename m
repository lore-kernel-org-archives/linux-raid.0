From: Jack Wang <jack.wang.usish@gmail.com>
Subject: Re: raid1 lockups on 4.12.x
Date: Mon, 14 Aug 2017 10:40:02 +0200
Message-ID: <CA+res+QDmtOZTNG_Unegf_zY+mSvX4Ce7qTLye1gb__W7xYhNw@mail.gmail.com>
References: <20170731183616.GD22429@hostway.ca> <20170814070844.GA10721@hostway.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170814070844.GA10721@hostway.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Simon Kirby <sim@hostway.ca>
Cc: linux-raid <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.com>, Shaohua Li <shli@kernel.org>
List-Id: linux-raid.ids

2017-08-14 9:08 GMT+02:00 Simon Kirby <sim@hostway.ca>:
> On Mon, Jul 31, 2017 at 11:36:16AM -0700, Simon Kirby wrote:
>
>> Hello,
>>
>> I recently upgraded two old boxes to 4.12.3 only to find that they
>> started to lock up several times per day. I upgraded to 4.12.4 and the
>> problem persisted. Downgrading to 4.11.11 seems to have stopped the
>> issue.
>
> I am still seeing this, even on 4.12.6, now also on a home server using
> RAID 1, even with the "mddev->in_sync || !mddev->sync_checkers" condition
> fixed to drop the '!':

Hi,

Neil and Shaohua have 3 fixes in this regards:

https://git.kernel.org/pub/scm/linux/kernel/git/shli/md.git/commit/?h=for-next&id=33182d15c6bf182f7ae32a66ea4a547d979cd6d7
https://git.kernel.org/pub/scm/linux/kernel/git/shli/md.git/commit/?h=for-next&id=81fe48e9aa00bdd509bd3c37a76d1132da6b9f09
https://git.kernel.org/pub/scm/linux/kernel/git/shli/md.git/commit/?h=for-next&id=afc1f55ca44e257f69da8f43e0714a76686ae8d1

Hope this helps!
Jack
