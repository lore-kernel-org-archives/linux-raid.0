From: "NeilBrown" <neilb@suse.de>
Subject: Re: mdadm-2.6.4 with linux-2.6.18
Date: Mon, 14 Jul 2008 15:34:43 +1000 (EST)
Message-ID: <47054.192.168.1.70.1216013683.squirrel@neil.brown.name>
References: <b47423310807132217k7c7444c7mdb513b80c0913596@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <b47423310807132217k7c7444c7mdb513b80c0913596@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: kishore goud <kishoreoff@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, July 14, 2008 3:17 pm, kishore goud wrote:
> Hi neil,
>
> I have upgraded from mdadm-2.5.4 to mdadm-2.6.4. I am using linux-2.6.18
> kernel.  Do I need to patch kernel after upgrading mdadm?  If I have to
> patch kernel, Could you please let me know, where are the patches.

No, you don't need to patch the kernel after upgrading mdadm.
Some things might not work in older kernels that do work in newer kernels,
but if you have a reason to stay with 2.6.18, then do so.

>
> Also are patches(kernel-patch-2.6.18/18.6/19) in mdadm-2.6.4, Should I
> apply
> this patch as well.
>

That patch is only needed if you want to use the --incremental functionality
of mdadm.
If you do want to use that functionality, then you should really
upgrade your kernel.
If you don't then don't worry about the patches.

I'll probably remove them from the next release of mdadm.

NeilBrown

