From: David Rea <dave@daverea.com>
Subject: Re: RAID-5 spare drive: Can't make spare persist across reboot
Date: Sat, 30 May 2009 20:31:38 -0400
Message-ID: <984c80610905301731q118d6b80m3afdea744afa39bf@mail.gmail.com>
References: <984c80610905301137l7649391fg64a8108769abd216@mail.gmail.com>
	 <18977.43758.674932.381022@notabene.brown>
	 <984c80610905301526h6a71b79cyd1cb66c992db355a@mail.gmail.com>
	 <f9fa44a3d9376b5e2b4c624bd36fab89.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f9fa44a3d9376b5e2b4c624bd36fab89.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, May 30, 2009 at 6:44 PM, NeilBrown <neilb@suse.de> wrote:

>> Here is the output of `cat /var/log/messages | grep raid`:
>> http://pastebin.ca/1441575
>
> That isn't very useful. =A0Getting the whole /var/log/messasges
> would be best - then I can see what isn't there as well as what is.
> maybe
> =A0 grep -C 10 -E '(md|raid)' /var/log/messages
> might be enough.

Here is the output of that command, somewhat lengthy: http://pastebin.c=
a/1441666
(inline from now on)

> That would be because the array was assembled without /dev/sdb1
> so even if sda knew about it before, it will have been told to forget=
=2E

I'm assuming that the array is re-assembled at every boot (per
http://linux-raid.osdl.org/index.php/RAID_setup#Using_the_Array); will
doing an explicit re-assmeble using `mdadm --assemble` correct this on
a "stickier" basis? How can I instruct the kernel to assemble the
array *with* /dev/sdb1 every time? I originally thought this was done
based on /etc/mdadm/mdadm.conf?

> Is there a reason why you are using whole drives (sda, sdc, sdd) for
> some devices, and just a partition (sdb1) for others?

When I originally created this array (2006), it only had the 3 active
drives, and I used the entire devices because I didn't know any
better. When I rebuilt the machine more recently (2008) I added a
larger boot drive, and had plenty of extra space to reserve a
partition to use as a spare for the array.

I happen to have several 1TiB SATA drives (awaiting build into a
different RAID machine) sitting around, so I could back up this array
and re-create it if that's the only way we can make the spare
persistent.

Thanks,
Dave
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
