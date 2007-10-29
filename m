From: =?UTF-8?B?QkVSVFJBTkQgSm/Dq2w=?= <joel.bertrand@systella.fr>
Subject: Re: [BUG] Raid1/5 over iSCSI trouble
Date: Mon, 29 Oct 2007 11:40:05 +0100
Message-ID: <4725B885.8070705@systella.fr>
References: <4714BB92.7040701@systella.fr> <471864F8.9010209@systella.fr>	
	<1192809103.30976.11.camel@dwillia2-linux.ch.intel.com>	
	<4718DE66.8000905@tmr.com> <471916B5.6080709@systella.fr>	
	<47191855.4020402@systella.fr> <47191BCF.2000908@systella.fr>	
	<1192828331.30976.26.camel@dwillia2-linux.ch.intel.com>	
	<4719B6DE.9040403@systella.fr> <471EF07A.5040007@systella.fr>	
	<e9c3a7c20710241649qb26c36by5733a93cff394c40@mail.gmail.com>	
	<47233D37.6070409@systella.fr>
	<1193519604.4060.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iscsitarget-devel-bounces@lists.sourceforge.net>
In-Reply-To: <1193519604.4060.10.camel@localhost.localdomain>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/iscsitarget-devel>,
	<mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=iscsitarget-devel>
List-Post: <mailto:iscsitarget-devel@lists.sourceforge.net>
List-Help: <mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/iscsitarget-devel>,
	<mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: iscsitarget-devel-bounces@lists.sourceforge.net
Errors-To: iscsitarget-devel-bounces@lists.sourceforge.net
To: blackmagic02881@gmail.com
Cc: linux-raid@vger.kernel.org, sparclinux@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, iscsitarget-devel@lists.sourceforge.net, Bill Davidsen <davidsen@tmr.com>
List-Id: linux-raid.ids

Ming Zhang wrote:
> off topic, could you resubmit the alignment issue patch to list and see
> if tomof accept. he needs a patch inlined in email. it is found and
> fixed by you, so had better you post it (instead of me). thx.

diff -u kernel.old/iscsi.c kernel/iscsi.c
--- kernel.old/iscsi.c  2007-10-29 09:49:16.000000000 +0100
+++ kernel/iscsi.c      2007-10-17 11:19:14.000000000 +0200
@@ -726,13 +726,26 @@
         case READ_10:
         case WRITE_10:
         case WRITE_VERIFY:
-               *off = be32_to_cpu(*(u32 *)&cmd[2]);
+               *off = be32_to_cpu((((u32) cmd[2]) << 24) |
+                       (((u32) cmd[3]) << 16) |
+                       (((u32) cmd[4]) << 8) |
+                       cmd[5]);
                 *len = (cmd[7] << 8) + cmd[8];
                 break;
         case READ_16:
         case WRITE_16:
-               *off = be64_to_cpu(*(u64 *)&cmd[2]);
-               *len = be32_to_cpu(*(u32 *)&cmd[10]);
+               *off = be32_to_cpu((((u64) cmd[2]) << 56) |
+                       (((u64) cmd[3]) << 48) |
+                       (((u64) cmd[4]) << 40) |
+                       (((u64) cmd[5]) << 32) |
+                       (((u64) cmd[6]) << 24) |
+                       (((u64) cmd[7]) << 16) |
+                       (((u64) cmd[8]) << 8) |
+                       cmd[9]);
+               *len = be32_to_cpu((((u32) cmd[10]) << 24) |
+                       (((u32) cmd[11]) << 16) |
+                       (((u32) cmd[12]) << 8) |
+                       cmd[13]);
                 break;
         default:
                 BUG();
diff -u kernel.old/target_disk.c kernel/target_disk.c
--- kernel.old/target_disk.c    2007-10-29 09:49:16.000000000 +0100
+++ kernel/target_disk.c        2007-10-17 16:04:06.000000000 +0200
@@ -66,13 +66,15 @@
         unsigned char geo_m_pg[] = {0x04, 0x16, 0x00, 0x00, 0x00, 0x40, 
0x00, 0x
00,
                                     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
0x00, 0x
00,
                                     0x00, 0x00, 0x00, 0x00, 0x3a, 0x98, 
0x00, 0x
00};
-       u32 ncyl, *p;
+       u32 ncyl;
+       u32 n;

         /* assume 0xff heads, 15krpm. */
         memcpy(ptr, geo_m_pg, sizeof(geo_m_pg));
         ncyl = sec >> 14; /* 256 * 64 */
-       p = (u32 *)(ptr + 1);
-       *p = *p | cpu_to_be32(ncyl);
+       memcpy(&n,ptr+1,sizeof(u32));
+       n = n | cpu_to_be32(ncyl);
+       memcpy(ptr+1, &n, sizeof(u32));
         return sizeof(geo_m_pg);
  }

@@ -249,7 +251,10 @@
         struct iet_volume *lun;
         int rest, idx = 0;

-       size = be32_to_cpu(*(u32 *)&req->scb[6]);
+       size = be32_to_cpu((((u32) req->scb[6]) << 24) |
+                       (((u32) req->scb[7]) << 16) |
+                       (((u32) req->scb[8]) << 8) |
+                       req->scb[9]);
         if (size < 16)
                 return -1;

	Regards,

	JKB

-------------------------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc.
Still grepping through log files to find problems?  Stop.
Now Search log events and configuration files using AJAX and a browser.
Download your FREE copy of Splunk now >> http://get.splunk.com/
