From: Emery Guevremont <emery.guevremont@gmail.com>
Subject: Re: On RAID5 read error during syncing - array .A.A
Date: Sat, 6 Dec 2014 15:49:10 -0500
Message-ID: <CAB_L8sYkWFO0hC-rUHednzy=BWZoBaVS_DhoBedg-viPnTdU-g@mail.gmail.com>
References: <CAB_L8sZoinCMbp7wrjYaQ=XgCOiBWZBLHkMsV_g+nUyM9pc7CQ@mail.gmail.com>
	<20141206185600.GA2343@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=089e0102ff2c4597b90509925369
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141206185600.GA2343@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Emery Guevremont <emery.guevremont@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--089e0102ff2c4597b90509925369
Content-Type: text/plain; charset=UTF-8

You'll see from the examine output, raid level and devices aren't
defined and notice the role of each drives. The examine output (I
attached 4 files) that I took right after the read error during the
synching process seems to show a more accurate superblock. Here's also
the output of mdadm --detail /dev/md0 that I took when I got the first
error:

ARRAY /dev/md/0 metadata=1.2 UUID=cf9db8fa:0c2bb553:46865912:704cceae
name=runts:0
   spares=1


Here's the output of how things currently are:

mdadm --assemble --force /dev/md127 /dev/sdb3 /dev/sdc3 /dev/sdd3
mdadm: /dev/md127 assembled from 0 drives and 3 spares - not enough to
start the array.

dmesg
[27903.423895] md: md127 stopped.
[27903.434327] md: bind<sdc3>
[27903.434767] md: bind<sdd3>
[27903.434963] md: bind<sdb3>

cat /proc/mdstat
root@ubuntu:~# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0]
[raid1] [raid10]
md127 : inactive sdb3[4](S) sdd3[0](S) sdc3[5](S)
      5858387208 blocks super 1.2

