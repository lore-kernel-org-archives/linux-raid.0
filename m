From: =?iso-8859-1?Q?Agust=EDn_Ciciliani?= <agustin@maderonet.net.ar>
Subject: RAID 1 - mdadm - Different UUID when booting
Date: Mon, 4 Oct 2004 09:13:49 -0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <00e501c4aa0b$9b409680$6800a8c0@Agus>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_00E2_01C4A9F2.75CEBF80"
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.

------=_NextPart_000_00E2_01C4A9F2.75CEBF80
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

Hi,

Everytime I boot my system It says that my partitions have different UUID.
If anybody know what I can do about it...

 Thanks in advance,

 Agustín


------=_NextPart_000_00E2_01C4A9F2.75CEBF80
Content-Type: text/plain;
	name="different UUID.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="different UUID.txt"

Oct  1 03:34:41 maria kernel: md: Autodetecting RAID arrays.
Oct  1 03:34:41 maria kernel: md: autorun ...
Oct  1 03:34:41 maria kernel: md: considering hdc13 ...
Oct  1 03:34:41 maria kernel: md:  adding hdc13 ...
Oct  1 03:34:41 maria kernel: md: hdc12 has different UUID to hdc13
Oct  1 03:34:41 maria kernel: md: hdc11 has different UUID to hdc13
Oct  1 03:34:41 maria kernel: md: hdc9 has different UUID to hdc13
Oct  1 03:34:41 maria kernel: md: hdc8 has different UUID to hdc13
Oct  1 03:34:41 maria kernel: md: hdc7 has different UUID to hdc13
Oct  1 03:34:41 maria kernel: md: hdc6 has different UUID to hdc13
Oct  1 03:34:41 maria kernel: md: hdc5 has different UUID to hdc13
Oct  1 03:34:41 maria kernel: md: hdc2 has different UUID to hdc13
Oct  1 03:34:41 maria kernel: md: hdc1 has different UUID to hdc13
Oct  1 03:34:41 maria kernel: md:  adding hda13 ...
Oct  1 03:34:41 maria kernel: md: hda12 has different UUID to hdc13
Oct  1 03:34:41 maria kernel: md: hda11 has different UUID to hdc13
Oct  1 03:34:41 maria kernel: md: hda9 has different UUID to hdc13
Oct  1 03:34:41 maria kernel: md: hda8 has different UUID to hdc13
Oct  1 03:34:41 maria kernel: md: hda7 has different UUID to hdc13
Oct  1 03:34:41 maria kernel: md: hda6 has different UUID to hdc13
Oct  1 03:34:41 maria kernel: md: hda5 has different UUID to hdc13
Oct  1 03:34:41 maria kernel: md: hda2 has different UUID to hdc13
Oct  1 03:34:41 maria kernel: md: hda1 has different UUID to hdc13
Oct  1 03:34:41 maria kernel: md: created md13
Oct  1 03:34:41 maria kernel: md: bind<hda13>
Oct  1 03:34:41 maria kernel: md: bind<hdc13>
Oct  1 03:34:41 maria kernel: md: running: <hdc13><hda13>
Oct  1 03:34:41 maria kernel: raid1: raid set md13 active with 2 out of 2 mirrors
Oct  1 03:34:41 maria kernel: md: considering hdc12 ...
Oct  1 03:34:41 maria kernel: md:  adding hdc12 ...
Oct  1 03:34:41 maria kernel: md: hdc11 has different UUID to hdc12
Oct  1 03:34:41 maria kernel: md: hdc9 has different UUID to hdc12
Oct  1 03:34:41 maria kernel: md: hdc8 has different UUID to hdc12
Oct  1 03:34:41 maria kernel: md: hdc7 has different UUID to hdc12
Oct  1 03:34:41 maria kernel: md: hdc6 has different UUID to hdc12
Oct  1 03:34:41 maria kernel: md: hdc5 has different UUID to hdc12
Oct  1 03:34:41 maria kernel: md: hdc2 has different UUID to hdc12
Oct  1 03:34:41 maria kernel: md: hdc1 has different UUID to hdc12
Oct  1 03:34:41 maria kernel: md:  adding hda12 ...
Oct  1 03:34:41 maria kernel: md: hda11 has different UUID to hdc12
Oct  1 03:34:41 maria kernel: md: hda9 has different UUID to hdc12
Oct  1 03:34:41 maria kernel: md: hda8 has different UUID to hdc12
Oct  1 03:34:41 maria kernel: md: hda7 has different UUID to hdc12
Oct  1 03:34:41 maria kernel: md: hda6 has different UUID to hdc12
Oct  1 03:34:41 maria kernel: md: hda5 has different UUID to hdc12
Oct  1 03:34:41 maria kernel: md: hda2 has different UUID to hdc12
Oct  1 03:34:41 maria kernel: md: hda1 has different UUID to hdc12
Oct  1 03:34:41 maria kernel: md: created md12
Oct  1 03:34:41 maria kernel: md: bind<hda12>
Oct  1 03:34:41 maria kernel: md: bind<hdc12>
Oct  1 03:34:41 maria kernel: md: running: <hdc12><hda12>
Oct  1 03:34:41 maria kernel: raid1: raid set md12 active with 2 out of 2 mirrors
Oct  1 03:34:41 maria kernel: md: considering hdc11 ...
Oct  1 03:34:41 maria kernel: md:  adding hdc11 ...
Oct  1 03:34:41 maria kernel: md: hdc9 has different UUID to hdc11
Oct  1 03:34:41 maria kernel: md: hdc8 has different UUID to hdc11
Oct  1 03:34:41 maria kernel: md: hdc7 has different UUID to hdc11
Oct  1 03:34:41 maria kernel: md: hdc6 has different UUID to hdc11
Oct  1 03:34:41 maria kernel: md: hdc5 has different UUID to hdc11
Oct  1 03:34:41 maria kernel: md: hdc2 has different UUID to hdc11
Oct  1 03:34:41 maria kernel: md: hdc1 has different UUID to hdc11
Oct  1 03:34:41 maria kernel: md:  adding hda11 ...
Oct  1 03:34:41 maria kernel: md: hda9 has different UUID to hdc11
Oct  1 03:34:41 maria kernel: md: hda8 has different UUID to hdc11
Oct  1 03:34:41 maria kernel: md: hda7 has different UUID to hdc11
Oct  1 03:34:41 maria kernel: md: hda6 has different UUID to hdc11
Oct  1 03:34:41 maria kernel: md: hda5 has different UUID to hdc11
Oct  1 03:34:41 maria kernel: md: hda2 has different UUID to hdc11
Oct  1 03:34:41 maria kernel: md: hda1 has different UUID to hdc11
Oct  1 03:34:41 maria kernel: md: created md11
Oct  1 03:34:41 maria kernel: md: bind<hda11>
Oct  1 03:34:41 maria kernel: md: bind<hdc11>
Oct  1 03:34:41 maria kernel: md: running: <hdc11><hda11>
Oct  1 03:34:41 maria kernel: raid1: raid set md11 active with 2 out of 2 mirrors
Oct  1 03:34:41 maria kernel: md: considering hdc9 ...
Oct  1 03:34:41 maria kernel: md:  adding hdc9 ...
Oct  1 03:34:41 maria kernel: md: hdc8 has different UUID to hdc9
Oct  1 03:34:41 maria kernel: md: hdc7 has different UUID to hdc9
Oct  1 03:34:41 maria kernel: md: hdc6 has different UUID to hdc9
Oct  1 03:34:41 maria kernel: md: hdc5 has different UUID to hdc9
Oct  1 03:34:41 maria kernel: md: hdc2 has different UUID to hdc9
Oct  1 03:34:41 maria kernel: md: hdc1 has different UUID to hdc9
Oct  1 03:34:41 maria kernel: md:  adding hda9 ...
Oct  1 03:34:41 maria kernel: md: hda8 has different UUID to hdc9
Oct  1 03:34:41 maria kernel: md: hda7 has different UUID to hdc9
Oct  1 03:34:41 maria kernel: md: hda6 has different UUID to hdc9
Oct  1 03:34:41 maria kernel: md: hda5 has different UUID to hdc9
Oct  1 03:34:41 maria kernel: md: hda2 has different UUID to hdc9
Oct  1 03:34:41 maria kernel: md: hda1 has different UUID to hdc9
Oct  1 03:34:41 maria kernel: md: created md9
Oct  1 03:34:41 maria kernel: md: bind<hda9>
Oct  1 03:34:41 maria kernel: md: bind<hdc9>
Oct  1 03:34:41 maria kernel: md: running: <hdc9><hda9>
Oct  1 03:34:41 maria kernel: raid1: raid set md9 active with 2 out of 2 mirrors
Oct  1 03:34:41 maria kernel: md: considering hdc8 ...
Oct  1 03:34:41 maria kernel: md:  adding hdc8 ...
Oct  1 03:34:41 maria kernel: md: hdc7 has different UUID to hdc8
Oct  1 03:34:41 maria kernel: md: hdc6 has different UUID to hdc8
Oct  1 03:34:41 maria kernel: md: hdc5 has different UUID to hdc8
Oct  1 03:34:41 maria kernel: md: hdc2 has different UUID to hdc8
Oct  1 03:34:41 maria kernel: md: hdc1 has different UUID to hdc8
Oct  1 03:34:41 maria kernel: md:  adding hda8 ...
Oct  1 03:34:41 maria kernel: md: hda7 has different UUID to hdc8
Oct  1 03:34:41 maria kernel: md: hda6 has different UUID to hdc8
Oct  1 03:34:41 maria kernel: md: hda5 has different UUID to hdc8
Oct  1 03:34:41 maria kernel: md: hda2 has different UUID to hdc8
Oct  1 03:34:41 maria kernel: md: hda1 has different UUID to hdc8
Oct  1 03:34:41 maria kernel: md: created md8
Oct  1 03:34:41 maria kernel: md: bind<hda8>
Oct  1 03:34:41 maria kernel: md: bind<hdc8>
Oct  1 03:34:41 maria kernel: md: running: <hdc8><hda8>
Oct  1 03:34:41 maria kernel: raid1: raid set md8 active with 2 out of 2 mirrors
Oct  1 03:34:41 maria kernel: md: considering hdc7 ...
Oct  1 03:34:41 maria kernel: md:  adding hdc7 ...
Oct  1 03:34:41 maria kernel: md: hdc6 has different UUID to hdc7
Oct  1 03:34:41 maria kernel: md: hdc5 has different UUID to hdc7
Oct  1 03:34:41 maria kernel: md: hdc2 has different UUID to hdc7
Oct  1 03:34:41 maria kernel: md: hdc1 has different UUID to hdc7
Oct  1 03:34:41 maria kernel: md:  adding hda7 ...
Oct  1 03:34:41 maria kernel: md: hda6 has different UUID to hdc7
Oct  1 03:34:41 maria kernel: md: hda5 has different UUID to hdc7
Oct  1 03:34:41 maria kernel: md: hda2 has different UUID to hdc7
Oct  1 03:34:41 maria kernel: md: hda1 has different UUID to hdc7
Oct  1 03:34:41 maria kernel: md: created md7
Oct  1 03:34:41 maria kernel: md: bind<hda7>
Oct  1 03:34:41 maria kernel: md: bind<hdc7>
Oct  1 03:34:41 maria kernel: md: running: <hdc7><hda7>
Oct  1 03:34:41 maria kernel: raid1: raid set md7 active with 2 out of 2 mirrors
Oct  1 03:34:41 maria kernel: md: considering hdc6 ...
Oct  1 03:34:41 maria kernel: md:  adding hdc6 ...
Oct  1 03:34:41 maria kernel: md: hdc5 has different UUID to hdc6
Oct  1 03:34:41 maria kernel: md: hdc2 has different UUID to hdc6
Oct  1 03:34:41 maria kernel: md: hdc1 has different UUID to hdc6
Oct  1 03:34:41 maria kernel: md:  adding hda6 ...
Oct  1 03:34:41 maria kernel: md: hda5 has different UUID to hdc6
Oct  1 03:34:41 maria kernel: md: hda2 has different UUID to hdc6
Oct  1 03:34:41 maria kernel: md: hda1 has different UUID to hdc6
Oct  1 03:34:41 maria kernel: md: created md6
Oct  1 03:34:41 maria kernel: md: bind<hda6>
Oct  1 03:34:41 maria kernel: md: bind<hdc6>
Oct  1 03:34:41 maria kernel: md: running: <hdc6><hda6>
Oct  1 03:34:41 maria kernel: raid1: raid set md6 active with 2 out of 2 mirrors
Oct  1 03:34:41 maria kernel: md: considering hdc5 ...
Oct  1 03:34:41 maria kernel: md:  adding hdc5 ...
Oct  1 03:34:41 maria kernel: md: hdc2 has different UUID to hdc5
Oct  1 03:34:41 maria kernel: md: hdc1 has different UUID to hdc5
Oct  1 03:34:41 maria kernel: md:  adding hda5 ...
Oct  1 03:34:41 maria kernel: md: hda2 has different UUID to hdc5
Oct  1 03:34:41 maria kernel: md: hda1 has different UUID to hdc5
Oct  1 03:34:41 maria kernel: md: created md5
Oct  1 03:34:41 maria kernel: md: bind<hda5>
Oct  1 03:34:41 maria kernel: md: bind<hdc5>
Oct  1 03:34:41 maria kernel: md: running: <hdc5><hda5>
Oct  1 03:34:41 maria kernel: raid1: raid set md5 active with 2 out of 2 mirrors
Oct  1 03:34:41 maria kernel: md: considering hdc2 ...
Oct  1 03:34:41 maria kernel: md:  adding hdc2 ...
Oct  1 03:34:41 maria kernel: md: hdc1 has different UUID to hdc2
Oct  1 03:34:41 maria kernel: md:  adding hda2 ...
Oct  1 03:34:41 maria kernel: md: hda1 has different UUID to hdc2
Oct  1 03:34:41 maria kernel: md: created md2
Oct  1 03:34:41 maria kernel: md: bind<hda2>
Oct  1 03:34:41 maria kernel: md: bind<hdc2>
Oct  1 03:34:41 maria kernel: md: running: <hdc2><hda2>
Oct  1 03:34:41 maria kernel: raid1: raid set md2 active with 2 out of 2 mirrors
Oct  1 03:34:41 maria kernel: md: considering hdc1 ...
Oct  1 03:34:41 maria kernel: md:  adding hdc1 ...
Oct  1 03:34:41 maria kernel: md:  adding hda1 ...
Oct  1 03:34:41 maria kernel: md: created md1
Oct  1 03:34:41 maria kernel: md: bind<hda1>
Oct  1 03:34:41 maria kernel: md: bind<hdc1>
Oct  1 03:34:41 maria kernel: md: running: <hdc1><hda1>
Oct  1 03:34:41 maria kernel: raid1: raid set md1 active with 2 out of 2 mirrors
Oct  1 03:34:41 maria kernel: md: ... autorun DONE.

------=_NextPart_000_00E2_01C4A9F2.75CEBF80--

