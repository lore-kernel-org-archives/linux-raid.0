From: Norman Schmidt <norman.schmidt@ratnet.stw.uni-erlangen.de>
Subject: wait-option for assembly during boot process ?
Date: Sun, 23 Feb 2003 16:54:27 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E58EEB3.30503@ratnet.stw.uni-erlangen.de>
Reply-To: schmidt@naa.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi folks!

Since some (including me) use software raid (1 and 5 in this case) for=20
swap and ext3 external journal partitions, I would appreciate it if Nei=
l=20
or some of the code hackers (I myself actually don=B4t understand any C=
)=20
could add the following option.

I boot from a software raid / and /boot (which is assembled after an=20
according append to the kernel parameter line (here is the documentatio=
n=20
for that, anyway?)). During the boot process, the other md devices,=20
which hold for example an ext-3 external journal and swap space, and=20
other data partitions, are assembled and mounted (or just used).

But if the last shutdown left the md devices dirty, they are resynced=20
during the next bootup while already in use. For normal ext2/ext3 data=20
partitions, this is no problem, but for swap and possibly ext-3 journal=
s=20
this is deadly.

What I would like to have is an option in mdadm.conf (through which the=
=20
arrays are configured and started automatically) like "WAIT" which hold=
s=20
up the boot process (i.e. usage of the not yet resynced devices) as lon=
g=20
as resync takes. And these devices should be resynced first, so that on=
e=20
does not have to wait for the resync of a terabyte-big data array that=20
uses part of the same disks.

How can I determine the order of assembly anyway? From top to bottom in=
=20
the config file (at least for arrays that don=B4t share the same disks)=
?

Thanks very much, Norman.
--=20
--

Norman Schmidt          Institut f=FCr Physikal. u. Theoret. Chemie
cand. chem.             Friedrich-Alexander-Universitaet
schmidt@naa.net         Erlangen-Nuernberg

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
