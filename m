From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: enhancements to the raid1 driver
Date: Mon, 17 Feb 2003 13:51:32 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15952.20020.858737.543347@notabene.cse.unsw.edu.au>
References: <3E4D96DB.7AC5954B@SteelEye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Paul Clements on Friday February 14
To: Paul Clements <Paul.Clements@SteelEye.com>
Cc: linux-raid@vger.kernel.org, jejb@SteelEye.com
List-Id: linux-raid.ids

On Friday February 14, Paul.Clements@SteelEye.com wrote:
> Hi,
> 
> I'm just beginning a project to add some new features to the raid1
> driver. The planned features include:
> 
> intent log - a disk-backed bitmap to allow for quick resyncs (Peter T.
> Breuer's fr1 code looks very promising)

An intent log would be just as useful for raid5 as for raid1, so I
think it should be largely supported by md.c rather than specific to
raid1.c

> 
> asynchronous replication - to get acceptable performance when the backup
> leg of the raid1 mirror is slow (e.g., nbd over a LAN or WAN)
> 

Hmmm. I cannot figure out exactly what would be asynchronous...  Nor
can I see how this would require an ioctl.

In general, ioctl's are seen a evils to be avoided, not added, so I am
not in favour of the patch you suggest.

Maybe if you explain more about what would be the specifics of these
ioctls that you want to pass down.

NeilBrown

