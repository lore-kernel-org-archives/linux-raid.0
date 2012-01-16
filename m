From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] md: Remove annoying debug message when restarting
Date: Mon, 16 Jan 2012 08:33:07 +0100
Message-ID: <20120116073307.GC15641@elte.hu>
References: <1326662055-7098-1-git-send-email-levinsasha928@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1326662055-7098-1-git-send-email-levinsasha928@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sasha Levin <levinsasha928@gmail.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


* Sasha Levin <levinsasha928@gmail.com> wrote:

> This patch removes the "md: stopping all md devices" message when shutting
> down/restarting.
> 
> On Sat, 2012-01-14 at 09:43 +0100, Ingo Molnar wrote:
> > Btw. #2, that annoying 'md: stopping' message should be gotten
> > rid of. Some moron added that to the kernel as a one-day debug
> > printout to debug a software-RAID hang during development of the
> > code, about 15 years ago. (Oh, that was me.)
> 
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>

Acked-by: Ingo Molnar <mingo@elte.hu>

Thanks,

	Ingo
