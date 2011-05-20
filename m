From: Paul van der Vlis <paul@vandervlis.nl>
Subject: Software raid, booting and bios
Date: Fri, 20 May 2011 08:54:04 +0200
Message-ID: <ir536c$9jv$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I use software raid (mdadm). The main problem for me is that when the
drive with the MBR fails, it can become a problem to boot.

When the bios would use another drive to boot when the first drive
failes, this problem would be gone. But I don't know rackservers who do
that. Do you?

Or is there maybe some kind of fake-raid card what uses mdadm to solve
this problem?

Another way would be to use e.g. an USB device to boot to solve this
problem. Any experiences with that?

(hmm, I realize that netboot is an option too).

With regards,
Paul van der Vlis.


-- 
http://www.vandervlis.nl

