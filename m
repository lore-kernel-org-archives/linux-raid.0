From: Alireza Haghdoost <alireza@cs.umn.edu>
Subject: Re: Inject I/O latency for RAID5/6 read and writes
Date: Thu, 12 Mar 2015 16:31:36 -0500
Message-ID: <CAB-428=f7eL3iD=0g9MsYV78KUng_dysEs+=70taPP9wh_UkbQ@mail.gmail.com>
References: <CAB-428=gcsgxa1k83h0QWmijhe_kXaLMQZqs+m=Zb0OWX06geA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB-428=gcsgxa1k83h0QWmijhe_kXaLMQZqs+m=Zb0OWX06geA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On Mon, Feb 23, 2015 at 12:32 PM, Alireza Haghdoost <alireza@cs.umn.edu> wrote:
> I needed to inject I/O completion latency in the RAID5/6 codes for
> test purpose. I was wondering where would be the good place in
> md/raid5.c code to add delay ?
>
> So far I have tried adding mdelay/udelay in raid5_end_write_request()
> and it seems it works to increase I/O completion of writes. However,
> adding delay in raid5_end_read_request() does not really change the
> read I/O latency. Any idea ?
>
> --Alireza

Can Some one help me on this issue ?
