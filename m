From: "Christian Pernegger" <pernegger@gmail.com>
Subject: Re: Can't get md array to shut down cleanly
Date: Thu, 6 Jul 2006 22:24:34 +0200
Message-ID: <bb145bd20607061324w7edbbf0bk33906e32fb521e10@mail.gmail.com>
References: <bb145bd20607060648p3776d335g55e4bdee4ecaf3c4@mail.gmail.com>
	 <20060706154658.GC13285@rigacci.org>
	 <bb145bd20607061018u3bf275ads6b602657867cb07d@mail.gmail.com>
	 <20060706192919.GA19446@amd64.of.nowhere>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060706192919.GA19446@amd64.of.nowhere>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I get these messages too on Debian Unstable, but since enabling the
> bitmaps on my devices, resyncing is so fast that I don't even notice it
> on booting.

Bitmaps are great, but the speed of the rebuild is not the problem.
The box doesn't have hotswap bays, so I have to shut it down to
replace a failed disk. If the array decides that it wasn't clean after
the exchange I'm suddenly looking at a dead array. Yes, forcing
assembly _should_ work but I'd rather have it shutdown cleanly in the
first place.

Regards,

C.
