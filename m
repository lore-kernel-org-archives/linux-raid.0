From: "Dan Williams" <dan.j.williams@gmail.com>
Subject: Re: Linux RAID & XFS Question - Multiple levels of concurrency = faster I/O on md/RAID 5?
Date: Sun, 2 Nov 2008 15:21:48 -0700
Message-ID: <e9c3a7c20811021421g24086479v9fddacd5a6ee2c5e@mail.gmail.com>
References: <alpine.DEB.1.10.0811010424270.16517@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0811010424270.16517@p34.internal.lan>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-raid.ids

On Sat, Nov 1, 2008 at 1:29 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> I am using XFS and md/RAID-5, the CFQ scheduler and kernel 2.6.27.4.
> Is this more of an md/raid issue ( I am guessing ) than XFS? I remember
> reading of some RAID acceleration patches awhile back that were supposed to
> boost performance quite a bit, what happened to them?
>

You have it applied, Neil accepted the patch[1] for 2.6.26.

--
Dan

[1] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=8b3e6cdc53b7f29f7026955d6cb6902a49322a15
