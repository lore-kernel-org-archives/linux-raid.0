From: Paul Menzel <pm.debian@googlemail.com>
Subject: LUKS superblock damaged by `mdadm --create` or user error?
Date: Thu, 4 Aug 2011 21:27:30 +0200
Message-ID: <CAOOH3ponHA=mWahdM3thfcWSkzVRhsOccMTjhso3dv1afuA_BA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001517475414d5e3cb04a9b2f819
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--001517475414d5e3cb04a9b2f819
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Dear Linux RAID folks,


I hope I did not annoy you too much on #linux-raid and I am contacting
this list to reach a broader audience for help and for archival
purposes. My message to the list dm-crypt [1] was a little long and so
is this one. I am sorry.

After having grown `/dev/sda2` using `fdisk /dev/sda2` with mdadm not
running I forgot to grow the RAID1 and probably overwrote the md
metadata (0.90) or made it unavaible because it was not at the end of
the partition anymore after growing the physical and logical LVM
volumes and filesystems.

    # blkid
    /dev/sda1: UUID=3D"fb7f3dc5-d183-cab6-1212-31201a2207b9"
TYPE=3D"linux_raid_member"
    /dev/sda2: UUID=3D"cb6681b4-4dda-4548-8c59-3d9838de9c22"
TYPE=3D"crypto_LUKS" # In `fdisk` I had set it to =C2=BBLinux raid
autodetect=C2=AB (0xfd) though.

I could not boot anymore because `/dev/md1` could not be assembled.

        # mdadm --examine /dev/sda2
        mdadm: No md superblock detected on /dev/sda2.

        # mdadm --examine /dev/sda1
        /dev/sda1:
                  Magic : a92b4efc
                Version : 0.90.00
                   UUID : fb7f3dc5:d183cab6:12123120:1a2207b9
          Creation Time : Wed Mar 26 11:49:57 2008
             Raid Level : raid1
          Used Dev Size : 497856 (486.27 MiB 509.80 MB)
             Array Size : 497856 (486.27 MiB 509.80 MB)
           Raid Devices : 2
          Total Devices : 1
        Preferred Minor : 0

            Update Time : Wed Aug  3 21:11:43 2011
                  State : clean
         Active Devices : 1
        Working Devices : 1
         Failed Devices : 1
          Spare Devices : 0
               Checksum : 388e903a - correct
                 Events : 20332


              Number   Major   Minor   RaidDevice State
        this     0       8        1        0      active sync   /dev/sda1

           0     0       8        1        0      active sync   /dev/sda1
           1     1       0        0        1      faulty removed

        # mdadm --verbose --assemble /dev/md1
--uuid=3D52ff2cf2:40981859:e58d8dd6:5faec42c
        mdadm: looking for devices for /dev/md1
        mdadm: no recogniseable superblock on /dev/dm-8
        mdadm: /dev/dm-8 has wrong uuid.
        mdadm: no recogniseable superblock on /dev/dm-7
        mdadm: /dev/dm-7 has wrong uuid.
        mdadm: no recogniseable superblock on /dev/dm-6
        mdadm: /dev/dm-6 has wrong uuid.
        mdadm: no recogniseable superblock on /dev/dm-5
        mdadm: /dev/dm-5 has wrong uuid.
        mdadm: no recogniseable superblock on /dev/dm-4
        mdadm: /dev/dm-4 has wrong uuid.
        mdadm: no recogniseable superblock on /dev/dm-3
        mdadm: /dev/dm-3 has wrong uuid.
        mdadm: no recogniseable superblock on /dev/dm-2
        mdadm: /dev/dm-2 has wrong uuid.
        mdadm: no recogniseable superblock on /dev/dm-1
        mdadm: /dev/dm-1 has wrong uuid.
        mdadm: cannot open device /dev/dm-0: Device or resource busy
        mdadm: /dev/dm-0 has wrong uuid.
        mdadm: no recogniseable superblock on /dev/md0
        mdadm: /dev/md0 has wrong uuid.
        mdadm: cannot open device /dev/loop0: Device or resource busy
        mdadm: /dev/loop0 has wrong uuid.
        mdadm: cannot open device /dev/sdb4: Device or resource busy
        mdadm: /dev/sdb4 has wrong uuid.
        mdadm: cannot open device /dev/sdb: Device or resource busy
        mdadm: /dev/sdb has wrong uuid.
        mdadm: cannot open device /dev/sda2: Device or resource busy
        mdadm: /dev/sda2 has wrong uuid.
        mdadm: cannot open device /dev/sda1: Device or resource busy
        mdadm: /dev/sda1 has wrong uuid.
        mdadm: cannot open device /dev/sda: Device or resource busy
        mdadm: /dev/sda has wrong uuid.

and `mdadm --examine /dev/sda2` could not find any metadata.
`/dev/sda2` could still be decrypted using `cryptsetup luksOpen
/dev/sda2 sda2_crypt`. Not knowing about metadata and their storage
(0.90) I read several Web resourses and joined IRC channels and came
to the conclusion that I should just create a new (degraded) RAID1 and
everything would be fine, since I had only one disk.

Booting from the live system Grml [3], which does *not* start `mdadm`
or `lvm` during boot, I tried to create a new RAID1 using the
following command (a).

   # command (a)
   mdadm --verbose --create /dev/md1 \
   --assume-clean \
   --level=3D1 \
   --raid-devices=3D2 \
   --uuid=3D52ff2cf2:40981859:e58d8dd6:5faec42c \
   /dev/sda2 missing

I ignored the warning about overwriting metadata because it only
referred to booting. Unfortunately `cryptsetup luksOpen /dev/md1
md1_crypt` did not find any LUKS superblock. Therefore I stopped
`/dev/md1` and `cryptsetup luksOpen /dev/sda2 sda2_crypt` still
worked. Then I remembered that the metadata version was originally
0.90 and added `--metadata=3D0.90` and executed the following (b).

   # command (b)
   mdadm --verbose --create /dev/md1 \
   --assume-clean \
   --level=3D1 \
   --raid-devices=3D2 \
   --uuid=3D52ff2cf2:40981859:e58d8dd6:5faec42c \
   --metadata=3D0.90
   /dev/sda2 missing

Lucky me I thought, `cryptsetup luksOpen /dev/md1 md1_crypt` asked me
for the passphrase but I entered it three times and it would not
unlock. Instead of trying it again =E2=80=93 I do not know if it would have
worked =E2=80=93 I tried `cryptsetup luksOpen /dev/sda2 sda2_crypt` and it
asked me for the passphrase too. The third time I seem to have entered
it correctly, but I got an error message that it could not be mapped.

--- dmesg ---
Aug  4 00:16:01 grml kernel: [ 7964.786362] device-mapper:
table: 253:0: crypt: Device lookup failed
       Aug  4 00:16:01 grml kernel: [ 7964.786367] device-mapper:
ioctl: error adding target to table
       Aug  4 00:16:01 grml udevd[2409]: inotify_add_watch(6,
/dev/dm-0, 10) failed: No such file or directory
       Aug  4 00:16:01 grml udevd[2409]: inotify_add_watch(6,
/dev/dm-0, 10) failed: No such file or directory

       Aug  4 00:17:14 grml kernel: [ 8038.196371] md1: detected
capacity change from 1999886286848 to 0
       Aug  4 00:17:14 grml kernel: [ 8038.196395] md: md1 stopped.
       Aug  4 00:17:14 grml kernel: [ 8038.196407] md: unbind<sda2>
       Aug  4 00:17:14 grml kernel: [ 8038.212653] md: export_rdev(sda2)
--- dmesg ---

Then I realized that I had probably forgotten to stop `/dev/md1`.
After stopping it, `cryptsetup luksOpen /dev/sda2 sda2_crypt` did not
succeed anymore and I cannot access my data.

1. Does the `dmesg` output suggest that accessing `/dev/sda2` while
assembled caused any breakage?
2. On #lvm and #linux-raid the common explanation was that command (a)
had overwritten the LUKS superblock and damaged it. Is that possible?
I could not find the magic number 0xa92b4efc in the first megabyte of
`/dev/sda2`. Did `--assume-clean` prevent that?
3. Is command (b) to blame, or did it probably work and I had a typo
in the passphrase?

I am thankful for any hint to get my data back.


Thanks and sorry for the long message. Any hints on how to shorten it
next time are much appreciated.

Paul


