From: Bradley Baetz <bradley.baetz@optusnet.com.au>
Subject: [PATCH] Bogus SparesMissing alert from mdadm
Date: Mon, 28 Jun 2004 00:01:19 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040627140119.GA18831@bradley.optusnet.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If theres no spares= option in mdadm.conf, then spare_disks gets set to
UnSet, and --monitor sends a SparesMissing event because there are less
than 65534 spare disks available.

Attached patch defaults this to 0, which matches both the --detail --brief
output, and the docs from ANNOUNCE-1.4.0.

Bradley
