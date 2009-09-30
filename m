From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: BUG: soft lockup in [md4_raid5:21137]
Date: Tue, 29 Sep 2009 18:06:22 -0700
Message-ID: <e9c3a7c20909291806o6985259doc911012dd88dc76c@mail.gmail.com>
References: <Pine.LNX.4.64.0909181255380.21814@diagnostix.dwd.de>
	 <e9c3a7c20909181055u5d66086chd199f48453c476d8@mail.gmail.com>
	 <Pine.LNX.4.64.0909290914330.24558@praktifix.dwd.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0909290914330.24558@praktifix.dwd.de>
Sender: linux-raid-owner@vger.kernel.org
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Sep 29, 2009 at 2:24 AM, Holger Kiehl <Holger.Kiehl@dwd.de> wro=
te:
> On Fri, 18 Sep 2009, Dan Williams wrote:
> __async_schedule+0x10e/0x130
> =A0 Sep 29 09:02:15 apollo kernel: [<ffffffff8108ad7e>] ?
> async_schedule_domain+0x1c/0x32
> =A0 Sep 29 09:02:15 apollo kernel: [<ffffffff81379852>] ? raid5d+0x3f=
8/0x44c
> =A0 Sep 29 09:02:15 apollo kernel: [<ffffffff81446b68>] ?
> _spin_unlock_irqrestore+0x21/0x3c
> =A0 Sep 29 09:02:15 apollo kernel: [<ffffffff81383db1>] ?
> md_thread+0x100/0x132
> =A0 Sep 29 09:02:15 apollo kernel: [<ffffffff81084113>] ?
> autoremove_wake_function+0x0/0x5a
> =A0 Sep 29 09:02:15 apollo kernel: [<ffffffff81383cb1>] ? md_thread+0=
x0/0x132
> =A0 Sep 29 09:02:15 apollo kernel: [<ffffffff81083d04>] ? kthread+0x8=
9/0x91
> =A0 Sep 29 09:02:15 apollo kernel: [<ffffffff8102f36a>] ? child_rip+0=
xa/0x20
> =A0 Sep 29 09:02:15 apollo kernel: [<ffffffff81083c7b>] ? kthread+0x0=
/0x91
> =A0 Sep 29 09:02:15 apollo kernel: [<ffffffff8102f360>] ? child_rip+0=
x0/0x20
>
> The system also becomes very unresponsive. How can I fix this since i=
t
> looks your patch does not apply to 2.6.32-rc1. Or is this another bug=
,
> since I have enabled CONFIG_MULTICORE_RAID456.

This is a new issue with the (experimental) multicore implementation.
If you turn that off then you will be using the same single threaded
flow as 2.6.31.  If you want to play with the multicore option a bit
more the patch below should squelch the softlockup.  However, I
suspect we will need our own md specific thread pool because the
current implementation spends too much effort bouncing stripes between
the async thread pool and raid5d.

--
Dan

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 1898eda..733d658 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4357,6 +4357,7 @@ static void __process_stripe(void *param,
async_cookie_t cookie)
 static void process_stripe(struct stripe_head *sh, struct list_head *d=
omain)
 {
        async_schedule_domain(__process_stripe, sh, domain);
+       cond_resched();
 }

 static void synchronize_stripe_processing(struct list_head *domain)
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