PS: A month ago I head `dd` the content of a 500 GB drive to this one.
That is why I wanted to resize the partitions. The old drive is still
functional and I am attaching several outputs from commands from the
current 2 TB drive and the old drive. The `luksDump` output is from
the current drive but with the LUKS header from the 500 GB drive. I
know that I am publishing the key to access my drive, but if it helps
to get my data back I will encrypt from scratch again afterward. I
also have the dump of the first MB (in this case) of the partition
(`luksHeaderBackup`) from the old and new drive. But attaching them
would be over the message size limit.

[1] http://www.saout.de/pipermail/dm-crypt/2011-August/001857.html
[2] http://www.hermann-uwe.de/blog/resizing-a-dm-crypt-lvm-ext3-partition
[3] http://grml.org/

--001517475414d5e3cb04a9b2f819
Content-Type: text/plain; charset=UTF-8; name="20110804--Nachricht-dm-crypt.txt"
Content-Disposition: attachment; filename="20110804--Nachricht-dm-crypt.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gqy3x8dl0

QWNjZXNpbmcgZG0tY3J5cHQgdm9sdW1lIGFmdGVyIGZhaWxlZCByZXNpemluZyB3aXRoIG1kYWRt
L1JBSUQxLCBkbS1jcnlwdC9MVUtTLCBMVk0KCgpEZWFyIGRtLWNyeXB0IGZvbGtzLAoKCmFzIHlv
dSBtaWdodCBndWVzcyBJIGFtIGFub3RoZXIgbG9zdCBndXkgdHVybmluZyB0byB5b3UgYXMgdGhl
IGxhc3QgcmVzb3J0IHRvIHJlc2N1ZSBoaXMgZGF0YS4KCkkgYW0gc29ycnkgZm9yIHRoZSBsb25n
IHRleHQsIGJ1dCBJIGFtIHRyeWluZyB0byBiZSBhcyBlbGFib3JhdGUgYXMgcG9zc2libGUuCgpJ
IGhhdmUgYSBSQUlEMSAobWlycm9yaW5nKSBzZXR1cCB3aGVyZSBvbmx5IG9uZSBkcml2ZSBpcyBh
c3NlbWJsZWQgdGhvdWdoLiBJdCBpcyBzZXR1cCBgL2Rldi9tZDBgIOKGkCBgL2Rldi9zZGExYCBh
bmQgYC9kZXYvbWQxYCDihpAgYC9kZXYvc2RhMmAuIGAvZGV2L21kMWAgaXMgZW5jcnlwdGVkIHdp
dGggTFVLUyBhbmQgY29udGFpbnMgYSBMVk0gc2V0dXAgd2l0aCB0aGUgbG9naWNhbCB2b2x1bWVz
IHVzZWQgYnkgYC9ob21lL2AgYW5kIGAvcm9vdC9gLgoKQSBtb250aCBhZ28gdGhlIDUwMCBHQiBk
cml2ZSB3YXMgcmVwbGFjZWQgYnkgYSAyIFRCIGRyaXZlIGFuZCBJIGNvcGllZCB0aGUgd2hvbGUg
ZGF0YSB3aXRoIGBkZF9yZXNjdWVgIHdpdGhvdXQgYW55IGVycm9ycyBmcm9tIHRoZSBvbGQgdG8g
dGhlIG5ldyBkcml2ZS4gQXMgd2UgYWxsIGtub3cgYXMgYSBjb25zZXF1ZW5jZSBvbmx5IHRoZSBv
bGQgc2l6ZSBvZiA1MDAgR0IgaXMgdXNhYmxlIGFuZCB0aGUgcGFydGl0aW9ucyBoYXZlIHRvIGJl
IHJlc2l6ZWQvZ3Jvd24gdG8gYmUgYWJsZSB0byB1c2UgdGhlIHdob2xlIDIgVEIuIEJ1dCB0byBl
bXBoYXNpemUgaXQgYWdhaW4sIEkgc3RpbGwgZG8gaGF2ZSB0aGUgb2xkIGRyaXZlIGF2YWlsYWJs
ZS4KCkkgd2FudGVkIHRvIHJlc2l6ZSB0aGUgcGFydGl0aW9ucyB0b2RheS4gVGhlcmVmb3JlIEkg
Zm9sbG93ZWQgdGhlIGd1aWRlIGZyb20gVXdlIEhlcm1hbm4gWzFdIHdoaWNoIEkgaGFkIGRvbmUg
YWxzbyBzb21lIHllYXJzIGFnbyB3aGVyZSBpdCBoYWQgd29ya2VkIHdpdGhvdXQgYW55IHByb2Js
ZW0uCgpTbyBJIGJvb3RlZCBmcm9tIGEgVVNCIG1lZGl1bSB3aXRoIEdybWwgNS4yMDExIChjcnlw
dHNldHVwIDEuMy4wKSBhbmQgZm9sbG93ZWQgdGhlIHN0ZXBzIGZyb20gdGhlIGd1aWRlLiBQbGVh
c2Ugbm90ZSB0aGF0IEdybWwgYnkgZGVmYXVsdCBkb2VzIG5vdCBhc3NlbWJsZSBhbnkgUkFJRHMs
IHRoYXQgbWVhbnMgYG1kYWRtYCB3YXMgbm90IHJ1bi4gKEFuZCBoYXZpbmcgb25seSBvbmUgZHJp
dmUgSSBkaWQgbm90IHRoaW5rIGFib3V0IHRoYXQgdGhlIFJBSUQxIG1pZ2h0IGhhdmUgYmVlbiB0
YWtlbiBjYXJlIGZvciB0b28uKQoKMS4gYGZkaXNrIC9kZXYvc2RhYAoyLiBSZW1vdmUgc2Vjb25k
IHBhcnRpdGlvbi4KMy4gQ3JlYXRlIG5ldyBwYXJ0aXRpb24gd2l0aCB0aGUgc2FtZSBzdGFydGlu
ZyBzZWN0b3IgKGF1dG9tYXRpY2FsbHkgNjMgd2FzIGNob3Nlbiwgc2luY2UgdGhlcmUgYXJlIG9u
bHkgdHdvIHBhcnRpdGlvbnMgYW5kIGl0IHdhcyB0aGUgc2Vjb25kKS4KNC4gQ2hvb3NlIHByb3Bv
c2VkIGVuZCBzZWN0b3IsIHdoaWNoIHdhcyB0aGUgbWF4aW11bS4KNS4gQ2hvb3NlIHR5cGUgYGF1
dG9yYWlkIGRldGVjdGlvbmAuCjYuIFNhdmVkIGl0IHVzaW5nIHcuCgpBZnRlcndhcmQgSSBkaWQg
YGNyeXB0c2V0dXAgbHVrc09wZW4gL2Rldi9zZGEyIGZvb2AsIGBwdnJlc2l6ZSAvZGV2L21hcHBl
ci9mb29gLCBgc2VydmljZSBsdm0yIHN0YXJ0YCBhbmQgYGx2cmVzaXplIC1MICszMDBHQiAvZGV2
L3NwZWljaGVyL2hvbWVgIGFuZCBgbHZyZXNpemUgLUwgKzIwR0IgL2Rldi9zcGVpY2hlci9vdGhl
cmAuIFRoZW4gSSByYW4gYGZzY2sgLWYgL2Rldi9zcGVpY2hlci9ob21lYCBhbmQgYHhmc19jaGVj
ayAvbW50L290aGVyX21vdW50ZWRgIGFuZCB0aGVyZSB3ZXJlIG5vIGVycm9ycyBhdCBhbGwuIERv
aW5nIGByZXNpemUyZnMgL2Rldi9zcGVpY2hlci9ob21lYCBhbmQgYHhmc19yZXNpemUgL21udC9v
dGhlcl9tb3VudGVkYCg/KSBJIHJlYm9vdGVkIGp1c3QgdG8gYmUgc3VycHJpc2VkIHRoYXQgSSB3
YXMgbm90IGFza2VkIGZvciB0aGUgTFVLUyBwYXNzd29yZCB3aGVuIGJvb3RpbmcgaW50byBEZWJp
YW4uIEkgb25seSBzYXcgYGV2bXNfYWN0aXZhdGUgaXMgbm90IGF2YWlsYWJsZWAuCgpUaGVuIEkg
Ym9vdGVkIHdpdGggR3JtbCBhZ2FpbiB0byByZWNyZWF0ZWQgdGhlIGluaXRyZC5pbWcsIGB1cGRh
dGUtaW5pdHJhbWZzIC11YCB0aGlua2luZyBpdCBuZWVkZWQgdG8gYmUgdXBkYXRlZCB0b28uIEkg
d2FzIGhhcHB5IHRvIHNlZSB0aGF0IEkgY291bGQgc3RpbGwgYWNjZXNzIGAvZGV2L3NkYTJgIGp1
c3QgZmluZSB1c2luZyBgY3J5cHRzZXR1cCBsdWtzT3BlbiAvZGV2L3NkYTIgc2RhMl9jcnlwdGAg
YW5kIHRvIG1vdW50IGV2ZXJ5dGhpbmcgaW4gaXQg4oCTIGBzZXJ2aWNlIGx2bTIgc3RhcnRgIGFs
bCB2b2x1bWVzIOKAkyBmb3IgdXNpbmcgYGNocm9vdGAgWzNdIGFuZCByZWJ1aWxkIHRoZSBpbml0
cmQgaW1hZ2UuIEJ1dCB1cGRhdGluZyB0aGUgaW5pdHJkIGltYWdlIHdhcyB0byBubyBhdmFpbCBh
bHRob3VnaCB0aGUgYGV2bXNfYWN0aXZhdGUgaXMgbm90IGF2YWlsYWJsZSBtZXNzYWdlYCBkaXNh
cHBlYXJlZC4KCkhlcmUgSSBwcm9iYWJseSBhbHNvIGhhdmUgdG8gbWVudGlvbiB0aGF0IEkgaGF2
ZSBgbWRhZG1gIG9uIGhvbGQgb24gdGhlIERlYmlhbiBzeXN0ZW0gZm9yIHF1aXRlIHNvbWUgdGlt
ZSBiZWNhdXNlIG9mIHNvbWUgcHJvYmxlbXMgYW5kIEkgZGlkIG5vdCBkYXJlIHRvIHRvdWNoIGl0
LgoKQW55d2F5IEkgZm91bmQgb3V0IHRoYXQgdGhlIHN5c3RlbSB3YXMgbm90IGFibGUgdG8gYXNz
ZW1ibGUgYC9kZXYvbWQxYCBmcm9tIGAvZGV2L3NkYTJgLiBUaGlzIGRpZCBhbHNvIG5vdCB3b3Jr
IHVuZGVyIEdybWwgYW5kIGBtZGFkbWAgY291bGQgbm90IGZpbmQgdGhlIG1kIHN1cGVyYmxvY2sg
b24gYC9kZXYvc2RhMmAuCgoJIyBtZGFkbSAtLWV4YW1pbmUgL2Rldi9zZGEyCgltZGFkbTogTm8g
bWQgc3VwZXJibG9jayBkZXRlY3RlZCBvbiAvZGV2L3NkYTIuCgkjIGJsa2lkCgkvZGV2L3NkYTE6
IFVVSUQ9ImZiN2YzZGM1LWQxODMtY2FiNi0xMjEyLTMxMjAxYTIyMDdiOSIgVFlQRT0ibGludXhf
cmFpZF9tZW1iZXIiCgkvZGV2L3NkYTI6IFVVSUQ9ImNiNjY4MWI0LTRkZGEtNDU0OC04YzU5LTNk
OTgzOGRlOWMyMiIgVFlQRT0iY3J5cHRvX0xVS1MiICMgZGlmZmVyZW50IFVVSUQgdGhhbiBiZWZv
cmUgYW5kIOKAnHdyb25n4oCdIHR5cGUKCSMgY3J5cHRzZXR1cCBsdWtzT3BlbiAvZGV2L3NkYTIg
c2RhMl9jcnlwdCAjIHN0aWxsIHdvcmtlZAoKT24gYCNkZWJpYW5gIHNvbWVib2R5IHRvbGQgbWUs
IHRoYXQgdGhlIG1kIHN1cGVyYmxvY2sgaXMgc3RvcmVkIG9uIHRoZSBlbmQgb2YgdGhlIHBhcnRp
dGlvbiBhbmQgdGhhdCBpdCB3YXMgcHJvYmFibHkgb3ZlcndyaXR0ZW4gd2hlbiBlbmxhcmdpbmcg
dGhlIHBhcnRpdGlvbiBhbmQgSSBzaG91bGQgaGF2ZSBncm93bSB0aGUgUkFJRCB0b28uCgpTZWFy
Y2hpbmcgdGhlIEludGVybmV0IGZvciBoZWxwIEkgZm91bmQgc2V2ZXJhbCBzdWdnZXN0aW9ucyBh
bmQgSSB0cmllZCB0byByZWNyZWF0ZSB0aGUgUkFJRCB3aXRoIHRoZSBmb2xsb3dpbmcgY29tbWFu
ZC4KCgkjIG1kYWRtIC0tY3JlYXRlIC9kZXYvbWQxIC0tYXNzdW1lLWNsZWFuIC0tdXVpZD01MmZm
MmNmMi00MDk4LTE4NTktZTU4ZC04ZGQ2NWZhZWM0MmMgL2Rldi9zZGEyIG1pc3NpbmcKCkkgZ290
IGEgd2FybmluZyB0aGF0IHRoZXJlIGlzIG1ldGFkYXRhIGF0IHRoZSBiZWdpbm5pbmcgYW5kIHRo
YXQgSSBzaG91bGQgbm90IGdvIG9uIHdoZW4gdGhpcyBpcyB1c2VkIGZvciBgL2Jvb3RgIGFuZCB1
c2UgYC0tbWV0YWRhdGE9MC45MGAuIEJ1dCBzaW5jZSBpdCB3YXMgbm90IHVzZWQgZm9yIGAvYm9v
dGAgSSBjaG9zZSB0byBnbyBvbi4gVGhlbiB0aGUgUkFJRCB3YXMgY3JlYXRlZCBidXQgYGNyeXB0
c2V0dXAgbHVrc09wZW4gL2Rldi9tZDEgbWQxX2NyeXB0YCBzYWlkIHRoYXQgaXQgd2FzIG5vIExV
S1MgZGV2aWNlLiBUaGVyZWZvcmUgSSBzdG9wcGVkIHRoZSBSQUlEIGFuZCBgY3J5cHRzZXR1cCBs
dWtzT3BlbiAvZGV2L3NkYTIgc2RhMl9jcnlwdGAgc3RpbGwgd29ya2VkLgoKVGhlbiBJIHdhcyB0
b2xkIG9uIElSQyB0aGF0IHdoZW4gb25seSBoYXZpbmcgb25lIGRyaXZlIGluIGEgUkFJRDEgaXQg
ZG9lcyBub3QgbWF0dGVyIGlmIHlvdSBhbHRlciBgL2Rldi9zZGEyYCBvciBgL2Rldi9tZDFgIGFu
ZCB0aGF0IEkgc2hvdWxkIHRyeSB0byBjcmVhdGUgdGhlIFJBSUQgYWdhaW4uIFJlbWVtYmVyaW5n
IHRoYXQgYmVmb3JlIHRoZSByZXNpemluZyB0aGUgUkFJRCBtZXRhZGF0YSAoYWxzbyBvbiAvZGV2
L3NkYTEpIHdhcyBgMC45MGAgSSBwYXNzZWQgYC0tbWV0YWRhdGE9MC45MGAgdG8gdGhlIGBtZGFk
bSAtLWNyZWF0ZWAgY29tbWFuZC4KCgkjIG1kYWRtIC0tY3JlYXRlIC9kZXYvbWQxIC0tYXNzdW1l
LWNsZWFuIC0tdXVpZD01MmZmMmNmMi00MDk4LTE4NTktZTU4ZC04ZGQ2NWZhZWM0MmMgL2Rldi9z
ZGEyIG1pc3NpbmcKCkkgZ290IGFuIGVycm9yIG1lc3NhZ2UgdGhhdCB0aGUgZGV2aWNlIGlzIGFs
cmVhZHkgcGFydCBvZiBhIFJBSUQgYW5kIEkgaWdub3JlZCBpdCBhbmQgd2VudCBvbi4gSSBmaXJz
dCB3YXMgaGFwcHkgYmVjYXVzZQoKCSMgY3J5cHRzZXR1cCBsdWtzT3BlbiAvZGV2L21kMSBtZDFf
Y3J5cHQKCndvcmtlZCBhbmQgYXNrZWQgbWUgZm9yIHRoZSBwYXNzcGhyYXNlLiBCdXQgSSB0eXBl
ZCB0aGUgY29ycmVjdCBwYXNzcGhyYXNlIHNldmVyYWwgdGltZXMgYW5kIGl0IHdhcyByZWplY3Rl
ZC4gVGhlbiBJIHByb2JhYmx5IGZvcmdvdCB0byBzdG9wIHRoZSBSQUlEIGFuZAoKCSMgY3J5cHRz
ZXR1cCBsdWtzT3BlbiAvZGV2L3NkYTIgc2RhMl9jcnlwdAoKc2hvd2VkIHRoZSBzYW1lIGJlaGF2
aW9yIGJ1dCB0aGF0IHdhcyBwcm9iYWJseSB0eXBvcyBhbmQgaXQgc2VlbWVkIHRvIHdvcmsgb25j
ZS4gQnV0IEkgZ290IGFuIGVycm9yIG1lc3NhZ2Ugd2hpY2ggaXMgdGhlIGZvbGxvd2luZyBtYWtp
bmcgbWUgcmVhbGl6ZSB0aGUgUkFJRCB3YXMgcHJvYmFibHkgc3RpbGwgcnVubmluZyBhbmQgSSBz
dG9wcGVkIGl0IHJpZ2h0IGF3YXkuCgoJQXVnICA0IDAwOjE2OjAxIGdybWwga2VybmVsOiBbIDc5
NjQuNzg2MzYyXSBkZXZpY2UtbWFwcGVyOiB0YWJsZTogMjUzOjA6IGNyeXB0OiBEZXZpY2UgbG9v
a3VwIGZhaWxlZAoJQXVnICA0IDAwOjE2OjAxIGdybWwga2VybmVsOiBbIDc5NjQuNzg2MzY3XSBk
ZXZpY2UtbWFwcGVyOiBpb2N0bDogZXJyb3IgYWRkaW5nIHRhcmdldCB0byB0YWJsZQoJQXVnICA0
IDAwOjE2OjAxIGdybWwgdWRldmRbMjQwOV06IGlub3RpZnlfYWRkX3dhdGNoKDYsIC9kZXYvZG0t
MCwgMTApIGZhaWxlZDogTm8gc3VjaCBmaWxlIG9yIGRpcmVjdG9yeQoJQXVnICA0IDAwOjE2OjAx
IGdybWwgdWRldmRbMjQwOV06IGlub3RpZnlfYWRkX3dhdGNoKDYsIC9kZXYvZG0tMCwgMTApIGZh
aWxlZDogTm8gc3VjaCBmaWxlIG9yIGRpcmVjdG9yeQoKCUF1ZyAgNCAwMDoxNzoxNCBncm1sIGtl
cm5lbDogWyA4MDM4LjE5NjM3MV0gbWQxOiBkZXRlY3RlZCBjYXBhY2l0eSBjaGFuZ2UgZnJvbSAx
OTk5ODg2Mjg2ODQ4IHRvIDAKCUF1ZyAgNCAwMDoxNzoxNCBncm1sIGtlcm5lbDogWyA4MDM4LjE5
NjM5NV0gbWQ6IG1kMSBzdG9wcGVkLgoJQXVnICA0IDAwOjE3OjE0IGdybWwga2VybmVsOiBbIDgw
MzguMTk2NDA3XSBtZDogdW5iaW5kPHNkYTI+CglBdWcgIDQgMDA6MTc6MTQgZ3JtbCBrZXJuZWw6
IFsgODAzOC4yMTI2NTNdIG1kOiBleHBvcnRfcmRldihzZGEyKQoKQWZ0ZXIgdGhhdCBgY3J5cHRz
ZXR1cCBsdWtzT3BlbiAvZGV2L3NkYTIgc2RhMl9jcnlwdGAgYWx3YXlzIGZhaWxlZC4KCk5vdyB3
YW50aW5nIHRvIGJlIHNtYXJ0IEkgc2F2ZWQgdGhlIExVS1MgaGVhZGVyCgoJIyBjcnlwdHNldHVw
IGx1a3NIZWFkZXJCYWNrdXAgL2Rldi9zZGEyIC0taGVhZGVyLWJhY2t1cC1maWxlIC9ob21lL2dy
bWwvMjAxMTA4MDQtLTAzMS0tbHVrc0hlYWRlckJhY2t1cAoKc2h1dCB0aGUgc3lzdGVtIGRvd24s
IGNvbm5lY3RlZCB0aGUgb2xkIGRyaXZlLCBib290ZWQgR3JtbCwgc2F2ZWQgdGhlIExVS1MgaGVh
ZGVyIGZyb20gYC9kZXYvc2RhMmAgZnJvbSB0aGUgNTAwIEdCIGRyaXZlLCBzd2l0Y2hlZCB0aGUg
ZHJpdmVzIGFnYWluIGFuZCByZXN0b3JpbmcgdGhlIG9sZCBoZWFkZXIgZnJvbSBiZWZvcmUgdGhl
IHJlc2l6aW5nIHRvIHRoZSBuZXcgZHJpdmUuCgoJIyBjcnlwdHNldHVwIGx1a3NIZWFkZXJSZXN0
b3JlIC9kZXYvc2RhMiAtLWhlYWRlci1iYWNrdXAtZmlsZSAvaG9tZS9ncm1sLzIwMTEwODA0LS0w
MzEtLWx1a3NIZWFkZXJCYWNrdXAKCk9ubHkgdG8gZmluZCBvdXQgdGhhdCB0aGlzIGRpZCBhbHNv
IG5vdCBoZWxwLiBJIGhhdmUgc29tZSBzeXN0ZW0gaW5mb3JtYXRpb24gZnJvbSB0aGUgbGF0ZSBy
ZWNvdmVyeSBhdHRlbXBzIGFuZCBzdGlsbCB0aGUgb2xkIDUwMCBHQiBkcml2ZS4gSXMgdGhlcmUg
YW55IHdheSB0byByZWNvdmVyIHRoZSBkYXRhPwoKVGhlIGN1cnJlbnQgc2l0dWF0aW9uIGlzLCB0
aGF0IGBsdWtzT3BlbmAgZG9lcyBub3Qgc3VjY2VlZCBvbiBgL2Rldi9tZDFgIG9yIGAvZGV2L3Nk
YTJgLCB0aGF0IG1lYW5zIGl0IGlzIGRldGVjdGVkIGFzIGEgTFVLUyBkZXZpY2UgYnV0IHRoZSBw
YXNzcGhyYXNlIGlzIG5vdCBhY2NlcHRlZCAoSSBldmVuIHR5cGVkIGl0IGNsZWFyIHRvIHRoZSBj
b25zb2xlIGFuZCBjb3BpZWQgaXQgaW50byB0aGUgcHJvbXB0KS4KCiMjIyBOZXcgZHJpdmUgIyMj
CgoJIyBtZGFkbSAtLWV4YW1pbmUgL2Rldi9zZGEyCgkvZGV2L3NkYTI6CgkJICBNYWdpYyA6IGE5
MmI0ZWZjCgkJVmVyc2lvbiA6IDAuOTAuMDAKCQkgICBVVUlEIDogNTJmZjJjZjI6NDA5ODE4NTk6
ZDhiNzhmNjU6OTkyMjZlNDEgKGxvY2FsIHRvIGhvc3QgZ3JtbCkKCSAgQ3JlYXRpb24gVGltZSA6
IFRodSBBdWcgIDQgMDA6MDU6NTcgMjAxMQoJICAgICBSYWlkIExldmVsIDogcmFpZDEKCSAgVXNl
ZCBEZXYgU2l6ZSA6IDE5NTMwMTM5NTIgKDE4NjIuNTQgR2lCIDE5OTkuODkgR0IpCgkgICAgIEFy
cmF5IFNpemUgOiAxOTUzMDEzOTUyICgxODYyLjU0IEdpQiAxOTk5Ljg5IEdCKQoJICAgUmFpZCBE
ZXZpY2VzIDogMgoJICBUb3RhbCBEZXZpY2VzIDogMgoJUHJlZmVycmVkIE1pbm9yIDogMQoKCSAg
ICBVcGRhdGUgVGltZSA6IFRodSBBdWcgIDQgMDA6MDU6NTcgMjAxMQoJCSAgU3RhdGUgOiBjbGVh
bgoJIEFjdGl2ZSBEZXZpY2VzIDogMQoJV29ya2luZyBEZXZpY2VzIDogMQoJIEZhaWxlZCBEZXZp
Y2VzIDogMQoJICBTcGFyZSBEZXZpY2VzIDogMAoJICAgICAgIENoZWNrc3VtIDogYmY3OGJmYmYg
LSBjb3JyZWN0CgkJIEV2ZW50cyA6IDEKCgoJICAgICAgTnVtYmVyICAgTWFqb3IgICBNaW5vciAg
IFJhaWREZXZpY2UgU3RhdGUKCXRoaXMgICAgIDAgICAgICAgOCAgICAgICAgMiAgICAgICAgMCAg
ICAgIGFjdGl2ZSBzeW5jICAgL2Rldi9zZGEyCgoJICAgMCAgICAgMCAgICAgICA4ICAgICAgICAy
ICAgICAgICAwICAgICAgYWN0aXZlIHN5bmMgICAvZGV2L3NkYTIKCSAgIDEgICAgIDAgICAgICAg
MCAgICAgICAgMCAgICAgICAgMCAgICAgIHNwYXJlCgkjIGJsa2lkIAoJL2Rldi9zZGExOiBVVUlE
PSJmYjdmM2RjNS1kMTgzLWNhYjYtMTIxMi0zMTIwMWEyMjA3YjkiIFRZUEU9ImxpbnV4X3JhaWRf
bWVtYmVyIiAKCS9kZXYvc2RhMjogVVVJRD0iNTJmZjJjZjItNDA5OC0xODU5LWQ4YjctOGY2NTk5
MjI2ZTQxIiBUWVBFPSJsaW51eF9yYWlkX21lbWJlciIKCiMjIyBPbGQgZHJpdmUgIyMjCgkvZGV2
L3NkYTI6CgkJICBNYWdpYyA6IGE5MmI0ZWZjCgkJVmVyc2lvbiA6IDAuOTAuMDAKCQkgICBVVUlE
IDogNTJmZjJjZjI6NDA5ODE4NTk6ZTU4ZDhkZDY6NWZhZWM0MmMKCSAgQ3JlYXRpb24gVGltZSA6
IFdlZCBNYXIgMjYgMTE6NTA6MDQgMjAwOAoJICAgICBSYWlkIExldmVsIDogcmFpZDEKCSAgVXNl
ZCBEZXYgU2l6ZSA6IDQ4Nzg4NTk1MiAoNDY1LjI4IEdpQiA0OTkuNjAgR0IpCgkgICAgIEFycmF5
IFNpemUgOiA0ODc4ODU5NTIgKDQ2NS4yOCBHaUIgNDk5LjYwIEdCKQoJICAgUmFpZCBEZXZpY2Vz
IDogMgoJICBUb3RhbCBEZXZpY2VzIDogMQoJUHJlZmVycmVkIE1pbm9yIDogMQoKCSAgICBVcGRh
dGUgVGltZSA6IFNhdCBKdW4gMTggMTQ6MjU6MTAgMjAxMQoJCSAgU3RhdGUgOiBjbGVhbgoJIEFj
dGl2ZSBEZXZpY2VzIDogMQoJV29ya2luZyBEZXZpY2VzIDogMQoJIEZhaWxlZCBEZXZpY2VzIDog
MQoJICBTcGFyZSBEZXZpY2VzIDogMAoJICAgICAgIENoZWNrc3VtIDogMzgwNjkyZmMgLSBjb3Jy
ZWN0CgkJIEV2ZW50cyA6IDI1NTcwODMyCgoKCSAgICAgIE51bWJlciAgIE1ham9yICAgTWlub3Ig
ICBSYWlkRGV2aWNlIFN0YXRlCgl0aGlzICAgICAwICAgICAgIDggICAgICAgIDIgICAgICAgIDAg
ICAgICBhY3RpdmUgc3luYyAgIC9kZXYvc2RhMgoKCSAgIDAgICAgIDAgICAgICAgOCAgICAgICAg
MiAgICAgICAgMCAgICAgIGFjdGl2ZSBzeW5jICAgL2Rldi9zZGEyCgkgICAxICAgICAxICAgICAg
IDAgICAgICAgIDAgICAgICAgIDEgICAgICBmYXVsdHkgcmVtb3ZlZAoKUGxlYXNlIHRlbGwgbWUg
d2hhdCBvdGhlciBpbmZvcm1hdGlvbiB5b3UgbmVlZC4KCgpUaGFua3MgaW4gYWR2YW5jZSwKClBh
dWwKCgpQUzogUGxlYXNlIGV4Y3VzZSB0aGlzIGxvbmcgbWVzc2FnZSBhbmQgcHJvYmFibHkgbWlz
dGFrZXMgaW4gaXQuIEl0IGlzIGFsbW9zdCBmb3VyIGluIHRoZSBtb3JuaW5nIGFuZCBhZnRlciAx
MCBob3VycyBkZWJ1Z2dpbmcgSSBhbSBxdWl0ZSBsb3N0LgoKClsxXSBodHRwOi8vd3d3Lmhlcm1h
bm4tdXdlLmRlL2Jsb2cvcmVzaXppbmctYS1kbS1jcnlwdC1sdm0tZXh0My1wYXJ0aXRpb24KWzJd
IGh0dHA6Ly9ncm1sLm9yZy8KWzNdIGh0dHA6Ly93aWtpLmRlYmlhbi5vcmcvRGViaWFuSW5zdGFs
bGVyL1Jlc2N1ZS9DcnlwdG8K
--001517475414d5e3cb04a9b2f819
Content-Type: application/octet-stream; name=20110804--new-drive--blkid
Content-Disposition: attachment; filename=20110804--new-drive--blkid
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gqy3xvw31

