From: Luca Berra <bluca@comedia.it>
Subject: Stacked devices (Was: Is there a good reason why I can't "mdadm -Gfn1 /dev/md1" ?)
Date: Sun, 12 Jun 2005 19:22:52 +0200
Message-ID: <20050612172251.GA11412@percy.comedia.it>
References: <E1DgFzi-0007K9-00@mta2.cl.cam.ac.uk> <17064.9218.919914.356958@cse.unsw.edu.au> <20050609112055.GA26006@percy.comedia.it> <17064.16812.95215.185952@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="liOOAslEiF7prFVr"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17064.16812.95215.185952@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On Thu, Jun 09, 2005 at 11:18:36PM +1000, Neil Brown wrote:
>On Thursday June 9, bluca@comedia.it wrote:
>> On Thu, Jun 09, 2005 at 09:12:02PM +1000, Neil Brown wrote:
>> >I'm very close to releasing mdadm 1.12.0.  It will have this fixed.
>> 
>> do you have a prerelease, i'd like to test the stacking stuff.
>
>try:
>  http://www.cse.unsw.edu.au/~neilb/source/mdadm/mdadm-test.tgz
>
>It doesn't have an updated version number of anything, but it does try
>to get --stop --scan right for stacked devices, and it does have
thanks a lot, now stopping stacked devices work.

>(I haven't done anything about improving the lot of --assemble for
>stacked devices)

i did some investigation and found the issue that caused mdadm failing
for me with stacked device.
I am an udev user and i use the --auto flag to assemble to create the
device files.
mdadm does create a device list at the beginning and while reloading the
/proc/partitions file does not add new md devices to the device list, so
i plugged add_dev into open_mddev() and now everything seems to work
perfectly.

patch is attached.
also please add the manpage for mdassemble (also attached)

Regards,
Luca

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \

--liOOAslEiF7prFVr
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="mdadm-1.11.0-auto-stacked.patch.bz2"
Content-Transfer-Encoding: base64

QlpoOTFBWSZTWY5L4EIAAKXfgEIwSX///V8nzsC////iQAJcAqgBKSNQNANAAABoAGTQGgAO
aMmJgAmIwI0wIMRgmTAIw5oyYmACYjAjTAgxGCZMAjBJCITaQDTSYiND0QaA2poDQaaZNMIM
wMKouBmZxMy6T5cIFLk5dTnhERIb8Tlw5iZAw1T7+fKTrsqkaUF3ytbarjEv438R1dpsDnLz
7FGGocnpOYlX6LVXYeYzuOiR2WboKyO/x61MKgqAaqOXnZn1ssdeKBwYpD2RYCqB+3vKmK6W
xHNm2eHVX4/3+7t6WZJakaBgTDDiYyqos0g5j0ZyjVl3v2M0awuIDaGQ1ncHSZ59HRuKjkvX
iSoLz3hQCDI4coMHvBw2gxAaQq4DkmIPLVDzkN0lYUCuuamWjVChywaAb3J1aMQuA/OTG4JG
PBwGCsPg8EAP8nYOu6CPpQeBpkaUrt2WxBCCS1IVFUKGfziml7Q90xbz4Jgmt5UKXcdB0DBa
dhHGiRHRwwMAeRJSzMIw8tO4ynE8pLWLPqNo3Oda5imQ0ioidlA7eJGMWNfEgUwsSxD25hur
XsKg7/udbqtGU3DBtRYwXpTAMedfQkHEGEh2IDu0hfxq5FwxtF1rTtMwjODtuwygbmDitfKX
Ksz5BT0E9WQUuXjcPyFAfHqjchuO4csMDLmCYPbsdgwHQtByXOYDaLwccv79NDPpcyQhx8qJ
SxJ5SyS0SwGoE6g2rrJri7FiIVgyuM8BeMgccpKkCR4IoFhITGCmjDWyzaPDfIuVqAvpqhGK
9f8XckU4UJCOS+BC

--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="mdadm-1.11.0-mdassemble-man.patch"

--- mdadm-1.11.0/mdassemble.8.mdassembleman	2005-05-16 21:41:08.000000000 +0200
+++ mdadm-1.11.0/mdassemble.8	2005-05-16 21:01:19.000000000 +0200
@@ -0,0 +1,59 @@
+.\" -*- nroff -*-
+.TH MDASSEMBLE 8 "" v1.11.0
+.SH NAME
+mdassemble \- assemble MD devices
+.I aka
+Linux Software Raid.
+
+.SH SYNOPSIS
+
+.BI mdassemble
+
+.SH DESCRIPTION 
+.B mdassemble
+is a tiny program that can be used to assemble MD devices inside an
+initial ramdisk (initrd) or initramfs, it is meant to replace the in-kernel
+automatic raid detection and activation.
+It can be built statically and linked against lightweight libc alternatives, like
+.B dietlibc,
+.B klibc
+or
+.B uClibc.
+
+.SH USAGE
+Invoking
+.B mdassemble
+has the same effect as invoking
+.B mdadm --assemble --scan.
+
+.SH OPTIONS
+
+There are no options to
+.B mdassemble.
+
+.SH FILES
+
+.SS /etc/mdadm.conf
+
+The config file lists which devices may be scanned to see if
+they contain MD super block, and gives identifying information
+(e.g. UUID) about known MD arrays.  See
+.BR mdadm.conf (5)
+for more details.
+
+.B mdassemble
+supports all configuration parameters defined in
+.B mdadm.conf
+with the exception of
+.B auto=
+which is supported only if mdadm was built with the 
+.B -DMDASSEMBLE_AUTO
+define.
+
+.SH SEE ALSO
+.PP
+.BR mdadm (8),
+.BR mdadm.conf (5),
+.BR md (4).
+.PP
+.BR diet (1).
--- mdadm-1.11.0/Makefile.mdassembleman	2005-04-11 02:12:32.000000000 +0200
+++ mdadm-1.11.0/Makefile	2005-05-16 21:40:56.000000000 +0200
@@ -67,7 +67,7 @@
 ASSEMBLE_FLAGS = -DMDASSEMBLE_AUTO
 endif
 
-all : mdadm mdadm.man md.man mdadm.conf.man
+all : mdadm mdadm.man md.man mdadm.conf.man mdassemble.man
 
 everything: all mdadm.static mdadm.tcc mdadm.uclibc
 
@@ -113,6 +113,9 @@
 mdadm.conf.man : mdadm.conf.5
 	nroff -man mdadm.conf.5 > mdadm.conf.man
 
+mdassemble.man : mdassemble.8
+	nroff -man mdassemble.8 > mdassemble.man
+
 $(OBJS) : mdadm.h
 
 install : mdadm mdadm.8 md.4 mdadm.conf.5

--liOOAslEiF7prFVr--
