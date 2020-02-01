From: Georgi Nikolov <gnikolov@icdsoft.com>
Subject: Re: Pausing md check hangs
Date: Sat, 1 Feb 2020 16:26:38 +0200
Message-ID: <cc483055-45de-4bd2-8a4f-71e9c8ed6b90@icdsoft.com>
References: <2ce8813c-fd3e-5e78-39ac-049ddfa79ff6@icdsoft.com>
 <CAPhsuW4Jc-qef9uW-JSut90qOpDc_4VoAFpMU8KwqnK7EeT_xg@mail.gmail.com>
 <ac3ae81d-8dad-8b4e-bc61-fc37514e3929@icdsoft.com>
 <CAPhsuW4JJiDroE33m0=XE9PxtUOncK3--waY_zxxbAT9j+1m6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPhsuW4JJiDroE33m0=XE9PxtUOncK3--waY_zxxbAT9j+1m6g@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <song@kernel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

The output of this command was empty:

cat /proc/$(pidof md2_raid6)/stack # md2_raid6 process was consuming 
100% cpu

> Thanks for the information. I suspect the hang is waiting for md_lock().
>
> Could you please dump the mdX_raid6 stack when the hang happens?
> You can do it by:
>
>      cat /proc/$(pidof mdX_raid6)/stack
>
> Thanks,
> Song


Regards,

Georgi Nikolov