L2Rldi9zZGExOiBVVUlEPSJmYjdmM2RjNS1kMTgzLWNhYjYtMTIxMi0zMTIwMWEyMjA3YjkiIFRZ
UEU9ImxpbnV4X3JhaWRfbWVtYmVyIiAKL2Rldi9zZGEyOiBVVUlEPSI1MmZmMmNmMi00MDk4LTE4
NTktZDhiNy04ZjY1OTkyMjZlNDEiIFRZUEU9ImxpbnV4X3JhaWRfbWVtYmVyIiAKL2Rldi9zZGI0
OiBMQUJFTD0iZ3JtbDY0IDIwMTEuMDUiIFRZUEU9Imlzbzk2NjAiIAovZGV2L2xvb3AwOiBUWVBF
PSJzcXVhc2hmcyIgCg==
--001517475414d5e3cb04a9b2f819
Content-Type: application/octet-stream;
	name=20110804--new-drive--fdisk-l-sda
Content-Disposition: attachment; filename=20110804--new-drive--fdisk-l-sda
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gqy3y1wf2

CkRpc2sgL2Rldi9zZGE6IDIwMDAuNCBHQiwgMjAwMDM5ODkzNDAxNiBieXRlcwoyNTUgaGVhZHMs
IDYzIHNlY3RvcnMvdHJhY2ssIDI0MzIwMSBjeWxpbmRlcnMKVW5pdHMgPSBjeWxpbmRlcnMgb2Yg
MTYwNjUgKiA1MTIgPSA4MjI1MjgwIGJ5dGVzClNlY3RvciBzaXplIChsb2dpY2FsL3BoeXNpY2Fs
KTogNTEyIGJ5dGVzIC8gNDA5NiBieXRlcwpJL08gc2l6ZSAobWluaW11bS9vcHRpbWFsKTogNDA5
NiBieXRlcyAvIDQwOTYgYnl0ZXMKRGlzayBpZGVudGlmaWVyOiAweDAwMDliZjljCgogICBEZXZp
Y2UgQm9vdCAgICAgIFN0YXJ0ICAgICAgICAgRW5kICAgICAgQmxvY2tzICAgSWQgIFN5c3RlbQov
ZGV2L3NkYTEgICAqICAgICAgICAgICAxICAgICAgICAgIDYyICAgICAgNDk3OTgzKyAgZmQgIExp
bnV4IHJhaWQgYXV0b2RldGVjdApQYXJ0aXRpb24gMSBkb2VzIG5vdCBzdGFydCBvbiBwaHlzaWNh
bCBzZWN0b3IgYm91bmRhcnkuCi9kZXYvc2RhMiAgICAgICAgICAgICAgNjMgICAgICAyNDMyMDEg
IDE5NTMwMTQwMTcrICBmZCAgTGludXggcmFpZCBhdXRvZGV0ZWN0ClBhcnRpdGlvbiAyIGRvZXMg
bm90IHN0YXJ0IG9uIHBoeXNpY2FsIHNlY3RvciBib3VuZGFyeS4K
--001517475414d5e3cb04a9b2f819
Content-Type: application/octet-stream;
	name=20110804--new-drive--fdisk-s-sda1
