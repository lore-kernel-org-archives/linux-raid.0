From: Joe Lawrence <Joe.Lawrence@stratus.com>
Subject: Re: [PATCH] md: raid1,10: Handle REQ_WRITE_SAME flag in write bios
Date: Mon, 7 Jan 2013 15:56:27 -0500 (EST)
Message-ID: <alpine.DEB.2.02.1301071547060.31163@jlaw-desktop.mno.stratus.com>
References: <alpine.DEB.2.02.1212141406480.30895@jlaw-desktop.mno.stratus.com> <alpine.DEB.2.02.1301021039110.31163@jlaw-desktop.mno.stratus.com> <20130107132206.7d25de89@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130107132206.7d25de89@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Joe Lawrence <Joe.Lawrence@stratus.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 7 Jan 2013, NeilBrown wrote:

> Assuming that a REQ_WRITE_SAME is just like a normal write except for the
> iovec being shorter (is that right?) there should be no interesting issues
> with bitmaps - it should just work.

I believe this is the case (at least in the instances that I have seen), 
but Martin can say for sure.  

-- Joe
