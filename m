From: Martin Wilck <mwilck@arcor.de>
Subject: Re: MD array keeps resyncing after rebooting
Date: Thu, 25 Jul 2013 20:58:19 +0200
Message-ID: <51F1754B.5000905@arcor.de>
References: <CAC9WiBjm5-RJ=CfpXMG7CCBp7StzWDuhp5XyFs4hAW3sxX7Gfw@mail.gmail.com>	<CAC9WiBjs4DQqt1G911OBALzSqn=o_=L1S4_K_MvUWhAu-rhtUw@mail.gmail.com>	<51EED0DA.3020901@arcor.de>	<51EED102.4020503@arcor.de>	<CAC9WiBgN1-HBEgqwo7CWor=nihCYUcOrYKhGxYTgbC-d4a7_-g@mail.gmail.com>	<51EEF3D3.7020305@arcor.de>	<CAC9WiBgrjrPRcHa5kh8TUfqN0rBBFC4M0_8iDkU3O0SOFgFW5g@mail.gmail.com> <CAC9WiBjQz6MJxBuw+cLWFZ-vOsdbYYSKdE575emH_AG5EmnGdw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080300060805020909030703"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9WiBjQz6MJxBuw+cLWFZ-vOsdbYYSKdE575emH_AG5EmnGdw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------080300060805020909030703
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 07/24/2013 03:50 PM, Francis Moreau wrote:

> I regenerated the initramfs in order to use the new binaries when
> booting and now I can see some new warnings:
> 
>   $ dracut -f
>   mdmon: Failed to load secondary DDF header on /dev/block/8:0
>   mdmon: Failed to load secondary DDF header on /dev/block/8:16
>   ...
> 
> I ignored them for now.

The message is non-fatal. But is certainly strange, given that you have
a LSI BIOS. It looks as if something was wrong with your secondary
header. You may try the attached patch to understand the problem better.

> Now the latest version of mdadm is used :
> 
>   $ cat /proc/mdstat
>   Personalities : [raid1]
>   md126 : active raid1 sdb[1] sda[0]
>         975585280 blocks super external:/md127/0 [2/2] [UU]
> 
>   md127 : inactive sdb[1](S) sda[0](S)
>         2354608 blocks super external:ddf

So you did another rebuild of the array with the updated mdadm?

> I run mdadm -E /dev/sdX for all RAID disks before and after reboot.
> I'm still having this warning:
> 
>    mdmon: Failed to load secondary DDF header on /dev/sda
> 
> You can find the differences below:
> 
> diff -Nurp before/sda.txt after/sda.txt
> --- before/sda.txt      2013-07-24 15:15:33.304015379 +0200
> +++ after/sda.txt       2013-07-24 15:49:09.520132838 +0200
> @@ -9,11 +9,11 @@ Controller GUID : 4C534920:20202020:FFFF
>    Redundant hdr : yes
>    Virtual Disks : 1
> 
> -      VD GUID[0] : 4C534920:20202020:80861D60:00000000:3F2103E0:00001450
> -                  (LSI      07/24/13 12:18:08)
> +      VD GUID[0] : 4C534920:20202020:80861D60:00000000:3F213401:00001450
> +                  (LSI      07/24/13 15:43:29)

This is weird. it looks as if the array had been recreated by the BIOS.
Normally the GUID should stay constant over reboots.

>           unit[0] : 0
>          state[0] : Optimal, Not Consistent
> -   init state[0] : Fully Initialised

Not Consistent and Fully Initialized - This looks as if the array didn't
close down cleanly. Is this the result of rebuilding the array with
mdmon 3.3-rc1?

Thinking about it - you did some coding of your own to start mdmon in
the initrd, right? Do you also make sure that mdadm -Ss is called after
umounting the file systems, but before shutdown? If not, an inconsistent
state might result.

> +   init state[0] : Not Initialised
>         access[0] : Read/Write
>           Name[0] : array0
>   Raid Devices[0] : 2 (0 1)
> diff -Nurp before/sdb.txt after/sdb.txt
> --- before/sdb.txt      2013-07-24 15:17:50.300581049 +0200
> +++ after/sdb.txt       2013-07-24 15:49:15.159997204 +0200
> @@ -9,11 +9,11 @@ Controller GUID : 4C534920:20202020:FFFF
>    Redundant hdr : yes
>    Virtual Disks : 1
> 
> -      VD GUID[0] : 4C534920:20202020:80861D60:00000000:3F2103E0:00001450
> -                  (LSI      07/24/13 12:18:08)
> +      VD GUID[0] : 4C534920:20202020:80861D60:00000000:3F213401:00001450
> +                  (LSI      07/24/13 15:43:29)

Again, new GUID. Did you recreate the array?

Regards
Martin


--------------080300060805020909030703
Content-Type: text/x-patch;
 name="load-ddf-header-logging.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="load-ddf-header-logging.patch"

From 4e689b7d63e21db21f5bbc0e06b011648265705d Mon Sep 17 00:00:00 2001
From: Martin Wilck <mwilck@arcor.de>
Date: Thu, 25 Jul 2013 21:48:32 +0200
Subject: [PATCH] DDF: load_ddf_header: more error logging

Try to determine problem if load_ddf_header fails.
---
 super-ddf.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 234d816..fdfc1d5 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -754,18 +754,24 @@ static int load_ddf_header(int fd, unsigned long long lba,
 	if (read(fd, hdr, 512) != 512)
 		return 0;
 
-	if (!be32_eq(hdr->magic, DDF_HEADER_MAGIC))
+	if (!be32_eq(hdr->magic, DDF_HEADER_MAGIC)) {
+		pr_err("%s: bad header magic\n", __func__);
 		return 0;
-	if (!be32_eq(calc_crc(hdr, 512), hdr->crc))
+	}
+	if (!be32_eq(calc_crc(hdr, 512), hdr->crc)) {
+		pr_err("%s: bad CRC\n", __func__);
 		return 0;
+	}
 	if (memcmp(anchor->guid, hdr->guid, DDF_GUID_LEN) != 0 ||
 	    memcmp(anchor->revision, hdr->revision, 8) != 0 ||
 	    !be64_eq(anchor->primary_lba, hdr->primary_lba) ||
 	    !be64_eq(anchor->secondary_lba, hdr->secondary_lba) ||
 	    hdr->type != type ||
 	    memcmp(anchor->pad2, hdr->pad2, 512 -
-		   offsetof(struct ddf_header, pad2)) != 0)
+		   offsetof(struct ddf_header, pad2)) != 0) {
+		pr_err("%s: header mismatch\n", __func__);
 		return 0;
+	}
 
 	/* Looks good enough to me... */
 	return 1;
-- 
1.7.1


--------------080300060805020909030703--