Content-Disposition: attachment;
	filename=20110804--new-drive--fdisk-s-sda1
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gqy3yb5n3

NDk3OTgzCg==
--001517475414d5e3cb04a9b2f819
Content-Type: application/octet-stream;
	name=20110804--new-drive--fdisk-s-sda2
Content-Disposition: attachment;
	filename=20110804--new-drive--fdisk-s-sda2
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gqy3yhw24

MTk1MzAxNDAxNwo=
--001517475414d5e3cb04a9b2f819
Content-Type: application/octet-stream;
	name=20110804--new-drive--mdadm--examine-sda1
Content-Disposition: attachment;
	filename=20110804--new-drive--mdadm--examine-sda1
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gqy3yn5k5

L2Rldi9zZGExOgogICAgICAgICAgTWFnaWMgOiBhOTJiNGVmYwogICAgICAgIFZlcnNpb24gOiAw
LjkwLjAwCiAgICAgICAgICAgVVVJRCA6IGZiN2YzZGM1OmQxODNjYWI2OjEyMTIzMTIwOjFhMjIw
N2I5CiAgQ3JlYXRpb24gVGltZSA6IFdlZCBNYXIgMjYgMTE6NDk6NTcgMjAwOAogICAgIFJhaWQg
TGV2ZWwgOiByYWlkMQogIFVzZWQgRGV2IFNpemUgOiA0OTc4NTYgKDQ4Ni4yNyBNaUIgNTA5Ljgw
IE1CKQogICAgIEFycmF5IFNpemUgOiA0OTc4NTYgKDQ4Ni4yNyBNaUIgNTA5LjgwIE1CKQogICBS
YWlkIERldmljZXMgOiAyCiAgVG90YWwgRGV2aWNlcyA6IDEKUHJlZmVycmVkIE1pbm9yIDogMAoK
ICAgIFVwZGF0ZSBUaW1lIDogV2VkIEF1ZyAgMyAyMTozOTo1OCAyMDExCiAgICAgICAgICBTdGF0
ZSA6IGNsZWFuCiBBY3RpdmUgRGV2aWNlcyA6IDEKV29ya2luZyBEZXZpY2VzIDogMQogRmFpbGVk
IERldmljZXMgOiAxCiAgU3BhcmUgRGV2aWNlcyA6IDAKICAgICAgIENoZWNrc3VtIDogMzg4ZTk2
ZGQgLSBjb3JyZWN0CiAgICAgICAgIEV2ZW50cyA6IDIwMzM0CgoKICAgICAgTnVtYmVyICAgTWFq
b3IgICBNaW5vciAgIFJhaWREZXZpY2UgU3RhdGUKdGhpcyAgICAgMCAgICAgICA4ICAgICAgICAx
ICAgICAgICAwICAgICAgYWN0aXZlIHN5bmMgICAvZGV2L3NkYTEKCiAgIDAgICAgIDAgICAgICAg
OCAgICAgICAgMSAgICAgICAgMCAgICAgIGFjdGl2ZSBzeW5jICAgL2Rldi9zZGExCiAgIDEgICAg
IDEgICAgICAgMCAgICAgICAgMCAgICAgICAgMSAgICAgIGZhdWx0eSByZW1vdmVkCg==
--001517475414d5e3cb04a9b2f819
Content-Type: application/octet-stream;
	name=20110804--new-drive--mdadm--examine-sda2
