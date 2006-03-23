From: Frido Ferdinand <frido@zolder.org>
Subject: mdadm shutdown question
Date: Thu, 23 Mar 2006 15:42:35 +0100
Message-ID: <20060323144235.GC25807@timor.isp-services.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

This question is mainly about the following error during shutdown on my 
gentoo system:

mdadm: fail to stop array /dev/md1: Device or resource busy

(full raid1, root is on /dev/md1)

After searching bugzilla I found:

http://bugs.gentoo.org/show_bug.cgi?id=119380

However there's no agreement on if / how mdadm should stop the rootfs 
during a shutdown sequence. Can anyone enlight me on a good way to
proceed in this ?

Regards,

		-- Frido Ferdinand
