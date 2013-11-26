From: Dmitrijs Ledkovs <xnox@debian.org>
Subject: Re: dm-raid45?
Date: Tue, 26 Nov 2013 23:32:52 +0000
Message-ID: <CANBHLUgEj5VjLbzuO+cu=fTRwsNQX3ZD7cCPa5=6k21S_wF5Qg@mail.gmail.com>
References: <CAGRSmLv9vpLRr=WdY+YJFhE9aZfGYtYbegTo=g6MUPz5z+NSww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRSmLv9vpLRr=WdY+YJFhE9aZfGYtYbegTo=g6MUPz5z+NSww@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "David F." <df7729@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 26 November 2013 18:07, David F. <df7729@gmail.com> wrote:
> As a workaround to the mdadm issue with the spare drive we were going
> to have them activate DMRAID but that ends up with the information
> below.  Specifically something about dm-raid45 but we had to drop that
> because it no longer compiles in the latest kernels and we couldn't
> find an update that would.   Any ideas?  (still working on getting the
> dump - the fact that tmpfs doesn't support sparse files makes having
> the customer create the dump via a script we provide a bit more
> involved):
>

Ubuntu kernels still somewhat maintain and have dm-raid-45 module.

Install linux-image-extra-virtual package which will pull in correct
versioned packaged with extra modules.

It is planned however to migrate off & drop dm-raid-45 module soon.

ps. latest version I can find is
3.8.0-22-generic/kernel/ubuntu/dm-raid4-5/dm-raid45.ko

Regards,

Dmitrijs.
