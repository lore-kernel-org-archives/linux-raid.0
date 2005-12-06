From: Michael Stumpf <mjstumpf@pobox.com>
Subject: random lockups, raid problems SOLVED (plus a question)
Date: Tue, 06 Dec 2005 14:19:37 -0600
Message-ID: <4395F259.1080801@pobox.com>
Reply-To: mjstumpf@pobox.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sure it's a FAQ.  It's probably even documented.  And, I know it, but it 
still surprised me.  Such is life:

2/3 sticks of perfectly good ECC ram in an old server class p3 board 
apparently have gone bad.  Result?  Random lockups/reboots with nothing 
in the system logs to even lend a clue.

Memtest86 showed one problem immediately, and after some time, exposed 
some more.  Remove the bad memory and it works fine.

Is there some daemon that can more actively monitor memory function?  I 
must have had this problem for months, but with sputtering hard drives 
that were slowly dying and causing very similar problems, this diagnosis 
got muddled.

Regards-
Michael Stumpf




