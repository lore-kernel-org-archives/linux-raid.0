From: Alfred Isele <Alfred.Isele@fujitsu-siemens.com>
Subject: raid1 and swap
Date: Mon, 07 Apr 2003 10:50:58 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3.0.6.32.20030407105058.00b7ca30@athen>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello!
I have a question concerning the use of raid1 (md) 
together with swap. I use this /etc/fstab entry:

/dev/md1   none  swap  pri=42  0 0

Somebody told me swap could be damaged if 
one of the mirrored devices used for swap fails and 
a spare disk is resynched for it because the resync would 
be done using the buffer cache whereas the swapping would
be done by direct disk access. 
Do you know if such a problem exists?
Thank you
Alfred

