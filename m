From: "NeilBrown" <neilb@suse.de>
Subject: Re: Starting RAID 5
Date: Fri, 15 May 2009 12:34:10 +1000 (EST)
Message-ID: <adb53d3552334dd6c949c4c029ae7135.squirrel@neil.brown.name>
References: <20090515021521914.KSFT13751@cdptpa-omta01.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090515021521914.KSFT13751@cdptpa-omta01.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, May 15, 2009 12:15 pm, Leslie Rhorer wrote:
>
> OK, I've torn down the LVM backup arraqy and am rebuilding it as a RAID 5.
> I've had problems with this before, and I'm having them, again.  I created
> the array with:
>
> mdadm --create /dev/md0 --raid-devices=7 --metadata=1.2 --chunk=256
> --level=5 /dev/sd[a-g]
>
> whereupon it creates the array and then immediately removes /dev/sdg and
> makes it a spare.  I think I may have read where this is normal behavior.

Correct. Maybe you read it in the mdadm man page.


> I can't get it to do an initial resync or promote the spare, however.

So it doesn't start recovery straight away? That is odd...
Maybe it is in read-auto mode.  I should probably get mdadm to poke
it out of that.

If it is just start creating the filesystem or whatever you want to
do, that will prod it into action.

If not (check /proc/mdstat), what kernel log messages are them from the
time when you created the array.

NeilBrown

