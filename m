From: Roberto Spadim <roberto@spadim.com.br>
Subject: some read balance function for raid1
Date: Sat, 5 Feb 2011 22:28:13 -0200
Message-ID: <AANLkTinaM6KxLYd_GXnk7gcNDBNf9gk8QBp075yJESrM@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

hi guys, i changed some features at raid1
just time_based don't work yet
near_head, round_robin, stripe work
check at:
http://www.spadim.com.br/raid1/
kernel 2.6.37

could anyone help me with some sysfs per mirror?
for i need to set up 3 variables at raid1.h  [mirror_info]
head_distance_rate
read_sectors_rate
write_sectors_rate

-- 
Roberto Spadim
Spadim Technology / SPAEmpresarial
