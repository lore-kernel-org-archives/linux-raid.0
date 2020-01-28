From: Song Liu <song@kernel.org>
Subject: Re: Pausing md check hangs
Date: Tue, 28 Jan 2020 10:04:00 -0800
Message-ID: <CAPhsuW4JJiDroE33m0=XE9PxtUOncK3--waY_zxxbAT9j+1m6g@mail.gmail.com>
References: <2ce8813c-fd3e-5e78-39ac-049ddfa79ff6@icdsoft.com>
 <CAPhsuW4Jc-qef9uW-JSut90qOpDc_4VoAFpMU8KwqnK7EeT_xg@mail.gmail.com> <ac3ae81d-8dad-8b4e-bc61-fc37514e3929@icdsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ac3ae81d-8dad-8b4e-bc61-fc37514e3929@icdsoft.com>
Sender: linux-raid-owner@vger.kernel.org
To: Georgi Nikolov <gnikolov@icdsoft.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Jan 28, 2020 at 12:11 AM Georgi Nikolov <gnikolov@icdsoft.com> wrote:
>
> Yes the kernel is 4.19.67-2+deb10u2. I have tried with 5.4.8-1~bpo10+1
> and same thing happened.
> Before this i have used same thing for a long time with kernel 4.9.189-3.
> It happens most often when there is some heavy IO.

Thanks for the information. I suspect the hang is waiting for md_lock().

Could you please dump the mdX_raid6 stack when the hang happens?
You can do it by:

    cat /proc/$(pidof mdX_raid6)/stack

Thanks,
Song
