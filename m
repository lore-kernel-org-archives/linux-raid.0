From: Bernd Schubert <bernd-schubert@web.de>
Subject: messages after server crash
Date: Mon, 11 Nov 2002 15:26:37 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200211111526.37325.bernd-schubert@web.de>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="------------Boundary-00=_DG1FJZEWZXFYKM32GA5T"
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--------------Boundary-00=_DG1FJZEWZXFYKM32GA5T
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

after our server crashed on Friday and Sunday, we can see some strange ra=
id=20
related messages in the logs (please see the messages below).

Well, the 'delaying resync ...' messages are easy to understand, but are =
they=20
related to the 'resync aborted' messages ? At least the /proc/mdstat look=
s=20
fine.

The bzip2-output of dmesg (that might give more information about what is=
=20
going on) is attached.


So do we have do worry about something going wrong with the software raid=
 ?=20

Of course, we are a bit worried about the the crashes at all, since this =
never=20
happend before.


Thanks in advance,

Bernd


PS: The kernel is a vanilla 2.4.19 with some of Neils NFS-patches that we=
nt=20
into 2.4.20pre1 (all except the tcp-patches).


Nov 10 11:38:31 coulomb kernel: raid5: resync aborted!
Nov 10 11:38:31 coulomb kernel: md: delaying resync of md1 until md0 has
finished resync (they share one or more physical units)
Nov 10 11:38:31 coulomb kernel: md: delaying resync of md2 until md0 has
finished resync (they share one or more physical units)
Nov 10 11:38:31 coulomb kernel: md: delaying resync of md3 until md0 has
finished resync (they share one or more physical units)
Nov 10 11:38:31 coulomb kernel: raid5: resync aborted!
Nov 10 11:38:31 coulomb kernel: md: delaying resync of md1 until md0 has
finished resync (they share one or more physical units)
Nov 10 11:38:31 coulomb kernel: md: delaying resync of md2 until md0 has
finished resync (they share one or more physical units)
Nov 10 11:38:31 coulomb kernel: raid5: resync aborted!
Nov 10 11:38:31 coulomb kernel: md: delaying resync of md1 until md0 has
finished resync (they share one or more physical units)
Nov 10 11:38:31 coulomb kernel: raid5: resync aborted!
Nov 10 11:38:31 coulomb kernel: md: recovery thread got woken up ...
Nov 10 11:38:31 coulomb kernel: md: recovery thread finished ...
Nov 10 11:38:31 coulomb kernel: md: md_do_sync() got signal ... exiting
Nov 10 11:38:31 coulomb kernel: raid5: resync aborted!

coulomb:~ # cat /proc/mdstat
Personalities : [raid5]
read_ahead 1024 sectors
md4 : active raid5 sde8[4] sdd8[3] sdc8[2] sdb8[1] sda8[0]
      33960960 blocks level 5, 32k chunk, algorithm 2 [5/5] [UUUUU]

md3 : active raid5 sde7[4] sdd7[3] sdc7[2] sdb7[1] sda7[0]
      31261952 blocks level 5, 32k chunk, algorithm 2 [5/5] [UUUUU]

md2 : active raid5 sde6[4] sdd6[3] sdc6[2] sdb6[1] sda6[0]
      31261952 blocks level 5, 32k chunk, algorithm 2 [5/5] [UUUUU]

md1 : active raid5 sde5[4] sdd5[3] sdc5[2] sdb5[1] sda5[0]
      31261952 blocks level 5, 32k chunk, algorithm 2 [5/5] [UUUUU]

md0 : active raid5 sde1[4] sdd1[3] sdc1[2] sdb1[1] sda1[0]
      15614720 blocks level 5, 32k chunk, algorithm 2 [5/5] [UUUUU]



--------------Boundary-00=_DG1FJZEWZXFYKM32GA5T
Content-Type: application/x-bzip2;
  name="dmesg.out.bz2"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="dmesg.out.bz2"

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
iLACqjXt5iT6FqJ1f+LuSKcKEh5rIY8A

--------------Boundary-00=_DG1FJZEWZXFYKM32GA5T--
