From: Dan Williams <djbw@fb.com>
Subject: Re: [PATCH] raid5: add support for rmw writes in raid6
Date: Wed, 8 May 2013 10:42:45 -0700
Message-ID: <CAA9_cmdPq24W4VtSfbz0RMXgdG9T2AkaCQrWF4hBwjx9BT61LA@mail.gmail.com>
References: <20130418005609.6782.15041.stgit@dev279.prn2.facebook.com>
	<20130422142211.71a1ae8e@notabene.brown>
	<CAA9_cmdbZ_K5Wvo7BH1nPGvttL5As1ncnbPK1ax3TFvGOch6zw@mail.gmail.com>
	<20130429112957.4bd6cd71@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130429112957.4bd6cd71@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, Kumar Sundararajan <kumar@fb.com>, Li Shaohua <shli@fusionio.com>
List-Id: linux-raid.ids

On Sun, Apr 28, 2013 at 6:29 PM, NeilBrown <neilb@suse.de> wrote:
> On Fri, 26 Apr 2013 14:35:27 -0700 Dan Williams <djbw@fb.com> wrote:
[..]
>>
>> This has been verified with check and dual-degraded recovery operations.
>
> Good, thanks.

However we are running into hangs when running it on top of your
md/for-next branch with the threading and lockless changes, still
looking into it...

--
Dan
