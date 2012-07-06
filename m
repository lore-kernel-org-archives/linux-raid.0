From: Dan Williams <dan.j.williams@gmail.com>
Subject: Re: [PATCH] raid5:Only move IO_THRESHOLD stripes from delay_list to
 hold_list in raid5_activate_delayed().
Date: Fri, 6 Jul 2012 11:29:05 -0700
Message-ID: <CAA9_cmdaYF=UjMsjFKMB6P+kdBdfZQmM-ws81K2HQJJn0NqLSw@mail.gmail.com>
References: <201207062038188750110@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201207062038188750110@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Jul 6, 2012 at 5:38 AM, majianpeng <majianpeng@gmail.com> wrote:
> To imporve write performance and as posssible as to achieve full-write,
> it only fetch IO_THRESHOLD stripes from delay_list to hold_list.
>
> Signed-off-by: majianpeng <majianpeng@gmail.com>

Yes, I do think we need something like this to further limit the
maximum in-flight pre-read, especially for the async / multithread xor
case where we process stripes faster.  However, this is the job of
get_priority_stripe(), not raid5_activate_delayed(), to rate limit
pre-reads versus full stripes.  One pre-read stripe at a time seems to
over bias full stripe writes.  I wonder if you see the same
performance effect by echo 0 >
/sys/block/<mddev>/md/preread_bypass_threshold?

--
Dan