Content-Disposition: attachment;
	filename=20110804--new-drive--mdadm--examine-sda2
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gqy3yv6a6

L2Rldi9zZGEyOgogICAgICAgICAgTWFnaWMgOiBhOTJiNGVmYwogICAgICAgIFZlcnNpb24gOiAw
LjkwLjAwCiAgICAgICAgICAgVVVJRCA6IDUyZmYyY2YyOjQwOTgxODU5OmQ4Yjc4ZjY1Ojk5MjI2
ZTQxIChsb2NhbCB0byBob3N0IGdybWwpCiAgQ3JlYXRpb24gVGltZSA6IFRodSBBdWcgIDQgMDA6
MDU6NTcgMjAxMQogICAgIFJhaWQgTGV2ZWwgOiByYWlkMQogIFVzZWQgRGV2IFNpemUgOiAxOTUz
MDEzOTUyICgxODYyLjU0IEdpQiAxOTk5Ljg5IEdCKQogICAgIEFycmF5IFNpemUgOiAxOTUzMDEz
OTUyICgxODYyLjU0IEdpQiAxOTk5Ljg5IEdCKQogICBSYWlkIERldmljZXMgOiAyCiAgVG90YWwg
RGV2aWNlcyA6IDIKUHJlZmVycmVkIE1pbm9yIDogMQoKICAgIFVwZGF0ZSBUaW1lIDogVGh1IEF1
ZyAgNCAwMDowNTo1NyAyMDExCiAgICAgICAgICBTdGF0ZSA6IGNsZWFuCiBBY3RpdmUgRGV2aWNl
cyA6IDEKV29ya2luZyBEZXZpY2VzIDogMQogRmFpbGVkIERldmljZXMgOiAxCiAgU3BhcmUgRGV2
aWNlcyA6IDAKICAgICAgIENoZWNrc3VtIDogYmY3OGJmYmYgLSBjb3JyZWN0CiAgICAgICAgIEV2
ZW50cyA6IDEKCgogICAgICBOdW1iZXIgICBNYWpvciAgIE1pbm9yICAgUmFpZERldmljZSBTdGF0
ZQp0aGlzICAgICAwICAgICAgIDggICAgICAgIDIgICAgICAgIDAgICAgICBhY3RpdmUgc3luYyAg
IC9kZXYvc2RhMgoKICAgMCAgICAgMCAgICAgICA4ICAgICAgICAyICAgICAgICAwICAgICAgYWN0
aXZlIHN5bmMgICAvZGV2L3NkYTIKICAgMSAgICAgMCAgICAgICAwICAgICAgICAwICAgICAgICAw
ICAgICAgc3BhcmUK
--001517475414d5e3cb04a9b2f819
Content-Type: application/octet-stream;
	name=20110804--new-drive--sfdisk-d-sda
