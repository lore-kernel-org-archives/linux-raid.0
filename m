From: Richard <richard@sauce.co.nz>
Subject: Re: recovering from a controller failure
Date: Sun, 30 May 2010 09:38:50 +1200
Message-ID: <4C01896A.7030705@sauce.co.nz>
References: <20100529190751.GM2167@flews.lairds.us> <4C01849D.8080101@sauce.co.nz> <20100529213610.GC7501@flews.lairds.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100529213610.GC7501@flews.lairds.us>
Sender: linux-raid-owner@vger.kernel.org
To: Kyler Laird <kyler-keyword-linuxraid00.a7e7f0@lairds.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Kyler Laird wrote:

> Wow!  That's encouraging.  I would feel amazingly more confident if
> someone would give me the exact command to try.  This is not a good
> time for me to exercise my ignorance by experimenting.

mdadm -A -f /dev/mdX

Regards,

Richard
