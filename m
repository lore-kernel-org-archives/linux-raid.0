From: Phil Turmel <philip@turmel.org>
Subject: Re: mdadm-grow-continue service crashing (similiar to "raid5 reshape
 is stuck" thread from May)
Date: Sun, 12 Jul 2015 09:45:09 -0400
Message-ID: <55A26F65.5020703@turmel.org>
References: <CACsGCySTbrEYddSNfi7+9KnxWeddkBGDbxTsBSJkkvGHOaJwKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACsGCySTbrEYddSNfi7+9KnxWeddkBGDbxTsBSJkkvGHOaJwKg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Edward Kuns <eddie.kuns@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Edward,

On 07/12/2015 02:02 AM, Edward Kuns wrote:

[trim /]

> The short version of the story is that I replaced the dead drive and
> let the raid5 partition rebuild.  Then I added a new drive and let the
> partition rebuild.  Then I removed the not-yet-dead drive and here is
> where I ran into the same problem as the other poster.  Basically, I
> did this to replace the still-working-but-suspect device, after the
> partition completed rebuilding when I replaced the actually-dead
> drive:
> 
> mdadm --manage /dev/md125 --add /dev/sdf1
> mdadm --grow --raid-devices=5 /dev/md125
> 
>  ... wait for the rebuild to complete
> 
> mdadm --fail /dev/md125 /dev/sdd2
> mdadm --remove /dev/md125 /dev/sdd2
> mdadm --grow --raid-devices=4 /dev/md125
> 
> mdadm: this change will reduce the size of the array.
>        use --grow --array-size first to truncate array.
>        e.g. mdadm --grow /dev/md125 --array-size 118964736
> 
> mdadm --grow /dev/md125 --array-size 118964736
> mdadm --grow --raid-devices=4 /dev/md125
> 
> ... this failed with a mysterious complaint about my first partition
> (Cannot set new_offset).  Research got me to try:
> 
> mdadm --grow --raid-devices=4 /dev/md125 --backup-file /root/md125.backup

Why were you using --grow for these operations only to reverse it?  This
is dangerous if you have a layer or filesystem on your array that
doesn't support shrinking.  None of the --grow operations were necessary
in this sequence to achieve the end result of replacing disks.

> .... here everything ground to a halt.  The reshape was at 0% and
> there was no disk activity.
> 
> The solution was to edit
> /lib/systemd/system/mdadm-grow-continue@.service to look like this (it
> was important that the backup file was placed in /tmp and not in /root
> or anywhere else.  SELinux allowed mdadm to create a file in /tmp by
> not anywhere else I tried):

I'm not an SELinux guy, so I can't help with the rest, but you should
know that many modern distros delete /tmp on reboot and/or play games
with namespaces to isolate different users' /tmp spaces.

[trim /]

> I did a fail, remove, and
> add on /dev/sdd1  and it very quickly synced and came into service.
> The command "mdadm --detail /dev/md125" now shows a happy raid5 with
> four partitions in it, all "active sync"

These are the only operations you should have done in the first place.
Although I would have put the --add first, so the --fail operation would
have triggered a rebuild onto the spare right away.  At no point should
you have changed the number of raid devices.

And for the still-running but suspect drive, the --replace operation
would have been the right choice, again, after --add of a spare.

HTH,

Phil
