From: Roberto Spadim <roberto@spadim.com.br>
Subject: nbd / hot plug
Date: Sun, 30 Jan 2011 18:27:40 -0200
Message-ID: <AANLkTi=NEgB_fJPfsK+36wUWZ_Kc_W23v15nT1Qz9iTP@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

hi guys, i was thinking about nbd problems with server disconnection /
client disconnection
it's not like a SATA disk hot plug?
for example unplug the disk (SATA)  = unplug the network card
could md raid work with it?
i tried but i should run
mdadm fail / remove / add
to get nbd back in array, it's right?

-- 
Roberto Spadim
Spadim Technology / SPAEmpresarial
