From: retail.mdadm@gmail.com
Subject: mdadm problem
Date: Wed, 25 May 2011 01:05:55 +0300
Message-ID: <BANLkTi=Jba9U3w6yWanSp6oZ17Kmccffkw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Recently I decided to upgrade my old linux based hdd enclosure:
processor arm9
kernel 2.6.12
I can't update or upgrade linux or it's kernel

So I tried to update HDDs:

When I run this command I realized that I need linear, not raid0
mdadm -Cv /dev/md0 --level=0 -n2 /dev/sda2 /dev/sdb

but when I tried to zero superblocks (I stopped md0 previously) I've
got "Segmentation fault" error..
Later I have connected my drives to PC and zeroed superblocks sucessfully,
but when I connected drives back to enclosure and tried to create
linear I've got "Segmentation fault" error again!

And from now every time I'm trying to do something via mdadm with
these drives I'm getting that "Segmentation fault" error!

I haven't tried dd if=/dev/zero of=/dev/sda2 cause my hard drive have 2Tb!

Here are my questions:
1. Can mdadm damage my hard drive(s)?
2. How to locate and zero superblocks completely? (I know that there
are two versions of superblocks.. but I don't know which one I have)

Thanks
