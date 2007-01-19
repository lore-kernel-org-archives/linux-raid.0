From: "Daniel Korstad" <dan@korstad.net>
Subject: upgrade to mdadm 2.6 x86_64 issues
Date: Thu, 18 Jan 2007 19:22:17 -0600
Message-ID: <167578845.1169169737952.JavaMail.root@gateway.korstad.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I have a Fedora Core 4 on a 64 bit system running a x86_64 FC4;


[root@gateway ~]# uname -a
Linux gateway.korstad.net 2.6.17-1.2142_FC4 #1 Tue Jul 11 22:41:06 EDT =
2006 x86_64 x86_64 x86_64 GNU/Linux


Running;

[root@gateway ~]# mdadm --version
mdadm - v2.5.4 - 13 October 2006


I thought I would pull down the latest (2.6) and compile, but it errors=
 out on the make;

gcc -Wall -Werror -Wstrict-prototypes -ggdb -DSendmail=3D\""/usr/sbin/s=
endmail -t"\" -DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mda=
dm/mdadm.conf\" -c -o super1.o super1.c
cc1: warnings being treated as errors
super1.c: In function =E2update_super1=E2:
super1.c:579: warning: format =E2%llu=E2 expects type =E2long long unsi=
gned int=E2, but argument 2 has type =E2__u64=E2
super1.c:582: warning: format =E2%llu=E2 expects type =E2long long unsi=
gned int=E2, but argument 2 has type =E2__u64=E2
make: *** [super1.o] Error 1
[root@gateway mdadm-2.6]#

Does not like the 64bit system?
Lines 579 thru 582

578 (sbv + 1024 + sizeof(struct bitmap_super_s));
579 printf("Size was %llu\n", __le64_to_cpu(sb->data_size));
580 sb->data_size =3D __cpu_to_le64(
581 misc->device_size - __le64_to_cpu(sb->data_offse t));
582 printf("Size is %llu\n", __le64_to_cpu(sb->data_size));
583 }


So, I went down one version from 2.6 to 2.5.6 and the make; make instal=
l ran fine bringing my FC4 64 bit system up from 2.5.4 to 2.5.6 but I c=
an't get to 2.6 apparently.

[root@gateway mdadm-2.5.6]# make install
/usr/bin/install -D -m 644 mdadm.8 /usr/share/man/man8/mdadm.8
/usr/bin/install -D -m 644 md.4 /usr/share/man/man4/md.4
/usr/bin/install -D -m 644 mdadm.conf.5 /usr/share/man/man5/mdadm.conf.=
5
/usr/bin/install -D -m 755 mdadm /sbin/mdadm
[root@gateway ~]# mdadm --version
mdadm - v2.5.6 - 9 November 2006


Cheers,
Dan.
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
