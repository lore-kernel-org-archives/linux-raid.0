From: Song Liu <song@kernel.org>
Subject: Re: Pausing md check hangs
Date: Mon, 3 Feb 2020 15:31:56 -0800
Message-ID: <CAPhsuW6wZ_n1BVP6+nZ12MgnkM1OgmzSs+KeC0tGDvX-RG3KvA@mail.gmail.com>
References: <2ce8813c-fd3e-5e78-39ac-049ddfa79ff6@icdsoft.com>
 <CAPhsuW4Jc-qef9uW-JSut90qOpDc_4VoAFpMU8KwqnK7EeT_xg@mail.gmail.com>
 <ac3ae81d-8dad-8b4e-bc61-fc37514e3929@icdsoft.com> <CAPhsuW4JJiDroE33m0=XE9PxtUOncK3--waY_zxxbAT9j+1m6g@mail.gmail.com>
 <cc483055-45de-4bd2-8a4f-71e9c8ed6b90@icdsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cc483055-45de-4bd2-8a4f-71e9c8ed6b90@icdsoft.com>
Sender: linux-raid-owner@vger.kernel.org
To: Georgi Nikolov <gnikolov@icdsoft.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Feb 1, 2020 at 6:26 AM Georgi Nikolov <gnikolov@icdsoft.com> wrote:
>
> The output of this command was empty:
>
> cat /proc/$(pidof md2_raid6)/stack # md2_raid6 process was consuming
> 100% cpu

Hmm... This is weird. Could you try use perf or some other tools to get insights
on what the thread is doing?

Thanks,
Song
