From: NeilBrown <neilb@suse.de>
Subject: Re: What's the typical RAID10 setup?
Date: Tue, 1 Feb 2011 09:50:30 +1100
Message-ID: <20110201095030.65e2349b@notabene.brown>
References: <AANLkTimc35i0W8vmsEGWrjCH7pYLBo=Ju1inA6xQ8bj6@mail.gmail.com>
	<AANLkTimoSvWj3mnowZbVKKHEMzwjiQ=WqRUUsj91n_Zr@mail.gmail.com>
	<20110131152151.GD7861@cthulhu.home.robinhill.me.uk>
	<AANLkTimfnRxm=chKx4MFSxX1c0hypnVW-jaYwq757DaH@mail.gmail.com>
	<AANLkTi=mLFwdLzcjcpzC0JJ=v8Aa817g+CzrR88pmy9y@mail.gmail.com>
	<AANLkTikvXk0gyXz6MBvhyzxXatk0FVeASPr8R8+74c_i@mail.gmail.com>
	<AANLkTinGSNmp6yUNfb9thnr3zKFTzw=fUFm+Gef3DAHw@mail.gmail.com>
	<AANLkTim_uQ7AQs_ZSyeYPJPYSLCJd6ChzzTBwBNk2qA9@mail.gmail.com>
	<20110131192858.GD27952@www2.open-std.org>
	<4D4718E1.9040607@hardwarefreak.com>
	<20110131203725.GB2283@www2.open-std.org>
	<AANLkTimxCkxkg6xuz8FgFf0=u4KY=0M=6+afnxLzT+Tu@mail.gmail.com>
	<AANLkTi=+rPzaNTKAjB=QUEGsbUcwfN8uijm96DoY_4FA@mail.gmail.com>
	<AANLkTinM6FkJtxL8dNpoy-haGqNsZVfLDwmvZcshTEYQ@mail.gmail.com>
	<AANLkTi=kUGc8bjisn69BEEkZr6kcHUyfKnVZzNtgaJf3@mail.gmail.com>
	<AANLkTikYGquOk9wwMuLxaDRvOe3-iJOMMW7JQKpdZBpk@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikYGquOk9wwMuLxaDRvOe3-iJOMMW7JQKpdZBpk@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Jon Nelson <jnelson-linux-raid@jamponi.net>, Mathias =?ISO-8859-1?B?QnVy6W4=?= <mathias.buren@gmail.com>, Keld =?ISO-8859-1?B?Svhybg==?= Simonsen <keld@keldix.com>, Stan Hoeppner <stan@hardwarefreak.com>, Denis <denismpa@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 31 Jan 2011 19:51:32 -0200 Roberto Spadim <roberto@spadim.com.br>
wrote:

> now, a question....
> 
> if raid1 is like raid10 (one disk = raid0)
> why not only one raid1 (raid10) software implementation?
> for example, if i have 4 disks and i want 4 mirrors.
> why not work with only raid10? why the option since we have all
> features of raid1 inside raid10?
> is it to allow small source code (a small ARM rom)? memory usage? cpu
> usage? easy to implement?

It is mostly "historical reasons".
RAID1 already existed.  When I wrote RAID10 I wanted to keep it separate so
as not to break RAID1.  I have never had a good reason to merge the two
implementations.

And RAID1 does have some functionality that RAID10 doesn't, like write-behind.
Also RAID1 doesn't have a chunk size.  RAID10 does.

NeilBrown
