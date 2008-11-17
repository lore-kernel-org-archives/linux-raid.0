From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RAID-6 question.
Date: Sun, 16 Nov 2008 16:29:57 -0800
Message-ID: <4920BB05.3050206@zytor.com>
References: <alpine.DEB.1.10.0811100653060.21263@p34.internal.lan> <alpine.DEB.1.10.0811101101530.25411@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0811101101530.25411@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Justin Piszcz wrote:
> 
> The sync_speed_max was the default as well until I changed it, once I
> lowered
> the speed, the system was functional again.  By default its set quite high,
> this appeared to be the root cause of the problem.
> 

You probably ran out of CPU.  2-disk RAID-6 recovery is very CPU intensive.

	-hpa
