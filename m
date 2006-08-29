From: "adam radford" <aradford@gmail.com>
Subject: Re: 3ware glitches cause softraid rebuilds
Date: Mon, 28 Aug 2006 17:56:16 -0700
Message-ID: <b1bc6a000608281756s1e76a80eq5f70e654e2e7e3e3@mail.gmail.com>
References: <1926236045.20060829034652@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_162402_15333797.1156812976398"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750719AbWH2A43@vger.kernel.org>
In-Reply-To: <1926236045.20060829034652@2ka.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: Jim Klimov <klimov@2ka.mipt.ru>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

------=_Part_162402_15333797.1156812976398
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Jim,

Can you try the attached (and below) patch for 2.6.17.11?

Also, please make sure you are running the latest firmware.

Thanks,

-Adam

diff -Naur linux-2.6.17.11/drivers/scsi/3w-9xxx.c
linux-2.6.17.12/drivers/scsi/3w-9xxx.c
--- linux-2.6.17.11/drivers/scsi/3w-9xxx.c	2006-08-23 14:16:33.000000000 -0700
+++ linux-2.6.17.12/drivers/scsi/3w-9xxx.c	2006-08-28 17:48:29.000000000 -0700
@@ -943,6 +943,7 @@
 		before = jiffies;
 		while ((response_que_value & TW_9550SX_DRAIN_COMPLETED) !=
TW_9550SX_DRAIN_COMPLETED) {
 			response_que_value = readl(TW_RESPONSE_QUEUE_REG_ADDR_LARGE(tw_dev));
+			msleep(1);
 			if (time_after(jiffies, before + HZ * 30))
 				goto out;
 		}

------=_Part_162402_15333797.1156812976398
Content-Type: text/x-patch; name=3ware_patch.diff; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_erfkfts2
Content-Disposition: attachment; filename="3ware_patch.diff"

ZGlmZiAtTmF1ciBsaW51eC0yLjYuMTcuMTEvZHJpdmVycy9zY3NpLzN3LTl4eHguYyBsaW51eC0y
LjYuMTcuMTIvZHJpdmVycy9zY3NpLzN3LTl4eHguYwotLS0gbGludXgtMi42LjE3LjExL2RyaXZl
cnMvc2NzaS8zdy05eHh4LmMJMjAwNi0wOC0yMyAxNDoxNjozMy4wMDAwMDAwMDAgLTA3MDAKKysr
IGxpbnV4LTIuNi4xNy4xMi9kcml2ZXJzL3Njc2kvM3ctOXh4eC5jCTIwMDYtMDgtMjggMTc6NDg6
MjkuMDAwMDAwMDAwIC0wNzAwCkBAIC05NDMsNiArOTQzLDcgQEAKIAkJYmVmb3JlID0gamlmZmll
czsKIAkJd2hpbGUgKChyZXNwb25zZV9xdWVfdmFsdWUgJiBUV185NTUwU1hfRFJBSU5fQ09NUExF
VEVEKSAhPSBUV185NTUwU1hfRFJBSU5fQ09NUExFVEVEKSB7CiAJCQlyZXNwb25zZV9xdWVfdmFs
dWUgPSByZWFkbChUV19SRVNQT05TRV9RVUVVRV9SRUdfQUREUl9MQVJHRSh0d19kZXYpKTsKKwkJ
CW1zbGVlcCgxKTsKIAkJCWlmICh0aW1lX2FmdGVyKGppZmZpZXMsIGJlZm9yZSArIEhaICogMzAp
KQogCQkJCWdvdG8gb3V0OwogCQl9Cg==
------=_Part_162402_15333797.1156812976398--
