From: Stephen Lee <splee@plexio.com>
Subject: Typo in mdadm man page?
Date: 06 Nov 2002 07:22:55 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1036596176.15341.16.camel@ralph.plexio.private>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I was trying to figure out how to add a hot spare to a 3 drive raid5
array and came across the following in the mdadm man page:

MANAGE MODE
       Usage: mdadm device options... devices...

       This usage will allow individual devices in an array to be
       failed,  removed or added.  It is possible to perform mul=AD
       tiple operations with on command. For example:
         mdadm /dev/md0 -f /dev/hda1 -r /dev/hda1 /a /dev/hda1
       will firstly mark /dev/hda1 as faulty in /dev/md0 and will
       then  remove  it from the array and finally add it back in
       as a spare.  However only one md array can be affected  by
       a single command.

I presume the "/a" in the mdadm command should be "-a"? Would it be
possible to add a few more words to be more explicit about adding hot
spares to an existing active array? For example, it would be more
comforting to know that "mdadm /dev/md0 -a /dev/sdd1" to a fully
operational array (no failed devices) generates a hot spare for /dev/md=
0
but does not increase the capacity of /dev/md0.

While I have your attention, does adding the hot spare need to be
repeated after a reboot? Would I need to add the command to my rc.local
file?

Thanks!
Stephen


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
