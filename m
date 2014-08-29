From: Paul van der Vlis <paul@vandervlis.nl>
Subject: Good hardware for mdadm
Date: Fri, 29 Aug 2014 22:31:49 +0200
Message-ID: <ltqnvm$80o$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I like mdadm and I am using it many years. But in my opinion it has one
disadvantage: when the MBR of the boot-disk is corrupt, the machine will
not boot.

A bios could check this. Wait for some kind of signal from Grub or
Linux, and after a timeout boot from another disk. But I don't know
about a bios with that feature.

A PCIe card could do something like that, but I don't know about such a
PCIe card.

Is there such hardware?
What do you do to avoid this problem?

With regards,
Paul van der Vlis.




-- 
Paul van der Vlis Linux systeembeheer, Groningen
http://www.vandervlis.nl/

