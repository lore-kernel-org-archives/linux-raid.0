From: "Cuenta de la lista de linux" <user_linux@citma.cu>
Subject: Promise SX6000 RAID problems
Date: Thu, 30 Jan 2003 16:31:13 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030130213113.M55931@webmail.citma.cu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid lists <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Hi,

I have installed Red Hat 7.2 (kernel 2.4.7-10) in a dual PII server.I want to
install a Promise SX600 card on it.I have  made a 5 drive RAID 5

I have let the card initialize by it's BIOs and i have choose OS=other in the
card setup, compiled the kernel with i20 support on it(as module), but when i
tried to format de array with fdisk /dev/i2o/hda i got a unable to open messages.

I have the system in another hard drive in /dev/hda.

Is ther any problems with i20 and Red Hat 7.2 kernel 2.4.7-10?

Should I upgrade the kernel ? but Which  kernel version is the best for
Promise SX6000? 

Has any one got this card to work with and  distro/kernel version???

is this card able to use the i20 kernel module?


Thanks for any help 

David



