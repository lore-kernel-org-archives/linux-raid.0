From: Boyan Alexiev <alexiev@resonance.bg>
Subject: Re: Backup file size when migrating from raid5 to raid6?
Date: Wed, 17 Jul 2013 13:01:15 +0000 (UTC)
Message-ID: <loom.20130717T145156-76@post.gmane.org>
References: <CAH-e9vLTY2eo0p3ud5FaWNe_2f8hej0aitFuu8K0M1RZdObiXQ@mail.gmail.com> <CAH-e9vLiK6=HmDjM=Ub7p_Lxrp_L0x1bkAa2oP=ykajqvtkfDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If You have array with 9 devices and add another one You may at same time
grow array and change raid level. In this case You not need backup file.
Please try this:
mdadm --grow /dev/md0 --raid-devices=10 --level=6 




