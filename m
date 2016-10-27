From: Roman Mamedov <rm@romanrm.net>
Subject: Re: recovering failed raid5
Date: Thu, 27 Oct 2016 21:26:26 +0500
Message-ID: <20161027212626.0c9318ff@natsu>
References: <CAM97BgQLPUN=t7VKHaVG-=SrJmS_tvaxGDbo3yqMwHm8B-do_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAM97BgQLPUN=t7VKHaVG-=SrJmS_tvaxGDbo3yqMwHm8B-do_Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Shenkin <al@shenkin.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 27 Oct 2016 16:06:14 +0100
Alexander Shenkin <al@shenkin.org> wrote:

> === START OF INFORMATION SECTION ===
> Model Family:     Seagate Barracuda 7200.14 (AF)
> Device Model:     ST3000DM001-9YN166

That's the horror drive of doom with 30% failure rates within a couple of
years https://www.backblaze.com/blog/3tb-hard-drive-failure/

It's even got it's own Wikipedia article by now:
https://en.wikipedia.org/wiki/ST3000DM001

This Russian article dissects what actually causes the failures -- poor
dust-proofing of the platters area: https://habrahabr.ru/post/251941/

I hope you didn't seriously go out and buy one more of that same model to
replace the failed one.

-- 
With respect,
Roman