mdadm --examine /dev/sd[bcd]3
/dev/sdb3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : cf9db8fa:0c2bb553:46865912:704cceae
           Name : runts:0
  Creation Time : Tue Jul 26 03:27:39 2011
     Raid Level : -unknown-
   Raid Devices : 0

 Avail Dev Size : 3905591472 (1862.33 GiB 1999.66 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : b2bf0462:e0722254:0e233a72:aa5df4da

    Update Time : Sat Dec  6 12:46:40 2014
       Checksum : 5e8cfc9a - correct
         Events : 1


   Device Role : spare
   Array State :  ('A' == active, '.' == missing)
/dev/sdc3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : cf9db8fa:0c2bb553:46865912:704cceae
           Name : runts:0
  Creation Time : Tue Jul 26 03:27:39 2011
     Raid Level : -unknown-
   Raid Devices : 0

 Avail Dev Size : 3905591472 (1862.33 GiB 1999.66 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 390bd4a2:07a28c01:528ed41e:a9d0fcf0

    Update Time : Sat Dec  6 12:46:40 2014
       Checksum : f69518c - correct
         Events : 1


   Device Role : spare
   Array State :  ('A' == active, '.' == missing)
/dev/sdd3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : cf9db8fa:0c2bb553:46865912:704cceae
           Name : runts:0
  Creation Time : Tue Jul 26 03:27:39 2011
     Raid Level : -unknown-
   Raid Devices : 0

 Avail Dev Size : 3905591472 (1862.33 GiB 1999.66 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 92589cc2:9d5ed86c:1467efc2:2e6b7f09

    Update Time : Sat Dec  6 12:46:40 2014
       Checksum : 571ad2bd - correct
         Events : 1


   Device Role : spare
   Array State :  ('A' == active, '.' == missing)

and finally kernel and mdadm versions:

uname -a
Linux ubuntu 3.2.0-23-generic #36-Ubuntu SMP Tue Apr 10 20:41:14 UTC
2012 i686 i686 i386 GNU/Linux

mdadm -V
mdadm - v3.2.3 - 23rd December 2011

On Sat, Dec 6, 2014 at 1:56 PM, Robin Hill <robin@robinhill.me.uk> wrote:
> On Sat Dec 06, 2014 at 01:35:50pm -0500, Emery Guevremont wrote:
>
>> The long story and what I've done.
>>
>> /dev/md0 is assembled with 4 drives
>> /dev/sda3
>> /dev/sdb3
>> /dev/sdc3
>> /dev/sdd3
>>
>> 2 weeks ago, mdadm marked /dev/sda3 as failed. cat /proc/mdstat showed
>> _UUU. smarctl also confirmed that the drive was dying. So I shutdown
>> the server and until I received a replacement drive.
>>
>> This week, I replaced the dying drive with my new drive. Booted into
>> single user mode and did this:
>>
>> mdadm --manage /dev/md0 --add /dev/sda3  a cat of /proc/mdstat
>> confirmed the resyncing process. The last time I checked it was up to
>> 11%. After a few minutes later, I noticed that the syncing stopped. A
>> read error message on /dev/sdd3 (have a pic of it if interested)
>> appear on the console. It appears that /dev/sdd3 might be going bad. A
>> cat /proc/mdstat showed _U_U. Now I panic, and decide to leave
>> everything as is and to go to bed.
>>
>> The next day, I shutdown the server and reboot with a live usb distro
>> (Ubuntu rescue remix). After booting into the live distro, a cat
>> /proc/mdstat showed that my /dev/md0 was detected but all drives had
>> an (S) next to it. i.e. /dev/sda3 (S)... Naturally I don't like the
>> looks of this.
>>
>> I ran ddrescue to copy /dev/sdd onto my new replacement disk
>> (/dev/sda). Everything, worked, ddrescue got only one read error, but
>> was eventually able to read the bad sector on a retry. I followed up
>> by also cloning with ddrescue, sdb and sdc.
>>
>> So now I have cloned copies of sdb, sdc and sdd to work with.
>> Currently running mdadm --assemble --scan, will activate my array, but
>> all drives are added as spares. Running mdadm --examine on each
>> drives, shows the same Array UUID number, but the Raid Devices is 0
>> and raid level is -unknown- for some reason. The rest seems fine and
>> makes sense. I believe I could re-assemble my array if I could define
>> the raid level and raid devices.
>>
>> I wanted to know if there are a way to restore my superblocks from the
>> examine command I ran at the beginning? If not, what mdadm create
>> command should I run? Also please let me know if drive ordering is
>> important, and how I can determine this with the examine output I'll
>> got?
>>
>> Thank you.
>>
> Have you tried --assemble --force? You'll need to make sure the array's
> stopped first, but that's the usual way to get the array back up and
> running in that sort of situation.
>
> If that doesn't work, stop the array again and post:
>  - the output from mdadm --assemble --force --verbose /dev/md0 /dev/sd[bcd]3
>  - any dmesg output corresponding with the above
>  - --examine output for all disks
>  - kernel and mdadm versions
>
> Good luck,
>     Robin
> --
>      ___
>     ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
>    / / )      | Little Jim says ....                            |
>   // !!       |      "He fallen in de water !!"                 |

--089e0102ff2c4597b90509925369
Content-Type: application/octet-stream; name="sda3.examine"
Content-Disposition: attachment; filename="sda3.examine"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i3dgf3sz1

L2Rldi9zZGEzOgogICAgICAgICAgTWFnaWMgOiBhOTJiNGVmYwogICAgICAgIFZlcnNpb24gOiAx
LjIKICAgIEZlYXR1cmUgTWFwIDogMHgwCiAgICAgQXJyYXkgVVVJRCA6IGNmOWRiOGZhOjBjMmJi
NTUzOjQ2ODY1OTEyOjcwNGNjZWFlCiAgICAgICAgICAgTmFtZSA6IHJ1bnRzOjAgIChsb2NhbCB0
byBob3N0IHJ1bnRzKQogIENyZWF0aW9uIFRpbWUgOiBNb24gSnVsIDI1IDIzOjI3OjM5IDIwMTEK
ICAgICBSYWlkIExldmVsIDogcmFpZDUKICAgUmFpZCBEZXZpY2VzIDogNAoKIEF2YWlsIERldiBT
aXplIDogMzkwNTU5MTQ3MiAoMTg2Mi4zMyBHaUIgMTk5OS42NiBHQikKICAgICBBcnJheSBTaXpl
IDogNTg1ODM4NTQwOCAoNTU4Ni45OSBHaUIgNTk5OC45OSBHQikKICBVc2VkIERldiBTaXplIDog
MzkwNTU5MDI3MiAoMTg2Mi4zMyBHaUIgMTk5OS42NiBHQikKICAgIERhdGEgT2Zmc2V0IDogMjA0
OCBzZWN0b3JzCiAgIFN1cGVyIE9mZnNldCA6IDggc2VjdG9ycwogICAgICAgICAgU3RhdGUgOiBj
bGVhbgogICAgRGV2aWNlIFVVSUQgOiBiMmJmMDQ2MjplMDcyMjI1NDowZTIzM2E3MjphYTVkZjRk
YQoKICAgIFVwZGF0ZSBUaW1lIDogVHVlIERlYyAgMiAyMzoxNTozNyAyMDE0CiAgICAgICBDaGVj
a3N1bSA6IDVlZDViODk4IC0gY29ycmVjdAogICAgICAgICBFdmVudHMgOiAzOTI1Njc2CgogICAg
ICAgICBMYXlvdXQgOiBsZWZ0LXN5bW1ldHJpYwogICAgIENodW5rIFNpemUgOiA1MTJLCgogICBE
ZXZpY2UgUm9sZSA6IHNwYXJlCiAgIEFycmF5IFN0YXRlIDogQS5BLiAoJ0EnID09IGFjdGl2ZSwg
Jy4nID09IG1pc3NpbmcpCg==
--089e0102ff2c4597b90509925369
Content-Type: application/octet-stream; name="sdb3.examine"
Content-Disposition: attachment; filename="sdb3.examine"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i3dgf3wg2

L2Rldi9zZGIzOgogICAgICAgICAgTWFnaWMgOiBhOTJiNGVmYwogICAgICAgIFZlcnNpb24gOiAx
LjIKICAgIEZlYXR1cmUgTWFwIDogMHgwCiAgICAgQXJyYXkgVVVJRCA6IGNmOWRiOGZhOjBjMmJi
NTUzOjQ2ODY1OTEyOjcwNGNjZWFlCiAgICAgICAgICAgTmFtZSA6IHJ1bnRzOjAgIChsb2NhbCB0
byBob3N0IHJ1bnRzKQogIENyZWF0aW9uIFRpbWUgOiBNb24gSnVsIDI1IDIzOjI3OjM5IDIwMTEK
ICAgICBSYWlkIExldmVsIDogcmFpZDUKICAgUmFpZCBEZXZpY2VzIDogNAoKIEF2YWlsIERldiBT
aXplIDogMzkwNTU5MTQ3MiAoMTg2Mi4zMyBHaUIgMTk5OS42NiBHQikKICAgICBBcnJheSBTaXpl
IDogNTg1ODM4NTQwOCAoNTU4Ni45OSBHaUIgNTk5OC45OSBHQikKICBVc2VkIERldiBTaXplIDog
MzkwNTU5MDI3MiAoMTg2Mi4zMyBHaUIgMTk5OS42NiBHQikKICAgIERhdGEgT2Zmc2V0IDogMjA0
OCBzZWN0b3JzCiAgIFN1cGVyIE9mZnNldCA6IDggc2VjdG9ycwogICAgICAgICAgU3RhdGUgOiBj
bGVhbgogICAgRGV2aWNlIFVVSUQgOiA5MjU4OWNjMjo5ZDVlZDg2YzoxNDY3ZWZjMjoyZTZiN2Yw
OQoKICAgIFVwZGF0ZSBUaW1lIDogVHVlIERlYyAgMiAyMzoxNTozNyAyMDE0CiAgICAgICBDaGVj
a3N1bSA6IDU3NjM4ZWJiIC0gY29ycmVjdAogICAgICAgICBFdmVudHMgOiAzOTI1Njc2CgogICAg
ICAgICBMYXlvdXQgOiBsZWZ0LXN5bW1ldHJpYwogICAgIENodW5rIFNpemUgOiA1MTJLCgogICBE
ZXZpY2UgUm9sZSA6IEFjdGl2ZSBkZXZpY2UgMAogICBBcnJheSBTdGF0ZSA6IEEuQS4gKCdBJyA9
PSBhY3RpdmUsICcuJyA9PSBtaXNzaW5nKQo=
--089e0102ff2c4597b90509925369
Content-Type: application/octet-stream; name="sdc3.examine"
Content-Disposition: attachment; filename="sdc3.examine"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i3dgf3wm3

L2Rldi9zZGMzOgogICAgICAgICAgTWFnaWMgOiBhOTJiNGVmYwogICAgICAgIFZlcnNpb24gOiAx
LjIKICAgIEZlYXR1cmUgTWFwIDogMHgwCiAgICAgQXJyYXkgVVVJRCA6IGNmOWRiOGZhOjBjMmJi
NTUzOjQ2ODY1OTEyOjcwNGNjZWFlCiAgICAgICAgICAgTmFtZSA6IHJ1bnRzOjAgIChsb2NhbCB0
byBob3N0IHJ1bnRzKQogIENyZWF0aW9uIFRpbWUgOiBNb24gSnVsIDI1IDIzOjI3OjM5IDIwMTEK
ICAgICBSYWlkIExldmVsIDogcmFpZDUKICAgUmFpZCBEZXZpY2VzIDogNAoKIEF2YWlsIERldiBT
aXplIDogMzkwNTU5MTQ3MiAoMTg2Mi4zMyBHaUIgMTk5OS42NiBHQikKICAgICBBcnJheSBTaXpl
IDogNTg1ODM4NTQwOCAoNTU4Ni45OSBHaUIgNTk5OC45OSBHQikKICBVc2VkIERldiBTaXplIDog
MzkwNTU5MDI3MiAoMTg2Mi4zMyBHaUIgMTk5OS42NiBHQikKICAgIERhdGEgT2Zmc2V0IDogMjA0
OCBzZWN0b3JzCiAgIFN1cGVyIE9mZnNldCA6IDggc2VjdG9ycwogICAgICAgICAgU3RhdGUgOiBj
bGVhbgogICAgRGV2aWNlIFVVSUQgOiAzOTBiZDRhMjowN2EyOGMwMTo1MjhlZDQxZTphOWQwZmNm
MAoKICAgIFVwZGF0ZSBUaW1lIDogVHVlIERlYyAgMiAyMzoxNTozNyAyMDE0CiAgICAgICBDaGVj
a3N1bSA6IGZiMjBkOGEgLSBjb3JyZWN0CiAgICAgICAgIEV2ZW50cyA6IDM5MjU2NzYKCiAgICAg
ICAgIExheW91dCA6IGxlZnQtc3ltbWV0cmljCiAgICAgQ2h1bmsgU2l6ZSA6IDUxMksKCiAgIERl
dmljZSBSb2xlIDogQWN0aXZlIGRldmljZSAyCiAgIEFycmF5IFN0YXRlIDogQS5BLiAoJ0EnID09
IGFjdGl2ZSwgJy4nID09IG1pc3NpbmcpCg==
--089e0102ff2c4597b90509925369
Content-Type: application/octet-stream; name="sdd3.examine"
Content-Disposition: attachment; filename="sdd3.examine"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i3dgf3wq4

L2Rldi9zZGQzOgogICAgICAgICAgTWFnaWMgOiBhOTJiNGVmYwogICAgICAgIFZlcnNpb24gOiAx
LjIKICAgIEZlYXR1cmUgTWFwIDogMHgwCiAgICAgQXJyYXkgVVVJRCA6IGNmOWRiOGZhOjBjMmJi
NTUzOjQ2ODY1OTEyOjcwNGNjZWFlCiAgICAgICAgICAgTmFtZSA6IHJ1bnRzOjAgIChsb2NhbCB0
byBob3N0IHJ1bnRzKQogIENyZWF0aW9uIFRpbWUgOiBNb24gSnVsIDI1IDIzOjI3OjM5IDIwMTEK
ICAgICBSYWlkIExldmVsIDogcmFpZDUKICAgUmFpZCBEZXZpY2VzIDogNAoKIEF2YWlsIERldiBT
aXplIDogMzkwNTU5MTQ3MiAoMTg2Mi4zMyBHaUIgMTk5OS42NiBHQikKICAgICBBcnJheSBTaXpl
IDogNTg1ODM4NTQwOCAoNTU4Ni45OSBHaUIgNTk5OC45OSBHQikKICBVc2VkIERldiBTaXplIDog
MzkwNTU5MDI3MiAoMTg2Mi4zMyBHaUIgMTk5OS42NiBHQikKICAgIERhdGEgT2Zmc2V0IDogMjA0
OCBzZWN0b3JzCiAgIFN1cGVyIE9mZnNldCA6IDggc2VjdG9ycwogICAgICAgICAgU3RhdGUgOiBj
bGVhbgogICAgRGV2aWNlIFVVSUQgOiA0MTU2YWI0NjpiZDQyYzEwZDo4NTY1ZDVhZjo3NDg1NjY0
MQoKICAgIFVwZGF0ZSBUaW1lIDogVHVlIERlYyAgMiAyMzoxNDowMyAyMDE0CiAgICAgICBDaGVj
a3N1bSA6IGExMjY4NTNmIC0gY29ycmVjdAogICAgICAgICBFdmVudHMgOiAzOTI1NjcyCgogICAg
ICAgICBMYXlvdXQgOiBsZWZ0LXN5bW1ldHJpYwogICAgIENodW5rIFNpemUgOiA1MTJLCgogICBE
ZXZpY2UgUm9sZSA6IEFjdGl2ZSBkZXZpY2UgMQogICBBcnJheSBTdGF0ZSA6IEFBQUEgKCdBJyA9
PSBhY3RpdmUsICcuJyA9PSBtaXNzaW5nKQo=
--089e0102ff2c4597b90509925369--
