From: Song Liu <songliubraving@fb.com>
Subject: Re: Warning in raid5-cache.c with NVME journal and DM_MQ_DEFAULT
Date: Mon, 21 Aug 2017 09:40:11 -0700
Message-ID: <20170821164011.3204165-1-songliubraving@fb.com>
References: <d7042309-ab0c-9a7a-ecb6-d8988a38888e@kyberraum.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d7042309-ab0c-9a7a-ecb6-d8988a38888e@kyberraum.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org, linux@kyberraum.net, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

Hi Vasco,

Thanks a lot for this report. We recently found this error in our tests.
The following commit should fix it.

commit a9501d742127e613d744e29814e9532bacb147e8
Author: Song Liu <songliubraving@fb.com>
Date:   3 weeks ago

md/r5cache: fix io_unit handling in r5l_log_endio()


Please kindly let us know if this doesn't fix this issue.

Regards,
Song
