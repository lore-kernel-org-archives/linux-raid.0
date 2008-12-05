From: Redeeman <redeeman@metanurb.dk>
Subject: detection/correction of corruption with raid6
Date: Fri, 05 Dec 2008 22:00:33 +0100
Message-ID: <1228510833.16555.76.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello.

I was looking at the PDFs linked to from the wiki, and found this:
http://kernel.org/pub/linux/kernel/people/hpa/raid6.pdf

More specifically, section 4, starting on page 8.

Am I understanding this correctly, in that with raid6, linux is capable
of detecting if the content on 1 disk is corrupted, and reconstruct it
from the remaining disks?


mvh.
Kasper Sandberg