Content-Disposition: attachment;
	filename=20110804--new-drive--sfdisk-d-sda
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gqy3yz0o7

IyBwYXJ0aXRpb24gdGFibGUgb2YgL2Rldi9zZGEKdW5pdDogc2VjdG9ycwoKL2Rldi9zZGExIDog
c3RhcnQ9ICAgICAgIDYzLCBzaXplPSAgIDk5NTk2NywgSWQ9ZmQsIGJvb3RhYmxlCi9kZXYvc2Rh
MiA6IHN0YXJ0PSAgIDk5NjAzMCwgc2l6ZT0zOTA2MDI4MDM1LCBJZD1mZAovZGV2L3NkYTMgOiBz
dGFydD0gICAgICAgIDAsIHNpemU9ICAgICAgICAwLCBJZD0gMAovZGV2L3NkYTQgOiBzdGFydD0g
ICAgICAgIDAsIHNpemU9ICAgICAgICAwLCBJZD0gMAo=
--001517475414d5e3cb04a9b2f819
Content-Type: application/octet-stream;
	name=20110804--new-drive--with-header-from-old-drive--cryptsetup-luksDump
Content-Disposition: attachment;
	filename=20110804--new-drive--with-header-from-old-drive--cryptsetup-luksDump
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gqy3z8r88

