From: Roberto Spadim <roberto@spadim.com.br>
Subject: RFC swap over raid1
Date: Thu, 1 Aug 2013 19:11:54 -0300
Message-ID: <CAH3kUhFoNKgHErujKuCLMvx_qbDa2dwhW+sMD=7W9W0hHTWB-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

hi guys, should i use raid1 with swap partitions? why?

example:
swapon /dev/sda1
mdadm --create /dev/md-swap --level=1 --raid-devices=2 /dev/sda /dev/sdb
mkswap /dev/md-swap
swapon /dev/md-swap

what's the advantages and disvantages?
should i use raid0, linear, raid1, raid10, raid5 or raid6?

or just two swap partitions and run this way:
swapon /dev/sda
swapon /dev/sdb
?

thanks

-- 
Roberto Spadim
SPAEmpresarial
