From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: Re: hung-task panic in raid5_make_request
Date: Mon, 13 Jan 2020 14:58:46 +0100
Message-ID: <cde80def-2832-2a45-28fa-055e6be88d05@cloud.ionos.com>
References: <CAGRgLy4Yi1HNqNO0MLq5xjRRgWe7EaByRYF5sA3fFVa1tmpNvA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy4Yi1HNqNO0MLq5xjRRgWe7EaByRYF5sA3fFVa1tmpNvA@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, liu.song.a23@gmail.com
List-Id: linux-raid.ids



On 12/24/19 9:18 PM, Alexander Lyakas wrote:
> We recently moved to kernel 4.14 (long term kernel) from kernel 3.18.
> With kernel 3.18 we haven't seen this issue.

Could you bisect commits between 3.18 and 4.14 to identify
which commit may related to the issue?

Thanks,
Guoqing
