From: Song Liu <song@kernel.org>
Subject: Re: Fw: some questions about uploading a Linux kernel driver
Date: Thu, 30 Apr 2020 00:10:27 -0700
Message-ID: <CAPhsuW7e-xMNbk5ZJw2XQ3KSnnPiN5gwwR4hdMMhyjjVNRnfkQ@mail.gmail.com>
References: <6a7c0aba219642de8b3f1cc680d53d85@AM0P193MB0754.EURP193.PROD.OUTLOOK.COM>
 <CAKm37QWKVcPkF0fXKk2499CsYXfU3aMuMWgwa8Nk9HFzVxG7CA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKm37QWKVcPkF0fXKk2499CsYXfU3aMuMWgwa8Nk9HFzVxG7CA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiaosong Ma <xma@qf.org.qa>
Cc: linux-raid <linux-raid@vger.kernel.org>, =?UTF-8?B?5aec5aSp5rSL?= <ty-jiang18@mails.tsinghua.edu.cn>, Guangyan Zhang <gyzh@tsinghua.edu.cn>, wei-jy19@mails.tsinghua.edu.cn
List-Id: linux-raid.ids

Hi Xiaosong,

On Wed, Apr 22, 2020 at 5:26 AM Xiaosong Ma <xma@qf.org.qa> wrote:
>
> Dear Song,
>
> This is Xiaosong Ma from Qatar Computing Research Institute. I am
> writing to follow up with the questions posed by a co-author from
> Tsinghua U, regarding upstreaming our alternative md implementation
> that is designed to significantly reduce SSD RAID latency (both median
> and tail) for large SSD pools (such as 20-disk or more).
>
> We read the Linux kernel upstreaming instructions, and believe that
> our implementation has excellent separability from the current code
> base (as a plug-and-play module with identical interfaces as md).

Plug-and-play is not the key for upstream new code/module. There are
some other keys to consider:

1. Why do we need it? (better performance is a good reason here).
2. What's the impact on existing users?
3. Can we improve existing code to achieve the same benefit?

> Meanwhile, we wonder whether there are standard test cases or
> preferred applications that we should test our system with, before
> doing code cleaning up. Your guidance is much appreciated.

For testing, "mdadm test" is a good starting point (if it works here).
We also need data integrity tests and stress tests.

Thanks,
Song
