From: Frank van Maarseveen <frankvm@frankvm.com>
Subject: mdadm segfault
Date: Sun, 8 Oct 2006 14:14:42 +0200
Message-ID: <20061008121442.GA27570@janus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Maybe it's fixed already but just in case... trying to assemble an array
by UUID without any mdadm.conf segfaulted, e.g.:

	mdadm -A --uuid=d764947c:875b3b25:d10330b1:eec6e325 /dev/md10 -c partitions

-- 
Frank
