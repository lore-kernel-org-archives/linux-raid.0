From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH 2/2] mdadm: remove journal with "remove-journal"
Date: Thu, 31 Aug 2017 10:51:01 -0700
Message-ID: <20170831175101.2965834-1-songliubraving@fb.com>
References: <63717f4b-5b81-7290-5265-087713f0bd45@nuclearwinter.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <63717f4b-5b81-7290-5265-087713f0bd45@nuclearwinter.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org, jes.sorensen@gmail.com, llowrey@nuclearwinter.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

Hi Larkin,

We didn't ship this patch. Instead, we decide to use sysfs entry

/sys/block/mdXXX/md/consistency_policy

You can find the patch at:

https://marc.info/?l=linux-raid&m=149063896208043

Thanks,
Song
