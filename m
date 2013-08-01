From: Doug Ledford <dledford@redhat.com>
Subject: Re: RFC swap over raid1
Date: Thu, 01 Aug 2013 19:04:37 -0400
Message-ID: <51FAE985.1040809@redhat.com>
References: <CAH3kUhFoNKgHErujKuCLMvx_qbDa2dwhW+sMD=7W9W0hHTWB-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH3kUhFoNKgHErujKuCLMvx_qbDa2dwhW+sMD=7W9W0hHTWB-w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 08/01/2013 06:11 PM, Roberto Spadim wrote:
> hi guys, should i use raid1 with swap partitions? why?
> 
> example:
> swapon /dev/sda1
> mdadm --create /dev/md-swap --level=1 --raid-devices=2 /dev/sda /dev/sdb

You can't do this.  You've just corrupted your hard drives.  The reason
is that you've set /dev/sda1 to be used for swap, then you've made a
raid1 array from the entirety of /dev/sda and /dev/sdb, which of course
includes the space in /dev/sda1, which is already in use.

> mkswap /dev/md-swap

Here you've just turned all of /dev/sda into a swap device (as well as
/dev/sdb).

> swapon /dev/md-swap

And here you've turned on a swap device that is /dev/sda and which will
overlap with the swap you already enabled on /dev/sda1.  You're using
the same space twice.  It's definitely corrupted and broken.
Fortunately, I'm pretty sure the kernel won't even allow you to do all
of this.  You would have been stopped at the mdadm --create because
/dev/sda1 was in use so /dev/sda couldn't be allocated to the newly
created md raid array.

> what's the advantages and disvantages?
> should i use raid0, linear, raid1, raid10, raid5 or raid6?

These are all the same basic questions as if you were running something
other than swap.  The same tradeoffs exists.  Although I would never use
raid4/5/6 for swap as you don't want to have to use parity on your swap,
and raid10 is overkill.  If you use raid0 or linear and loose a drive,
you can crash your machine when the swap is needed.  I only use raid1
(if I use swap at all, which is not that often any more).

> or just two swap partitions and run this way:
> swapon /dev/sda
> swapon /dev/sdb
> ?

What exactly do you think swapon does?  Because you've just allocated
all of /dev/sda and /dev/sdb to swap and they can't be used for anything
else.
