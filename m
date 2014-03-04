From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: RAID5 hard freeze
Date: Tue, 04 Mar 2014 12:57:08 +0100
Message-ID: <5315BF94.50803@fastmail.fm>
References: <CAF8Fvyz2PnEd=t=E-xUuG6anoLhm1zJCn0txD=P_aE_5AmoVUw@mail.gmail.com>	<20140225135809.0b1afc69@notabene.brown>	<CAF8Fvyy3DqXZPx83Bk1bTgws5W0Z9Zm-XkE86En9uJk886zERg@mail.gmail.com> <CAF8FvyxaXNHEAqdsfGfF-j_di9W=a5Mx3GwOFyoA_NHea-x+5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAF8FvyxaXNHEAqdsfGfF-j_di9W=a5Mx3GwOFyoA_NHea-x+5g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Denis Golovan <denis.golovan@gmail.com>, NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/01/2014 03:54 PM, Denis Golovan wrote:
> Hi again
>
> I was contacted by a person who suggested to double-check
> vfs_cache_pressure setting.
> And it appeared that I had this setting set to 10000. That was a
> left-over from previously debugging OOM-killer case.
>
> When I removed this setting from sysctl.conf, I was able to greatly
> increase the time to crash/freeze.
> My server was able to withstand about a day of continuous write test.
>
> Nevertheless, it froze after that.
>
> Still it looks like something is wrong with RAID/filesystem co-operation.

But why should it be RAID/filesystem and not hardware related or another 
linux subsystem?

>
> I would still like to debug the problem.
> Please help.

The only way to get more help and information is probably to attach a 
real serial console (i.e. ipmi-sol).


Bernd