IyBjcnlwdHNldHVwIC0tdmVyYm9zZSAtLWRlYnVnIGx1a3NEdW1wIC9kZXYvc2RhMgojIGNyeXB0
c2V0dXAgMS4zLjAgcHJvY2Vzc2luZyAiY3J5cHRzZXR1cCAtLXZlcmJvc2UgLS1kZWJ1ZyBsdWtz
RHVtcCAvZGV2L3NkYTIiCiMgUnVubmluZyBjb21tYW5kIGx1a3NEdW1wLgojIExvY2tpbmcgbWVt
b3J5LgojIEFsbG9jYXRpbmcgY3J5cHQgZGV2aWNlIC9kZXYvc2RhMiBjb250ZXh0LgojIFRyeWlu
ZyB0byBvcGVuIGFuZCByZWFkIGRldmljZSAvZGV2L3NkYTIuCiMgSW5pdGlhbGlzaW5nIGRldmlj
ZS1tYXBwZXIgYmFja2VuZCwgVURFViBpcyBlbmFibGVkLgojIERldGVjdGVkIGRtLWNyeXB0IHZl
cnNpb24gMS4xMC4wLCBkbS1pb2N0bCB2ZXJzaW9uIDQuMTkuMS4KIyBUcnlpbmcgdG8gbG9hZCBM
VUtTMSBjcnlwdCB0eXBlIGZyb20gZGV2aWNlIC9kZXYvc2RhMi4KIyBJbml0aWFsaXNpbmcgZ2Ny
eXB0IGNyeXB0byBiYWNrZW5kLgojIFJlYWRpbmcgTFVLUyBoZWFkZXIgb2Ygc2l6ZSAxMDI0IGZy
b20gZGV2aWNlIC9kZXYvc2RhMgpMVUtTIGhlYWRlciBpbmZvcm1hdGlvbiBmb3IgL2Rldi9zZGEy
CgpWZXJzaW9uOiAgICAgICAgMQpDaXBoZXIgbmFtZTogICAgYWVzCkNpcGhlciBtb2RlOiAgICBj
YmMtZXNzaXY6c2hhMjU2Ckhhc2ggc3BlYzogICAgICBzaGExClBheWxvYWQgb2Zmc2V0OiAyMDU2
Ck1LIGJpdHM6ICAgICAgICAyNTYKTUsgZGlnZXN0OiAgICAgIGU5IGQyIDU2IGI3IDg3IDVmIDg5
IDkyIGZkIDJiIDk2IGVhIGYwIDdiIDA1IDY2IDU1IGY2IGM1IGE1Ck1LIHNhbHQ6ICAgICAgICAx
OSAxZCBlZSA3NCAwOSA1YiBkYiA5NSA1NyA2OCA0YyA3YyBmMSBlZiA5NiA1ZQogICAgICAgICAg
ICAgICAgYTkgZWIgMWQgNTcgN2EgZTEgYjcgYjggMjIgYTkgOTcgMjMgYTEgYzkgYjYgM2EKTUsg
aXRlcmF0aW9uczogIDEwClVVSUQ6ICAgICAgICAgICBjYjY2ODFiNC00ZGRhLTQ1NDgtOGM1OS0z
ZDk4MzhkZTljMjIKCktleSBTbG90IDA6IEVOQUJMRUQKICAgICAgICBJdGVyYXRpb25zOiAgICAg
ICAgICAgICA3NTg5MgogICAgICAgIFNhbHQ6ICAgICAgICAgICAgICAgICAgIDBmIDllIGE4IDIw
IGEyIDY4IDM2IDA5IDZlIDVlIGVkIGI4IGRkIDUwIDYzIDhjCiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgOWMgMDYgMjQgY2EgNjEgNjMgNjQgOGQgZjUgNmQgNzQgN2IgMGYgYWEgNzUg
ZDAKICAgICAgICBLZXkgbWF0ZXJpYWwgb2Zmc2V0OiAgICA4CiAgICAgICAgQUYgc3RyaXBlczog
ICAgICAgICAgICAgNDAwMApLZXkgU2xvdCAxOiBESVNBQkxFRApLZXkgU2xvdCAyOiBESVNBQkxF
RApLZXkgU2xvdCAzOiBESVNBQkxFRApLZXkgU2xvdCA0OiBESVNBQkxFRApLZXkgU2xvdCA1OiBE
SVNBQkxFRApLZXkgU2xvdCA2OiBESVNBQkxFRApLZXkgU2xvdCA3OiBESVNBQkxFRAojIFJlbGVh
c2luZyBjcnlwdCBkZXZpY2UgL2Rldi9zZGEyIGNvbnRleHQuCiMgUmVsZWFzaW5nIGRldmljZS1t
YXBwZXIgYmFja2VuZC4KIyBVbmxvY2tpbmcgbWVtb3J5LgpDb21tYW5kIHN1Y2Nlc3NmdWwuCg==
--001517475414d5e3cb04a9b2f819
Content-Type: application/octet-stream; name=20110804--old-drive--blkid
Content-Disposition: attachment; filename=20110804--old-drive--blkid
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gqy3zve59

L2Rldi9zZGExOiBVVUlEPSJmYjdmM2RjNS1kMTgzLWNhYjYtMTIxMi0zMTIwMWEyMjA3YjkiIFRZ
UEU9ImxpbnV4X3JhaWRfbWVtYmVyIiAKL2Rldi9zZGEyOiBVVUlEPSI1MmZmMmNmMi00MDk4LTE4
NTktZTU4ZC04ZGQ2NWZhZWM0MmMiIFRZUEU9ImxpbnV4X3JhaWRfbWVtYmVyIiAKL2Rldi9zZGI0
OiBMQUJFTD0iZ3JtbDY0IDIwMTEuMDUiIFRZUEU9Imlzbzk2NjAiIAovZGV2L2xvb3AwOiBUWVBF
PSJzcXVhc2hmcyIgCg==
--001517475414d5e3cb04a9b2f819
Content-Type: application/octet-stream; name=20110804--old-drive--fdisk-l
Content-Disposition: attachment; filename=20110804--old-drive--fdisk-l
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gqy401fg10

CkRpc2sgL2Rldi9zZGE6IDUwMC4xIEdCLCA1MDAxMDc4NjIwMTYgYnl0ZXMKMjU1IGhlYWRzLCA2
MyBzZWN0b3JzL3RyYWNrLCA2MDgwMSBjeWxpbmRlcnMKVW5pdHMgPSBjeWxpbmRlcnMgb2YgMTYw
NjUgKiA1MTIgPSA4MjI1MjgwIGJ5dGVzClNlY3RvciBzaXplIChsb2dpY2FsL3BoeXNpY2FsKTog
NTEyIGJ5dGVzIC8gNTEyIGJ5dGVzCkkvTyBzaXplIChtaW5pbXVtL29wdGltYWwpOiA1MTIgYnl0
ZXMgLyA1MTIgYnl0ZXMKRGlzayBpZGVudGlmaWVyOiAweDAwMDliZjljCgogICBEZXZpY2UgQm9v
dCAgICAgIFN0YXJ0ICAgICAgICAgRW5kICAgICAgQmxvY2tzICAgSWQgIFN5c3RlbQovZGV2L3Nk
YTEgICAqICAgICAgICAgICAxICAgICAgICAgIDYyICAgICAgNDk3OTgzKyAgZmQgIExpbnV4IHJh
aWQgYXV0b2RldGVjdAovZGV2L3NkYTIgICAgICAgICAgICAgIDYzICAgICAgIDYwODAxICAgNDg3
ODg2MDE3KyAgZmQgIExpbnV4IHJhaWQgYXV0b2RldGVjdAoKRGlzayAvZGV2L3NkYjogMjA5OSBN
QiwgMjA5OTI0OTE1MiBieXRlcwoxNiBoZWFkcywgMzIgc2VjdG9ycy90cmFjaywgODAwOCBjeWxp
bmRlcnMKVW5pdHMgPSBjeWxpbmRlcnMgb2YgNTEyICogNTEyID0gMjYyMTQ0IGJ5dGVzClNlY3Rv
ciBzaXplIChsb2dpY2FsL3BoeXNpY2FsKTogNTEyIGJ5dGVzIC8gNTEyIGJ5dGVzCkkvTyBzaXpl
IChtaW5pbXVtL29wdGltYWwpOiA1MTIgYnl0ZXMgLyA1MTIgYnl0ZXMKRGlzayBpZGVudGlmaWVy
OiAweGM5YTJiZTM4CgogICBEZXZpY2UgQm9vdCAgICAgIFN0YXJ0ICAgICAgICAgRW5kICAgICAg
QmxvY2tzICAgSWQgIFN5c3RlbQovZGV2L3NkYjQgICAqICAgICAgICAgICAxICAgICAgICAyNzkz
ICAgICAgNzE1MDA4ICAgOTYgIFVua25vd24KCkRpc2sgL2Rldi9zZGI0OiA3MzIgTUIsIDczMjE2
ODE5MiBieXRlcwoxNiBoZWFkcywgMzIgc2VjdG9ycy90cmFjaywgMjc5MyBjeWxpbmRlcnMKVW5p
dHMgPSBjeWxpbmRlcnMgb2YgNTEyICogNTEyID0gMjYyMTQ0IGJ5dGVzClNlY3RvciBzaXplIChs
b2dpY2FsL3BoeXNpY2FsKTogNTEyIGJ5dGVzIC8gNTEyIGJ5dGVzCkkvTyBzaXplIChtaW5pbXVt
L29wdGltYWwpOiA1MTIgYnl0ZXMgLyA1MTIgYnl0ZXMKRGlzayBpZGVudGlmaWVyOiAweGM5YTJi
ZTM4CgogICAgIERldmljZSBCb290ICAgICAgU3RhcnQgICAgICAgICBFbmQgICAgICBCbG9ja3Mg
ICBJZCAgU3lzdGVtCi9kZXYvc2RiNHA0ICAgKiAgICAgICAgICAgMSAgICAgICAgMjc5MyAgICAg
IDcxNTAwOCAgIDk2ICBVbmtub3duCg==
--001517475414d5e3cb04a9b2f819
Content-Type: application/octet-stream;
	name=20110804--old-drive--fdisk-s-sda1
