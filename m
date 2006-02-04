From: Luca Berra <bluca@comedia.it>
Subject: Re: ANNOUNCE: mdadm 2.3 - A tool for managing Soft RAID under Linux
Date: Sat, 4 Feb 2006 18:37:45 +0100
Message-ID: <20060204173744.GB31715@percy.comedia.it>
References: <17377.38441.974634.267086@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="fUYQa+Pmc3FrFX/N"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17377.38441.974634.267086@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On Thu, Feb 02, 2006 at 04:18:33PM +1100, Neil Brown wrote:
>
>
>I am pleased to announce the availability of
>   mdadm version 2.3
>
and i am pleased to reply with the first patch for mdadm 2.3,
which will allow building on 64bit machines.

Regards,
L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \

--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="mdadm-2.3-x86_64.patch"

--- mdadm-2.3/super1.c.x86_64	2006-01-31 02:45:32.000000000 +0100
+++ mdadm-2.3/super1.c	2006-02-04 18:25:48.000000000 +0100
@@ -198,7 +198,7 @@
 		       (long)__le32_to_cpu(sb->bitmap_offset));
 	}
 	if (sb->feature_map & __le32_to_cpu(MD_FEATURE_RESHAPE_ACTIVE)) {
-		printf("  Reshape pos'n : %llu%s\n", __le64_to_cpu(sb->reshape_position)/2,
+		printf("  Reshape pos'n : %llu%s\n", (unsigned long long) __le64_to_cpu(sb->reshape_position)/2,
 		       human_size(__le64_to_cpu(sb->reshape_position)<<9));
 		if (__le32_to_cpu(sb->delta_disks)) {
 			printf("  Delta Devices : %d", __le32_to_cpu(sb->delta_disks));
--- mdadm-2.3/super0.c.x86_64	2006-01-27 08:06:09.000000000 +0100
+++ mdadm-2.3/super0.c	2006-02-04 18:25:55.000000000 +0100
@@ -124,7 +124,7 @@
 	printf("Preferred Minor : %d\n", sb->md_minor);
 	printf("\n");
 	if (sb->minor_version > 90 && (sb->reshape_position+1) != 0) {
-		printf("  Reshape pos'n : %llu%s\n", sb->reshape_position/2, human_size((long long)sb->reshape_position<<9));
+		printf("  Reshape pos'n : %llu%s\n", (unsigned long long) sb->reshape_position/2, human_size((long long)sb->reshape_position<<9));
 		if (sb->delta_disks) {
 			printf("  Delta Devices : %d", sb->delta_disks);
 			if (sb->delta_disks)

--fUYQa+Pmc3FrFX/N--
