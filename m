From: Bradley Baetz <bradley.baetz@optusnet.com.au>
Subject: Re: [PATCH] Bogus SparesMissing alert from mdadm
Date: Mon, 28 Jun 2004 19:51:01 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040628095101.GA6937@bradley.optusnet.com.au>
References: <20040627140119.GA18831@bradley.optusnet.com.au>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="CUfgB8w4ZwR/yMy5"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20040627140119.GA18831@bradley.optusnet.com.au>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--CUfgB8w4ZwR/yMy5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 28, 2004 at 12:01:19AM +1000, Bradley Baetz wrote:
> If theres no spares= option in mdadm.conf, then spare_disks gets set to
> UnSet, and --monitor sends a SparesMissing event because there are less
> than 65534 spare disks available.
> 
> Attached patch defaults this to 0, which matches both the --detail --brief
> output, and the docs from ANNOUNCE-1.4.0.

OK, so it helps if I actually attach the patch...

Bradley

--CUfgB8w4ZwR/yMy5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="mdadm.patch"

--- config.c.orig       Sun Jun 27 23:55:57 2004
+++ config.c    Sun Jun 27 23:58:21 2004
@@ -270,7 +270,7 @@
        mis.super_minor = UnSet;
        mis.level = UnSet;
        mis.raid_disks = UnSet;
-       mis.spare_disks = UnSet;
+       mis.spare_disks = 0;
        mis.devices = NULL;
        mis.devname = NULL;
        mis.spare_group = NULL;

--CUfgB8w4ZwR/yMy5--
