From: Billy Crook <billycrook@gmail.com>
Subject: Re: Is My Data DESTROYED?!
Date: Fri, 23 Oct 2009 15:32:54 -0500
Message-ID: <a43edf1b0910231332t48bb8357ib2bd9351a913fe5d@mail.gmail.com>
References: <70ed7c3e0910221840o795a61b9u77774725386868e2@mail.gmail.com>
	<222314.82857.qm@web38801.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <222314.82857.qm@web38801.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: adfas asd <chimera_god@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Oct 22, 2009 at 21:04, adfas asd <chimera_god@yahoo.com> wrote:
> How could this possibly have happened? =A0The whole idea of RAID is s=
o something like this won't happen.

Actually no.  No it is not at all.  The point of raid it is to provide
larger and faster block devices than otherwise physically exist, and
in some cases allow you to change out failed drives without making the
array unavailable for use.

I believe you are confusing raid with backup.  You won't do that
again.  If your data isn't completely disposable, I'd recommending
breaking that raid10 array into two raid0's, on two separate machines,
and rsyncing between them.  Each individual raid0 array should
actually be even faster this way, and you'll definitely have more read
IO available using two machines.

> I was using JFS.
>
> I've lost confidence now in mdadm. =A0I have too much data to back up=
 practically, and am now at a loss.

mdadm works fine.  But it is not to be used as bubble gum, or a web
browser, or a text editor, or backup.

Reply with an mdadm -E /dev/sd[abcd].  Once the array assembles, your
problem is with JFS.  The machine was malfunctioning when you pulled
power.  It is entirely possible that its malfunction caused it to
corrupt the filesystem beyond recovery.  mdadm's job (and the job of
any raid solution software or hardware) is to immediately and
irrevocably accept the io from the filesystem driver, and pass it on
to the disks.

The easiest and cleanest solution is to dd the first and last 100mb or
so of the disks with /dev/zero.  Remake the array.  Use something
sensible like ext4 this time, and restore your backups on to it.  If
you don't have any backups to restore, you will next time.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
