From: =?UTF-8?B?UmVuw6k=?= <rk@e-inst.de>
Subject: Problems reassembling raid6 with --force option
Date: Sat, 2 Jan 2016 19:13:57 +0100
Message-ID: <56881365.6080701@e-inst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have a software raid6 consisting of 6 drives (sd[f-k] at the moment) =
at md1.
=46or maintainance I deactivated the array via mdadm --stop /dev/md1
As I wanted to reassamble the array later I got the following:

# mdadm --assemble -v /dev/md1=20
mdadm: added /dev/sdk1 to /dev/md1 as 0 (possibly out of date)=20
mdadm: added /dev/sdh1 to /dev/md1 as 2=20
mdadm: added /dev/sdf1 to /dev/md1 as 3=20
mdadm: added /dev/sdj1 to /dev/md1 as 4=20
mdadm: added /dev/sdg1 to /dev/md1 as 5 (possibly out of date)=20
mdadm: added /dev/sdi1 to /dev/md1 as 1=20
mdadm: /dev/md1 has been started with 4 drives (out of 6).


The event counts of the drives were only off by 3:

# mdadm --examine /dev/sd[fghijk]1 | egrep 'Events|/dev/sd'=20
/dev/sdf1:=20
         Events : 17405=20
/dev/sdg1:=20
         Events : 17402=20
/dev/sdh1:=20
         Events : 17405=20
/dev/sdi1:=20
         Events : 17405=20
/dev/sdj1:=20
         Events : 17405=20
/dev/sdk1:=20
         Events : 17402


Reading the man-page and searching the internet I thought --force shoul=
d do the trick. But it didn't:

# mdadm --assemble -v --force /dev/md1 /dev/sd[fghijk]1       =20
mdadm: looking for devices for /dev/md1=20
mdadm: /dev/sdf1 is identified as a member of /dev/md1, slot 3.=20
mdadm: /dev/sdg1 is identified as a member of /dev/md1, slot 5.=20
mdadm: /dev/sdh1 is identified as a member of /dev/md1, slot 2.=20
mdadm: /dev/sdi1 is identified as a member of /dev/md1, slot 1.=20
mdadm: /dev/sdj1 is identified as a member of /dev/md1, slot 4.=20
mdadm: /dev/sdk1 is identified as a member of /dev/md1, slot 0.=20
mdadm: added /dev/sdk1 to /dev/md1 as 0 (possibly out of date)=20
mdadm: added /dev/sdh1 to /dev/md1 as 2=20
mdadm: added /dev/sdf1 to /dev/md1 as 3=20
mdadm: added /dev/sdj1 to /dev/md1 as 4=20
mdadm: added /dev/sdg1 to /dev/md1 as 5 (possibly out of date)=20
mdadm: added /dev/sdi1 to /dev/md1 as 1=20
mdadm: /dev/md1 has been started with 4 drives (out of 6).

After looking at the code of mdadm I got to this bit around the forced =
assembly of an array (Assemble.c):=20

static int force_array(struct mdinfo *content,=20
             struct devs *devices,=20
             int *best, int bestcnt, char *avail,=20
             int most_recent,=20
             struct supertype *st,=20
             struct context *c)=20
{=20
   int okcnt =3D 0;=20
   while (!enough(content->array.level, content->array.raid_disks,=20
             content->array.layout, 1,=20
             avail)=20
          ||=20
          (content->reshape_active && content->delta_disks > 0 &&=20
      !enough(content->array.level, (content->array.raid_disks=20
                      - content->delta_disks),=20
         content->new_layout, 1,=20
         avail)=20
             )) {=20
=2E..=20
   }=20
   return okcnt;=20
}

So it only updates the event count, when it doesn't have enough disks t=
o start the array. Because only two of my drives were "out of date" and=
 it had four valid drives the --force did nothing.=20
Running the assembly with one of the up-to-date drives missing (replace=
d sdj1 with sdx1 on the command line) worked:

# mdadm --assemble -fv /dev/md1 /dev/sd[fghixk]1=20
mdadm: looking for devices for /dev/md1=20
mdadm: /dev/sdf1 is identified as a member of /dev/md1, slot 3.=20
mdadm: /dev/sdg1 is identified as a member of /dev/md1, slot 5.=20
mdadm: /dev/sdh1 is identified as a member of /dev/md1, slot 2.=20
mdadm: /dev/sdi1 is identified as a member of /dev/md1, slot 1.=20
mdadm: /dev/sdk1 is identified as a member of /dev/md1, slot 0.=20
mdadm: forcing event count in /dev/sdk1(0) from 17402 upto 17405=20
mdadm: forcing event count in /dev/sdg1(5) from 17402 upto 17405=20
mdadm: added /dev/sdi1 to /dev/md1 as 1=20
mdadm: added /dev/sdh1 to /dev/md1 as 2=20
mdadm: added /dev/sdf1 to /dev/md1 as 3=20
mdadm: no uptodate device for slot 8 of /dev/md1=20
mdadm: added /dev/sdg1 to /dev/md1 as 5=20
mdadm: added /dev/sdk1 to /dev/md1 as 0=20
mdadm: /dev/md1 has been started with 5 drives (out of 6).

The intention of this behaviour might be that a rebuild is safer for da=
ta integrity when there are enough disks. (Because I shut down the arra=
y properly [at least I think so] and the event count was off by that li=
ttle I chose to trick mdadm.)
Is that assumption on the intention of the code right? If so I think it=
 should be mentioned in the man-page.

Regards,
Ren=C3=A9
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
