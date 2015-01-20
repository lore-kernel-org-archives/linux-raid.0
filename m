From: "Wesley W. Terpstra" <wesley@terpstra.ca>
Subject: Re: kernel refuses devices mdadm -E accepts
Date: Tue, 20 Jan 2015 19:32:50 +0100
Message-ID: <CAA-O0XgV8NBSHxg9Q9RBLiASeCh_qCQLutc8_mg2Y2fwhWBOLA@mail.gmail.com>
References: <CAA-O0XjoD3fQaMpYYmy4kpBSxD+K9TKX_QGr9mcNVuye43XWHg@mail.gmail.com>
	<54BE9E47.9030706@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54BE9E47.9030706@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jan 20, 2015 at 7:28 PM, Phil Turmel <philip@turmel.org> wrote:
>> Kernel version 3.17.8 and mdadm version 3.3.2.
> There have been many bug fixes to mdadm since that kernel was retired.

Really? I will give that a shot.

> Show us the output of that if it doesn't work (it should resume your
> reshape).

I will try that.

It was totally stupid reshape, I was changing the "data-offset" to
align it. Really unnecessary, and really slow, so I feel like an idiot
for starting it.

>> Thanks for any help. If I lose this array, I am going to face a lot of grief...
> I shouldn't have to say this, but RAID is for availability, not for data
> security.  You still need a backup system for any important data.

Sure. The really vital (and small) stuff I have backed up elsewhere,
but the sheer volume of raw video my girlfriend records is not
economically feasible to backup beyond raid+btrfs snapshots.
