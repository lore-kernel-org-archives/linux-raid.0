From: "G.raud" <graud@gmx.com>
Subject: mdadm manpage: add missing unit for --array-size
Date: Wed, 15 Feb 2017 20:25:18 +0100
Message-ID: <20170215192517.GE28234@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The description of --array-size does not give the default unit (but only
those corresponding to a suffix of M or G).  Please mention that the
default unit is the KiB (and that K is accepted as a suffix).  Since
mdadm -E gives some sizes in sectors it is certainly not evident that
the default unit is the KiB.

Thanks
