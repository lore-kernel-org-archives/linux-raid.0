From: =?ISO-8859-2?Q?Giedrius_Statkevi=E8ius?=
	<giedrius.statkevicius@gmail.com>
Subject: 30c2a1faaeb3db94fc92f79553cc72634aa3b218 broke cryptsetup on my
 machine
Date: Wed, 7 Oct 2015 22:27:27 +0300 (EEST)
Message-ID: <alpine.LNX.2.20.1510072226180.1350@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: geliangtang@163.com, snitzer@redhat.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Hello,
I have a LUKS on LVM setup: /boot is unencrypted and everything is "hidden" in
/dev/sda2. After booting on linux-next and just after entering my password
cryptsetup segfaults and a stack trace is printed from the kernel. Since writing
down all those numbers is hard I've made a picture where it is shown:
https://i.imgur.com/6PHNUdv.jpg

I figured it had something to do with changes to memory management and thus find
out that commit 30c2a1faaeb3db94fc92f79553cc72634aa3b218 broke my system.
Reverting it there is no such error anymore and system boots fine past that
point. 

Could someone look into this? Thanks, Giedrius
