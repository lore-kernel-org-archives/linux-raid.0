From: Neil Brown <neilb@suse.de>
Subject: Re: about faulty spare-disk interrupts synchronization
Date: Thu, 24 Dec 2009 10:31:17 +1100
Message-ID: <20091224103117.26ec3f04@notabene>
References: <200912231951301400282@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200912231951301400282@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "spren.gm@gmail.com" <spren.gm@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 23 Dec 2009 19:51:33 +0800
"spren.gm@gmail.com" <spren.gm@gmail.com> wrote:

> Hi,
> Is it intended that when a spare disk status gets faulty (detached from raid or really faulty) 
> synchronization is interrupted ? We found that case several days ago with kernel version of 2.6.24, 
> after we unplugged a spare disk of a raid5 which had bitmap and was recovering, the spare disk 
> status became faulty  and synchronization restarted from 0%. 
> 
> Looking into the md code, i find that in md/md.c/md_error(), it doesn't make a difference between 
> spare disks and normal disks. Should we make a faulty spare disk not interrupt raid synchronization ?
> Disks nowadays have become much larger, and recovering one disk may cost several hours or even longer.
>

Yes, it is intended that any synchronisation is interrupted when any device
fails.
However if the device was just an inactive spare, then the synchronisation
should start again from the same place that it was up to, it at least it
should repeat the already-done part very very quickly.

Can you test on a more recent kernel?

Can you give precise details of steps and kernel log messages and mdstat
output?

NeilBrown