Content-Disposition: attachment;
	filename=20110804--old-drive--fdisk-s-sda1
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gqy4020z11

NDk3OTgzCg==
--001517475414d5e3cb04a9b2f819
Content-Type: application/octet-stream;
	name=20110804--old-drive--fdisk-s-sda2
Content-Disposition: attachment;
	filename=20110804--old-drive--fdisk-s-sda2
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gqy402oj12

NDg3ODg2MDE3Cg==
--001517475414d5e3cb04a9b2f819
Content-Type: application/octet-stream;
	name=20110804--new-drive--sfdisk-d-sda
Content-Disposition: attachment;
	filename=20110804--new-drive--sfdisk-d-sda
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gqy403gp13

IyBwYXJ0aXRpb24gdGFibGUgb2YgL2Rldi9zZGEKdW5pdDogc2VjdG9ycwoKL2Rldi9zZGExIDog
c3RhcnQ9ICAgICAgIDYzLCBzaXplPSAgIDk5NTk2NywgSWQ9ZmQsIGJvb3RhYmxlCi9kZXYvc2Rh
MiA6IHN0YXJ0PSAgIDk5NjAzMCwgc2l6ZT0zOTA2MDI4MDM1LCBJZD1mZAovZGV2L3NkYTMgOiBz
dGFydD0gICAgICAgIDAsIHNpemU9ICAgICAgICAwLCBJZD0gMAovZGV2L3NkYTQgOiBzdGFydD0g
ICAgICAgIDAsIHNpemU9ICAgICAgICAwLCBJZD0gMAo=
--001517475414d5e3cb04a9b2f819
Content-Type: application/octet-stream;
	name=20110804--old-drive--mdadm--examine-sda1
Content-Disposition: attachment;
	filename=20110804--old-drive--mdadm--examine-sda1
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gqy403xc14

L2Rldi9zZGExOgogICAgICAgICAgTWFnaWMgOiBhOTJiNGVmYwogICAgICAgIFZlcnNpb24gOiAw
LjkwLjAwCiAgICAgICAgICAgVVVJRCA6IGZiN2YzZGM1OmQxODNjYWI2OjEyMTIzMTIwOjFhMjIw
N2I5CiAgQ3JlYXRpb24gVGltZSA6IFdlZCBNYXIgMjYgMTE6NDk6NTcgMjAwOAogICAgIFJhaWQg
TGV2ZWwgOiByYWlkMQogIFVzZWQgRGV2IFNpemUgOiA0OTc4NTYgKDQ4Ni4yNyBNaUIgNTA5Ljgw
IE1CKQogICAgIEFycmF5IFNpemUgOiA0OTc4NTYgKDQ4Ni4yNyBNaUIgNTA5LjgwIE1CKQogICBS
YWlkIERldmljZXMgOiAyCiAgVG90YWwgRGV2aWNlcyA6IDEKUHJlZmVycmVkIE1pbm9yIDogMAoK
ICAgIFVwZGF0ZSBUaW1lIDogU2F0IEp1biAxOCAxNDoyNToxMCAyMDExCiAgICAgICAgICBTdGF0
ZSA6IGNsZWFuCiBBY3RpdmUgRGV2aWNlcyA6IDEKV29ya2luZyBEZXZpY2VzIDogMQogRmFpbGVk
IERldmljZXMgOiAxCiAgU3BhcmUgRGV2aWNlcyA6IDAKICAgICAgIENoZWNrc3VtIDogMzg1MTgz
MzUgLSBjb3JyZWN0CiAgICAgICAgIEV2ZW50cyA6IDE5MjE0CgoKICAgICAgTnVtYmVyICAgTWFq
b3IgICBNaW5vciAgIFJhaWREZXZpY2UgU3RhdGUKdGhpcyAgICAgMCAgICAgICA4ICAgICAgICAx
ICAgICAgICAwICAgICAgYWN0aXZlIHN5bmMgICAvZGV2L3NkYTEKCiAgIDAgICAgIDAgICAgICAg
OCAgICAgICAgMSAgICAgICAgMCAgICAgIGFjdGl2ZSBzeW5jICAgL2Rldi9zZGExCiAgIDEgICAg
IDEgICAgICAgMCAgICAgICAgMCAgICAgICAgMSAgICAgIGZhdWx0eSByZW1vdmVkCg==
--001517475414d5e3cb04a9b2f819
Content-Type: application/octet-stream;
	name=20110804--old-drive--mdadm--examine-sda2
Content-Disposition: attachment;
	filename=20110804--old-drive--mdadm--examine-sda2
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gqy404hc15

L2Rldi9zZGEyOgogICAgICAgICAgTWFnaWMgOiBhOTJiNGVmYwogICAgICAgIFZlcnNpb24gOiAw
LjkwLjAwCiAgICAgICAgICAgVVVJRCA6IDUyZmYyY2YyOjQwOTgxODU5OmU1OGQ4ZGQ2OjVmYWVj
NDJjCiAgQ3JlYXRpb24gVGltZSA6IFdlZCBNYXIgMjYgMTE6NTA6MDQgMjAwOAogICAgIFJhaWQg
TGV2ZWwgOiByYWlkMQogIFVzZWQgRGV2IFNpemUgOiA0ODc4ODU5NTIgKDQ2NS4yOCBHaUIgNDk5
LjYwIEdCKQogICAgIEFycmF5IFNpemUgOiA0ODc4ODU5NTIgKDQ2NS4yOCBHaUIgNDk5LjYwIEdC
KQogICBSYWlkIERldmljZXMgOiAyCiAgVG90YWwgRGV2aWNlcyA6IDEKUHJlZmVycmVkIE1pbm9y
IDogMQoKICAgIFVwZGF0ZSBUaW1lIDogU2F0IEp1biAxOCAxNDoyNToxMCAyMDExCiAgICAgICAg
ICBTdGF0ZSA6IGNsZWFuCiBBY3RpdmUgRGV2aWNlcyA6IDEKV29ya2luZyBEZXZpY2VzIDogMQog
RmFpbGVkIERldmljZXMgOiAxCiAgU3BhcmUgRGV2aWNlcyA6IDAKICAgICAgIENoZWNrc3VtIDog
MzgwNjkyZmMgLSBjb3JyZWN0CiAgICAgICAgIEV2ZW50cyA6IDI1NTcwODMyCgoKICAgICAgTnVt
YmVyICAgTWFqb3IgICBNaW5vciAgIFJhaWREZXZpY2UgU3RhdGUKdGhpcyAgICAgMCAgICAgICA4
ICAgICAgICAyICAgICAgICAwICAgICAgYWN0aXZlIHN5bmMgICAvZGV2L3NkYTIKCiAgIDAgICAg
IDAgICAgICAgOCAgICAgICAgMiAgICAgICAgMCAgICAgIGFjdGl2ZSBzeW5jICAgL2Rldi9zZGEy
CiAgIDEgICAgIDEgICAgICAgMCAgICAgICAgMCAgICAgICAgMSAgICAgIGZhdWx0eSByZW1vdmVk
Cg==
--001517475414d5e3cb04a9b2f819
Content-Type: application/octet-stream;
	name=20110804--old-drive--sfdisk-d-sda
Content-Disposition: attachment;
	filename=20110804--old-drive--sfdisk-d-sda
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gqy419wm16

IyBwYXJ0aXRpb24gdGFibGUgb2YgL2Rldi9zZGEKdW5pdDogc2VjdG9ycwoKL2Rldi9zZGExIDog
c3RhcnQ9ICAgICAgIDYzLCBzaXplPSAgIDk5NTk2NywgSWQ9ZmQsIGJvb3RhYmxlCi9kZXYvc2Rh
MiA6IHN0YXJ0PSAgIDk5NjAzMCwgc2l6ZT05NzU3NzIwMzUsIElkPWZkCi9kZXYvc2RhMyA6IHN0
YXJ0PSAgICAgICAgMCwgc2l6ZT0gICAgICAgIDAsIElkPSAwCi9kZXYvc2RhNCA6IHN0YXJ0PSAg
ICAgICAgMCwgc2l6ZT0gICAgICAgIDAsIElkPSAwCg==
--001517475414d5e3cb04a9b2f819--
