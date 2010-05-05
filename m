From: Christian Gatzemeier <c.gatzemeier@tu-bs.de>
Subject: detecting segmentation / conflicting changes
Date: Wed, 5 May 2010 11:28:54 +0000 (UTC)
Message-ID: <loom.20100505T131635-899@post.gmane.org>
References: <loom.20100423T152429-20@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Just curious, as we're seing cases where corrupt arrays are assembled.

Do you see something wrong with the idea to check for superblocks claiming each
other as failed? Do you think it is not a right measure to detect whether
segments of an array have been run degraded separately?





