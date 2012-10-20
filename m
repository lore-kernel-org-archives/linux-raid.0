From: Phil Turmel <philip@turmel.org>
Subject: Re: Dead three-disk RAID-5. Help?
Date: Fri, 19 Oct 2012 23:59:56 -0400
Message-ID: <508221BC.6080007@turmel.org>
References: <CAHw0J8hx+_siPsd7ZQN=WKy2yTpiSzyKk1ULUKa+HBbEwsy8pQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHw0J8hx+_siPsd7ZQN=WKy2yTpiSzyKk1ULUKa+HBbEwsy8pQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ken <ravenpi@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Ken,

On 10/19/2012 11:19 PM, Ken wrote:
> I'm currently highly suspicious that I executed the wrong command in
> the wrong window -- which would mean that I blew away the partition
> table, and fsck'd the new partitions, on /dev/sda.  Which
> theoretically leaves me with /dev/sdb and /dev/sdc, no?  Except that
> when I try to access them, it won't allow me to create the array.  If
> I try the whole thing, it either tells me there's no partition table
> on /dev/md0, or that it can't find the superblock on /dev/md0.

Pretty thin on information to help us help you.

Please go through your shell command history to show us some of the
things you tried.  Also, what distribution & version?

Some commands to run to give us information to start with (attach the
long ones to your e-mail as plain text):

uname -a
mdadm --version
dmesg
cat /proc/partitions
cat /proc/mdstat
mdadm -D /dev/md0
mdadm -E /dev/sd[abc]

{repeat the last two for any other arrays or member devices involved.
Partitions, perhaps?}

> Any pointers on where to go from here would be very much appreciated
> -- as (of course) the irony is that the system I *meant* to be
> fsck'ing was intended to back up the original system.

There are so many possible ways to set things up that we really need
more information.

> Thank you kindly,

You're welcome.

Phil

