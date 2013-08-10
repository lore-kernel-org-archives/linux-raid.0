From: Carsten Aulbert <Carsten.Aulbert@aei.mpg.de>
Subject: Recovering from two almost simultaneously failed devices in RAID1
Date: Sat, 10 Aug 2013 18:29:46 +0200
Message-ID: <52066A7A.5050007@aei.mpg.de>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms030403080602040208030609"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is a cryptographically signed message in MIME format.

--------------ms030403080602040208030609
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi there

I fear one of our mainboards did not play nicely with our SSDs in RAID1
configuration:
mdadm --detail /dev/md2
/dev/md2:
        Version : 1.2
  Creation Time : Fri Jul 27 11:58:50 2012
     Raid Level : raid1
     Array Size : 250050533 (238.47 GiB 256.05 GB)
  Used Dev Size : 250050533 (238.47 GiB 256.05 GB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

    Update Time : Sat Aug 10 14:58:30 2013
          State : clean, degraded
 Active Devices : 1
Working Devices : 1
 Failed Devices : 1
  Spare Devices : 0

    Number   Major   Minor   RaidDevice State
       0       8       49        0      active sync   /dev/sdd1
       1       0        0        1      removed

       1       8       33        -      faulty spare   /dev/sdc1


It seems both drives experienced some problem at around the same time,
sdc was taken offline first, but then sdd also had problems (see log at
the end of the email).

The filesystem on top of it (ext4) of course had no way of coping with
this problem, other than going to read/only.

The big questions of course are

(a) how to retrieve as much data as possible from the disks
(b) how to revive the raid system again

Any thoughts of what I should try first?

I think to tackle (a) I'll use ddrescue first, just trying to cover a
possible mistake I make later on

Cheers

Carsten


Here's the start of the log:

Aug 10 14:57:30 gitmaster kernel: [10731321.352291] ata3.00: exception
Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
Aug 10 14:57:30 gitmaster kernel: [10731321.352350] ata3.00: failed
command: WRITE FPDMA QUEUED
Aug 10 14:57:30 gitmaster kernel: [10731321.352380] ata3.00: cmd
61/02:00:47:00:00/00:00:00:00:00/40 tag 0 ncq 1024 out
Aug 10 14:57:30 gitmaster kernel: [10731321.352380]          res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Aug 10 14:57:30 gitmaster kernel: [10731321.352469] ata3.00: status: {
DRDY }
Aug 10 14:57:30 gitmaster kernel: [10731321.352495] ata3: hard resetting
link
Aug 10 14:57:30 gitmaster kernel: [10731321.352528] ata4.00: exception
Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
Aug 10 14:57:30 gitmaster kernel: [10731321.352574] ata4.00: failed
command: WRITE FPDMA QUEUED
Aug 10 14:57:30 gitmaster kernel: [10731321.352604] ata4.00: cmd
61/02:00:47:00:00/00:00:00:00:00/40 tag 0 ncq 1024 out
Aug 10 14:57:30 gitmaster kernel: [10731321.352605]          res
40/00:00:47:00:00/00:00:00:00:00/40 Emask 0x4 (timeout)
Aug 10 14:57:30 gitmaster kernel: [10731321.352695] ata4.00: status: {
DRDY }
Aug 10 14:57:30 gitmaster kernel: [10731321.352721] ata4: hard resetting
link
Aug 10 14:57:35 gitmaster kernel: [10731326.709171] ata3: link is slow
to respond, please be patient (ready=3D0)
Aug 10 14:57:35 gitmaster kernel: [10731326.721137] ata4: link is slow
to respond, please be patient (ready=3D0)
Aug 10 14:57:40 gitmaster kernel: [10731331.354487] ata3: COMRESET
failed (errno=3D-16)
Aug 10 14:57:40 gitmaster kernel: [10731331.354518] ata3: hard resetting
link
Aug 10 14:57:40 gitmaster kernel: [10731331.370448] ata4: COMRESET
failed (errno=3D-16)
Aug 10 14:57:40 gitmaster kernel: [10731331.370480] ata4: hard resetting
link
Aug 10 14:57:45 gitmaster kernel: [10731336.715383] ata3: link is slow
to respond, please be patient (ready=3D0)
Aug 10 14:57:45 gitmaster kernel: [10731336.735346] ata4: link is slow
to respond, please be patient (ready=3D0)
Aug 10 14:57:50 gitmaster kernel: [10731341.360692] ata3: COMRESET
failed (errno=3D-16)
Aug 10 14:57:50 gitmaster kernel: [10731341.360723] ata3: hard resetting
link
Aug 10 14:57:50 gitmaster kernel: [10731341.388654] ata4: COMRESET
failed (errno=3D-16)
Aug 10 14:57:50 gitmaster kernel: [10731341.388686] ata4: hard resetting
link
Aug 10 14:57:55 gitmaster kernel: [10731346.721587] ata3: link is slow
to respond, please be patient (ready=3D0)
Aug 10 14:57:55 gitmaster kernel: [10731346.749571] ata4: link is slow
to respond, please be patient (ready=3D0)
Aug 10 14:58:01 gitmaster /USR/SBIN/CRON[10885]: (root) CMD (cd
/srv/gitorious && rake ultrasphinx:index RAILS_ENV=3Dproduction >
/dev/null 2>&1)
Aug 10 14:58:25 gitmaster kernel: [10731376.344429] ata3: COMRESET
failed (errno=3D-16)
Aug 10 14:58:25 gitmaster kernel: [10731376.344464] ata3: limiting SATA
link speed to 1.5 Gbps
Aug 10 14:58:25 gitmaster kernel: [10731376.344497] ata3: hard resetting
link
Aug 10 14:58:25 gitmaster kernel: [10731376.424371] ata4: COMRESET
failed (errno=3D-16)
Aug 10 14:58:25 gitmaster kernel: [10731376.424403] ata4: limiting SATA
link speed to 1.5 Gbps
Aug 10 14:58:25 gitmaster kernel: [10731376.424436] ata4: hard resetting
link
Aug 10 14:58:30 gitmaster kernel: [10731381.365521] ata3: COMRESET
failed (errno=3D-16)
Aug 10 14:58:30 gitmaster kernel: [10731381.365554] ata3: reset failed,
giving up
Aug 10 14:58:30 gitmaster kernel: [10731381.365585] ata3.00: disabled
Aug 10 14:58:30 gitmaster kernel: [10731381.365610] ata3.00: device
reported invalid CHS sector 0
Aug 10 14:58:30 gitmaster kernel: [10731381.365643] ata3: EH complete
Aug 10 14:58:30 gitmaster kernel: [10731381.365675] sd 2:0:0:0: [sdc]
Unhandled error code
Aug 10 14:58:30 gitmaster kernel: [10731381.365701] sd 2:0:0:0: [sdc]
Result: hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
Aug 10 14:58:30 gitmaster kernel: [10731381.365748] sd 2:0:0:0: [sdc]
CDB: Write(10): 2a 00 00 00 00 47 00 00 02 00
Aug 10 14:58:30 gitmaster kernel: [10731381.365816] end_request: I/O
error, dev sdc, sector 71
Aug 10 14:58:30 gitmaster kernel: [10731381.365844] end_request: I/O
error, dev sdc, sector 71
Aug 10 14:58:30 gitmaster kernel: [10731381.365871] md: super_written
gets error=3D-5, uptodate=3D0
Aug 10 14:58:30 gitmaster kernel: [10731381.365900] md/raid1:md2: Disk
failure on sdc1, disabling device.
Aug 10 14:58:30 gitmaster kernel: [10731381.365900] md/raid1:md2:
Operation continuing on 1 devices.
Aug 10 14:58:30 gitmaster kernel: [10731381.453474] ata4: COMRESET
failed (errno=3D-16)
Aug 10 14:58:30 gitmaster kernel: [10731381.453505] ata4: reset failed,
giving up
Aug 10 14:58:30 gitmaster kernel: [10731381.453536] ata4.00: disabled
Aug 10 14:58:30 gitmaster kernel: [10731381.453565] ata4: EH complete
Aug 10 14:58:30 gitmaster kernel: [10731381.453596] sd 3:0:0:0: [sdd]
Unhandled error code
Aug 10 14:58:30 gitmaster kernel: [10731381.453621] sd 3:0:0:0: [sdd]
Result: hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
Aug 10 14:58:30 gitmaster kernel: [10731381.453669] sd 3:0:0:0: [sdd]
CDB: Write(10): 2a 00 00 00 00 47 00 00 02 00
Aug 10 14:58:30 gitmaster kernel: [10731381.453737] end_request: I/O
error, dev sdd, sector 71
Aug 10 14:58:30 gitmaster kernel: [10731381.453765] end_request: I/O
error, dev sdd, sector 71
Aug 10 14:58:30 gitmaster kernel: [10731381.453792] md: super_written
gets error=3D-5, uptodate=3D0
Aug 10 14:58:30 gitmaster kernel: [10731381.453867] sd 3:0:0:0: [sdd]
Unhandled error code
Aug 10 14:58:30 gitmaster kernel: [10731381.453894] sd 3:0:0:0: [sdd]
Result: hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
Aug 10 14:58:30 gitmaster kernel: [10731381.453941] sd 3:0:0:0: [sdd]
CDB: Write(10): 2a 00 00 00 00 47 00 00 02 00
Aug 10 14:58:30 gitmaster kernel: [10731381.454010] end_request: I/O
error, dev sdd, sector 71
Aug 10 14:58:30 gitmaster kernel: [10731381.454036] end_request: I/O
error, dev sdd, sector 71
Aug 10 14:58:30 gitmaster kernel: [10731381.454064] md: super_written
gets error=3D-5, uptodate=3D0
Aug 10 14:58:30 gitmaster kernel: [10731381.454136] RAID1 conf printout:
Aug 10 14:58:30 gitmaster kernel: [10731381.454140]  --- wd:1 rd:2
Aug 10 14:58:30 gitmaster kernel: [10731381.454143]  disk 0, wo:0, o:1,
dev:sdd1
Aug 10 14:58:30 gitmaster kernel: [10731381.454146]  disk 1, wo:1, o:0,
dev:sdc1
Aug 10 14:58:30 gitmaster kernel: [10731381.477438] RAID1 conf printout:
Aug 10 14:58:30 gitmaster kernel: [10731381.477442]  --- wd:1 rd:2
Aug 10 14:58:30 gitmaster kernel: [10731381.477446]  disk 0, wo:0, o:1,
dev:sdd1
Aug 10 14:58:30 gitmaster kernel: [10731381.477477] sd 3:0:0:0: [sdd]
Unhandled error code
Aug 10 14:58:30 gitmaster kernel: [10731381.477514] sd 3:0:0:0: [sdd]
Result: hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
Aug 10 14:58:30 gitmaster kernel: [10731381.477562] sd 3:0:0:0: [sdd]
CDB: Write(10): 2a 00 0e c7 da 6f 00 00 18 00
Aug 10 14:58:30 gitmaster kernel: [10731381.477630] end_request: I/O
error, dev sdd, sector 247978607
Aug 10 14:58:30 gitmaster kernel: [10731381.477728] Aborting journal on
device md2-8.
Aug 10 14:58:30 gitmaster kernel: [10731381.477774] sd 3:0:0:0: [sdd]
Unhandled error code
Aug 10 14:58:30 gitmaster kernel: [10731381.477802] sd 3:0:0:0: [sdd]
Result: hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
Aug 10 14:58:30 gitmaster kernel: [10731381.477851] sd 3:0:0:0: [sdd]
CDB: Write(10): 2a 00 0e c4 08 3f 00 00 08 00
Aug 10 14:58:30 gitmaster kernel: [10731381.477922] end_request: I/O
error, dev sdd, sector 247728191
Aug 10 14:58:30 gitmaster kernel: [10731381.477944] sd 3:0:0:0: [sdd]
Unhandled error code
Aug 10 14:58:30 gitmaster kernel: [10731381.477945] sd 3:0:0:0: [sdd]
Result: hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
Aug 10 14:58:30 gitmaster kernel: [10731381.477947] sd 3:0:0:0: [sdd]
CDB: Write(10): 2a 00 00 00 08 3f 00 00 08 00
Aug 10 14:58:30 gitmaster kernel: [10731381.477950] end_request: I/O
error, dev sdd, sector 2111
Aug 10 14:58:30 gitmaster kernel: [10731381.477982] Buffer I/O error on
device md2, logical block 0
Aug 10 14:58:30 gitmaster kernel: [10731381.477983] lost page write due
to I/O error on md2
Aug 10 14:58:30 gitmaster kernel: [10731381.478011] EXT4-fs error
(device md2): ext4_journal_start_sb:327: Detected aborted journal
Aug 10 14:58:30 gitmaster kernel: [10731381.478013] EXT4-fs (md2):
Remounting filesystem read-only
Aug 10 14:58:30 gitmaster kernel: [10731381.478014] EXT4-fs (md2):
previous I/O error to superblock detected
Aug 10 14:58:30 gitmaster kernel: [10731381.478052] sd 3:0:0:0: [sdd]
Unhandled error code
Aug 10 14:58:30 gitmaster kernel: [10731381.478054] sd 3:0:0:0: [sdd]
Result: hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
Aug 10 14:58:30 gitmaster kernel: [10731381.478055] sd 3:0:0:0: [sdd]
CDB: Write(10): 2a 00 00 00 08 3f 00 00 08 00
Aug 10 14:58:30 gitmaster kernel: [10731381.478059] end_request: I/O
error, dev sdd, sector 2111
Aug 10 14:58:30 gitmaster kernel: [10731381.478078] Buffer I/O error on
device md2, logical block 0
Aug 10 14:58:30 gitmaster kernel: [10731381.478079] lost page write due
to I/O error on md2
Aug 10 14:58:30 gitmaster kernel: [10731381.485182] Buffer I/O error on
device md2, logical block 30965760
Aug 10 14:58:30 gitmaster kernel: [10731381.485184] lost page write due
to I/O error on md2
Aug 10 14:58:30 gitmaster kernel: [10731381.485190] JBD2: I/O error
detected when updating journal superblock for md2-8.
Aug 10 14:58:30 gitmaster mdadm[1470]: Fail event detected on md device
/dev/md/2, component device /dev/sdc1



--=20
Dr. Carsten Aulbert - Max Planck Institute for Gravitational Physics
Callinstrasse 38, 30167 Hannover, Germany
phone/fax: +49 511 762-17185 / -17193
https://wiki.atlas.aei.uni-hannover.de/foswiki/bin/view/ATLAS/WebHome


--------------ms030403080602040208030609
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIE8DCC
BOwwggPUoAMCAQICAk/QMA0GCSqGSIb3DQEBBQUAMDYxCzAJBgNVBAYTAkRFMRMwEQYDVQQK
EwpHZXJtYW5HcmlkMRIwEAYDVQQDEwlHcmlkS2EtQ0EwHhcNMTMwNTA2MTU1OTM4WhcNMTQw
NjA1MTU1OTM4WjA9MRMwEQYDVQQKEwpHZXJtYW5HcmlkMQwwCgYDVQQLEwNBRUkxGDAWBgNV
BAMTD0NhcnN0ZW4gQXVsYmVydDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAJzM
vu6K/4EHUx/JuCoansTOW8cSyuPbvElm7IfuuEfXHJ1/m/Lbkv/C7oA+0Pvk4WCOLBx1OVUk
4vVZ0Lq6G9ekTgeZVaqFvHXKlFdUvdp3b5/nlAGc3z7GaDG/F6LdI5Iu374cTdeSvkuNseRg
KZP6Qq4GIMAZZ2hv1JC/xDxZs/59ACuL0IsjmdZPEiR8uiF01ZejehmdFiPJJP8at+PJgnoW
hW21Gh72CYI3CjvfB37Q5fUOqF1gMsfJmsJokwYfLLy8BcWbmP5BQ8IOL42F2RsuPTctnnbS
hhYj73Qyp4/Mxzeg1r34ZevEqM1pX6ceW7I/7Aos8HmhbcW71KMCAwEAAaOCAfswggH3MAwG
A1UdEwEB/wQCMAAwDgYDVR0PAQH/BAQDAgSwMB0GA1UdDgQWBBTeMPDcRbuXT/FdxHmf8kNH
EWVOVjAfBgNVHSMEGDAWgBTGdckorNEL/Dz/ubUe0187gGISNDAlBgNVHREEHjAcgRpDYXJz
dGVuLkF1bGJlcnRAYWVpLm1wZy5kZTAcBgNVHRIEFTATgRFncmlka2EtY2FAa2l0LmVkdTA1
BgNVHR8ELjAsMCqgKKAmhiRodHRwOi8vZ3JpZC5memsuZGUvY2EvZ3JpZGthLWNybC5kZXIw
KAYDVR0gBCEwHzAPBg0rBgEEAZQ2qywBAQEIMAwGCiqGSIb3TAUCAgEwEQYJYIZIAYb4QgEB
BAQDAgWgME4GCWCGSAGG+EIBDQRBFj9DZXJ0aWZpY2F0ZSBpc3N1ZWQgdW5kZXIgQ1AvQ1BT
IHYuIDEuOCBhdCBodHRwOi8vZ3JpZC5memsuZGUvY2EwJAYJYIZIAYb4QgECBBcWFWh0dHA6
Ly9ncmlkLmZ6ay5kZS9jYTAzBglghkgBhvhCAQgEJhYkaHR0cDovL2dyaWQuZnprLmRlL2Nh
L2dyaWRrYS1jcHMucGRmMDMGCWCGSAGG+EIBAwQmFiRodHRwOi8vZ3JpZC5memsuZGUvY2Ev
Z3JpZGthLWNybC5kZXIwDQYJKoZIhvcNAQEFBQADggEBALkdDvMzLkK1EpFkRPxEA4GpbYyy
5p59V9057HT/QUYvD7rO5KiayiRoDqgKeDW59Fek1N5W0d2IuN+j+VWLDqlBI1THd33F3Dqc
08Me/q6OkpHDjhCDnuH353n2gyxnsmXEEMozhx4onJbX0N3kZxjgNKEiP9R+zOq6Qq+CgKFS
O5w/wdtCTQ5Tpfr/n90KWYwVQ2er5dnKowu6j9YIj/dD8jJGk3T13rgzdnRzWtSQhjP8YIRf
ql08NsUgDShjNiBo289K7fpBNdVLGNI/pIA8P1ratofCGBPvMdjp+cjhulQX5//qS1ctP0ux
8MhY3kBMGynLkwibH5MiLfVSip0xggLOMIICygIBATA8MDYxCzAJBgNVBAYTAkRFMRMwEQYD
VQQKEwpHZXJtYW5HcmlkMRIwEAYDVQQDEwlHcmlkS2EtQ0ECAk/QMAkGBSsOAwIaBQCgggFn
MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTEzMDgxMDE2Mjk0
NlowIwYJKoZIhvcNAQkEMRYEFBBQjj310PT4Y36qnVFW1UUzIiyiMEsGCSsGAQQBgjcQBDE+
MDwwNjELMAkGA1UEBhMCREUxEzARBgNVBAoTCkdlcm1hbkdyaWQxEjAQBgNVBAMTCUdyaWRL
YS1DQQICT9AwTQYLKoZIhvcNAQkQAgsxPqA8MDYxCzAJBgNVBAYTAkRFMRMwEQYDVQQKEwpH
ZXJtYW5HcmlkMRIwEAYDVQQDEwlHcmlkS2EtQ0ECAk/QMGwGCSqGSIb3DQEJDzFfMF0wCwYJ
YIZIAWUDBAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYI
KoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwDQYJKoZIhvcNAQEBBQAEggEA
akI1E2E/KhiE8qgDjbGANRWziuDwRlqjdgnszf1+QPqh/seEDSdE8id94320oCj9LNP/YVUC
rOonCsC1NZCFSYJ/8HfRoYCTdZaFAqkGdVVU41nRGRC/Mdpz5PAzh1IGWx6Lc4LQAPxa+9x1
Ml1Kyz4osU81qPLNjRVCN73ah+SaKEndB0SZ/A2NQ5BEFe0DH8FCww9t9dX1qWkC1H1othwd
HGCBq1w2tAQCEokobPmvzeIJkyF4hE8vaJZooXSfNKA5ecw1kazaTNlXAHoQuTZhmV4YNbXz
MlygL92C7QSck6+pQk8290wSxM64rGrMZuTCGiKwNY6xjTHabfs1EwAAAAAAAA==
--------------ms030403080602040208030609--
