From: NeilBrown <neilb@suse.de>
Subject: Re: failed to write superblock errors, and more!
Date: Tue, 15 Feb 2011 15:24:36 +1100
Message-ID: <20110215152436.1351c219@notabene.brown>
References: <AANLkTinedfgQ5xjqKvM_v3Y6D2Fz=Eq0H1ZjmTcLuz+C@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinedfgQ5xjqKvM_v3Y6D2Fz=Eq0H1ZjmTcLuz+C@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 14 Feb 2011 22:00:46 -0600 Jon Nelson
<jnelson-linux-raid@jamponi.net> wrote:

> I'm wondering what's going on here:
> 
> turnip:~ # mdadm /dev/md1 --create --level=1 --bitmap=internal
> --raid-devices=2 /dev/sdd1 missing
> mdadm: array /dev/md1 started.

So far, so good.

> turnip:~ # mdadm /dev/md2 --create --level=1 --bitmap=internal
> --raid-devices=2 /dev/md1 missing
> mdadm: failed to write superblock to /dev/md1

Probably your device is an exact multiple of 64K in size, and is of such a
size that mdadm choose a bitmap size between 60K and 64K.  This doesn't fit
and initialising the bitmap fail.  Fixed in newer releases.

> mdadm: array /dev/md2 started.

oops.  mdadm ignores the error status after printing the 'failed to write
superblock' message.  Note added to my to-do list.

> turnip:~ # mdadm /dev/md2 --stop

Normal usage is:
  mdadm --stop /dev/md2
Putting them in the other order should either work or give an error message.
It currently does neither.  Note added to my to-do list.

Remaining messages are because /dev/md2 is not stopped.

NeilBrown


> turnip:~ # mdadm --zero-superblock /dev/md1
> mdadm: Couldn't open /dev/md1 for write - not zeroing
> turnip:~ # mdadm /dev/md1 --stop
> turnip:~ # mdadm --zero-superblock /dev/sdd1
> mdadm: Couldn't open /dev/sdd1 for write - not zeroing
> turnip:~ # mdadm /dev/md2 --stop
> turnip:~ # mdadm /dev/md2 --stop --force
> turnip:~ # ls /sys/block/md1/holders/
> md2
> turnip:~ #
> 
> The kernel is 2.6.34.7-0.7-default (x86_64).  openSUSE 11.3.
> mdadm 3.0.3
> 

