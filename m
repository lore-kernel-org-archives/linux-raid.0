From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: md: dead code in md_alloc()
Date: Thu, 20 Sep 2018 19:03:57 +0300
Message-ID: <3003e71d-ede0-0d55-973d-47c1c06e05ba@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Shaohua Li <shli@fb.com>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Hi,
Kirill noticed that the following piece of code from md_alloc(dev, name)
is dead:
	if (name && dev)
		/*
		 * Creating /dev/mdNNN via "newarray", so adjust hold_active.
		 */
		mddev->hold_active = UNTIL_STOP;

md_alloc() is always called with either dev == 0 or name == NULL.

Judging from the commit that added this code:

039b7225e6e98783a7a7e79c52b29c437f29967d
Author: NeilBrown <neilb@suse.com>
Date:   Wed Apr 12 16:26:13 2017 +1000

    md: allow creation of mdNNN arrays via md_mod/parameters/new_array

and from the comment, it seems should be "if (!name && dev)".
But that would also change ->hold_active for created-by-open md devices,
and I'm not sure whether that would be a desirable change or not.
