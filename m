From: Joachim Wagner <jwagner@computing.dcu.ie>
Subject: md manpage of mdadm 2.5.6
Date: Thu, 9 Nov 2006 15:04:19 +0000
Message-ID: <200611091504.19745.jwagner@computing.dcu.ie>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

In man -l mdadm-2.5.6/md.4 I read

"Firstly, after an unclear shutdown, the resync process will consult the 
bitmap and only resync those blocks that correspond to bits in the bitmap 
that are set. This can dramatically increase resync time."

IMHO, "increase" should be changed to "decrease" or "time" to "speed". 

Regards,
Joachim
