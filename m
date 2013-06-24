From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Preparing for mdadm-3.3
Date: Mon, 24 Jun 2013 06:44:25 -0700
Message-ID: <CAK2H+ef9Zs0rQsGtB5BTOV6bYGXQ_n=Ld_9Lq63x9gBbDnFPog@mail.gmail.com>
References: <20130624171818.71a9688a@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130624171818.71a9688a@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Jun 24, 2013 at 12:18 AM, NeilBrown <neilb@suse.de> wrote:
<SNIP>
>
> I somehow got unsubscribed from linux-raid (again) a few weeks back, so if
> anything was sent to the list and not me that I should know about, now might
> be a good time to resend that too.
>
> Thanks,
> NeilBrown

Neil,
   Welcome back. :-)

   I currently run mdadm-3.1.4 which is Gentoo stable. It seems that I
cannot change chunk size if the new chunk size doesn't divide evenly
into the number of sectors on the partition, or at least that's the
way I understand the message. Is that anything you've either worked on
or considered for mdadm?

Thanks,
Mark
