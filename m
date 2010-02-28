From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: mdadm software raid + ext4, capped at ~350MiB/s
 limitation/bug?
Date: Sun, 28 Feb 2010 10:03:04 -0500 (EST)
Message-ID: <alpine.DEB.2.00.1002281000120.22822@p34.internal.lan>
References: <alpine.DEB.2.00.1002270840410.27192@p34.internal.lan>  <20100228080100.092c24c2@notabene.brown>  <alpine.DEB.2.00.1002271624480.12663@p34.internal.lan>  <4B89B44A.70005@tmr.com>  <alpine.DEB.2.00.1002280444530.16775@p34.internal.lan>
 <170fa0d21002280633x2ea6a281tf53996834c46d831@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; FORMAT=flowed
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <170fa0d21002280633x2ea6a281tf53996834c46d831@mail.gmail.com>
Content-ID: <alpine.DEB.2.00.1002281000511.22822@p34.internal.lan>
Sender: linux-ext4-owner@vger.kernel.org
To: Mike Snitzer <snitzer@gmail.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids



On Sun, 28 Feb 2010, Mike Snitzer wrote:

> On Sun, Feb 28, 2010 at 4:45 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:

[ .. ]

>
> How did you format the ext3 and ext4 filesystems?
>
> Did you use mkfs.ext[34] -E stride and stripe-width accordingly?
> AFAIK even older versions of mkfs.xfs will probe for this info but
> older mkfs.ext[34] won't (though new versions of mkfs.ext[34] will,
> using the Linux "topology" info).

Yes and it did not make any difference:
http://lkml.org/lkml/2010/2/27/77

Incase anyone else wants to try too, you can calculate by hand, or if you
are in a hurry, I found this useful:
http://busybox.net/~aldot/mkfs_stride.html

I believe there is something fundamentally wrong with ext4 when performing 
large sequential I/O when writing, esp. after Ted's comments.

Justin.

