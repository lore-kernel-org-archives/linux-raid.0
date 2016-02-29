From: Andrea Righi <righi.andrea@gmail.com>
Subject: Re: multipath: I/O hanging forever
Date: Sun, 28 Feb 2016 20:46:16 -0700
Message-ID: <20160229034616.GA2682@Dell>
References: <20160229015333.GA3101@Dell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160229015333.GA3101@Dell>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Feb 28, 2016 at 06:53:33PM -0700, Andrea Righi wrote:
... 
> I'm using 4.5.0-rc5+, from Linus' git. I'll try to do a git bisect
> later, I'm pretty sure this problem has been introduced recently (i.e.,
> I've never seen this issue with 4.1.x).

I confirm, just tested kernel 4.1 and this problem doesn't happen.

Thanks,
-Andrea
