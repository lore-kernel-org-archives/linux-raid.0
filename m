From: hansbkk@gmail.com
Subject: Re: RAID 5 - One drive dropped while replacing another
Date: Wed, 2 Feb 2011 21:21:20 +0700
Message-ID: <AANLkTimJC_e8=BmGj7Th_LLc=wnoNj8tRovAgTR=mmQ7@mail.gmail.com>
References: <AANLkTinXTYds442gPrs9a9vKtWTo4OcDHDEzvO0njvyv@mail.gmail.com>
	<AANLkTikSjLhoUM5f2ibqCUmo8XF-tsrhxZ7oieg08dtD@mail.gmail.com>
	<20110202043605.593f0c5c@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110202043605.593f0c5c@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: Bryan Wintermute <bryanwintermute@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Feb 2, 2011 at 6:36 AM, Roman Mamedov <rm@romanrm.ru> wrote:
>
>> I have a RAID5 setup with 15 drives.
>
> Looks like you got the problem you were so desperately asking for, with this
> crazy setup. :(

Please give some more details as to what's so crazy about this.

I would think RAID6 would have made more sense, possibly with an
additional spare if these are large drives (over a few hundred GB?)

Or is there an upper limit as to the number of drives that's advisable
for any array?

If so, then what do people reckon a reasonable limit should be for a
RAID6 made up of 2TB drives?
