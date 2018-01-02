From: RQM <rqm@protonmail.com>
Subject: Troubleshooting "Buffer I/O error" on reading md device
Date: Mon, 01 Jan 2018 21:46:04 -0500
Message-ID: <1z_MZ4Xqld_IRMUbGJE66v2VUhXkBhlHnWJEfLASWNcv5s3Wo3A1YeuQBJBuksxJtFPpmsPbg1_F8PC3Sj4HrzL6Go3aIanVihzcC-4ZHEQ=@protonmail.com>
Reply-To: RQM <rqm@protonmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello everyone,

I hope this list is the right place to ask the following:

I've got a 5-disk RAID-5 array that's been built by a QNAP NAS device, whic=
h has recently failed (I suspect a faulty SATA controller or backplane).
I migrated the disks to a desktop computer that runs Debian stretch (kernel=
 4.9.65-3+deb9u1 amd64) and mdadm version 3.4. Although the array can be as=
sembled, I encountered the following error in my dmesg output ([1], recorde=
d directly after a recent reboot and fsck attempt) when running fsck:

Buffer I/O error on dev md0, logical block 1598030208, async page read

I can reliably reproduce that error by trying to read from the md0 device. =
It's always the same block, also across reboots.

I have suspected that possibly, one of the drives involved is faulty. Altho=
ugh smart errors have been logged [2], the errors are not recent enough to =
correlate with the fsck run. Also, I had sha1sum complete without error on =
every one of the individual disk devices /dev/sd[b-f], so reading from the =
drives does not provoke an error.

Finally, I tried scrubbing the array by writing repair to md/sync_action. T=
he process completed without any output to dmesg or signs of trouble in /pr=
oc/mdstat. However, reading from the array still fails at the same block as=
 above, 1598030208.

Here's the output of mdadm --detail /dev/md0: [3]

I assume the md driver would know what exactly the problem is, but I don't =
know where to look to find that information. How can I proceed troubleshoot=
ing this issue?

FYI, I had posted this on serverfault [4] previously, but unfortunately did=
n't arrive at a conclusion.

Thank you very much in advance!

[1] https://paste.ubuntu.com/26303735/
[2] https://paste.ubuntu.com/26303737/
[3] https://paste.ubuntu.com/26303754/
[4] https://serverfault.com/questions/889687/troubleshooting-buffer-i-o-err=
or-on-software-raid-md-device
