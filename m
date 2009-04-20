From: Farkas Levente <lfarkas@lfarkas.org>
Subject: what superblock to use
Date: Mon, 20 Apr 2009 15:39:46 +0200
Message-ID: <49EC7B22.8070805@lfarkas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hi,
what's the current recommended superblock to use for a newly created
raid5-6 array with 6 pieces of 1tb disk? by default mdamd use 0.90. is
it worth to change it to any 1.x format?
anyway is there any advantage of a raid6 over raid5+1spare disk? afaik
raid5 will be faster and use less cpu and both case 2 disk can failed.
thanks in advance.

-- 
  Levente                               "Si vis pacem para bellum!"
