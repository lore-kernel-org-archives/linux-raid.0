From: Chris <email.bug@arcor.de>
Subject: What are mdadm maintainers to do? (was: desktop disk's error recovery timeouts)
Date: Mon, 16 Feb 2015 17:48:50 +0000 (UTC)
Message-ID: <loom.20150216T183419-387@post.gmane.org>
References: <loom.20150214T222329-324@post.gmane.org> <20150216142845.0d50207c@notabene.brown> <loom.20150216T124230-883@post.gmane.org> <54E1EDEA.1030503@turmel.org> <loom.20150216T165111-551@post.gmane.org> <54E226B5.1080500@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Thank you for the additional information, it calls for action.


OK, calling for a solution to stop desktop drives from causing data loss and
affecting the mdadm reputation:


I gather that mdadm could ship with one additional udev rule that calls a
script to check/set scterc, or falls back to increasing the system timout.

Phil, you mentioned having posted such a script, could you prepare it for
addition to the mdadm package?


Would maintainers be ok with adding such a udev rule and script to the package?


Kind Regards,
Chris




