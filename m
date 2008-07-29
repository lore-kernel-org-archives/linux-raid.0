From: Neil Brown <neilb@suse.de>
Subject: Re: cosmetic bug in mdadm
Date: Tue, 29 Jul 2008 11:09:14 +1000
Message-ID: <18574.28090.931731.900997@notabene.brown>
References: <cccedfc60807281035n23a93665s412cab3b25464ef5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jon Nelson on Monday July 28
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday July 28, jnelson-linux-raid@jamponi.net wrote:
> mdadm --grow --help shows
> 
>   --raid-disks=  -n   : Change the number of active devices in an array.
>                       : array.
> 
> but the manpage uses:
> 
>   --raid-devices
> 
> The latter should be preferred?
> Also, a --grow fails without a spare or --backup-file, however
> --backup-file is only in the manpage, not in the --help. That's pretty
> minor but useful.

Fair comments.
Does this address your observations suitably?

Thanks.
NeilBrown



diff --git a/ReadMe.c b/ReadMe.c
index 0a736ed..7a67158 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -518,9 +518,12 @@ char Help_grow[] =
 "  --size=        -z   : Change the active size of devices in an array.\n"
 "                      : This is useful if all devices have been replaced\n"
 "                      : with larger devices.\n"
-"  --raid-disks=  -n   : Change the number of active devices in an array.\n"
+"  --raid-devices= -n  : Change the number of active devices in an array.\n"
 "                      : array.\n"
 "  --bitmap=      -b   : Add or remove a write-intent bitmap.\n"
+"  --backup-file= file : A file on a differt device to store data for a\n"
+"                      : short time while increasing raid-devices on a\n"
+"                      : RAID4/5/6 array. Not needed when a spare is present.\n"
 ;
 
 char Help_incr[] =
diff --git a/mdadm.8 b/mdadm.8
index fd26e12..be8568d 100644
--- a/mdadm.8
+++ b/mdadm.8
@@ -1729,7 +1729,7 @@ Currently the only support available is to
 change the "size" attribute
 for RAID1, RAID5 and RAID6.
 .IP \(bu 4
-increase the "raid-disks" attribute of RAID1, RAID5, and RAID6.
+increase the "raid\-devices" attribute of RAID1, RAID5, and RAID6.
 .IP \(bu 4
 add a write-intent bitmap to any array which supports these bitmaps, or
 remove a write-intent bitmap from such an array.
diff --git a/mdadm.c b/mdadm.c
index 641d717..3aa3b13 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1155,7 +1155,7 @@ int main(int argc, char *argv[])
 			break;
 		}
 		if (raiddisks == 0) {
-			fprintf(stderr, Name ": no raid-disks specified.\n");
+			fprintf(stderr, Name ": no raid-devices specified.\n");
 			rv = 1;
 			break;
 		}
@@ -1179,7 +1179,7 @@ int main(int argc, char *argv[])
 			break;
 		}
 		if (raiddisks == 0) {
-			fprintf(stderr, Name ": no raid-disks specified.\n");
+			fprintf(stderr, Name ": no raid-devices specified.\n");
 			rv = 1;
 			break;
 		}
