From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Should I Start Over?
Date: Wed, 7 Jul 2004 16:16:29 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200407072016.i67KGT309307@watkins-home.com>
References: <2354.66.230.1.97.1089229246.squirrel@exitwound.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2354.66.230.1.97.1089229246.squirrel@exitwound.org>
To: stephen@exitwound.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Humm.  I would guess it would re-build to the last disk on the command line.
Maybe just enter the command again.  Can't do any more damage!  Then do the
2 commands and send the output.

Did the original array have 3 disks and 1 spare?  If so, ignore the spare
until things are working again.

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Stephen Hargrove
Sent: Wednesday, July 07, 2004 3:41 PM
To: Guy
Cc: linux-raid@vger.kernel.org
Subject: RE: Should I Start Over?

Guy said:
>
> Send me the output from these 2 commands:
> Cat /proc/mdstat

# cat /proc/mdstat
Personalities : [raid5]
read_ahead not set
unused devices: <none>

> mdadm -D /dev/md0

n# mdadm -D /dev/md0
mdadm: md device /dev/md0 does not appear to be active.

As I mentioned, I shut it off when it had reached 1.1% of the rebuild.  I
haven't turned it back on because I don't want it to begin rebuilding
again.  My minimal experience has shown that it will likely pick up where
it left off.  The startup script (Debian Sarge -- /etc/init.d/mdadm-raid)
is going to use /etc/mdadm/mdadm.conf, which is:

# cat /etc/mdadm/mdadm.conf
DEVICE /dev/hd*
ARRAY /dev/md0 level=raid5 num-devices=3
UUID=fef44719:ddd66a49:0a337b48:b53e14c0
   devices=/dev/hdg1,/dev/hdd1,/dev/hdc1

(And apparently doesn't reflect the fact that hde is my spare ...)

> Omit the disk that is being re-built!!!!!!  Not hde1.  hde1 was added as a
> spare.  It may still have good data.  The disk being re-built is toast!
> The other 2 may also have good data.

I'm guessing it was rebuilding hdg since that was the first device I
listed on the commandline.

> If you are not sure, just ask another question.

Thanks, Guy!  I sure do appreciate your assistance.

--
Steve
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

