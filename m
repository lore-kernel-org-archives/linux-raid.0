From: "Robert E. Singer" <Robert.E.Singer@cox.net>
Subject: linux/raid problem, linux not recognizing bios raid
Date: Sat, 16 Oct 2004 19:52:02 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <000401c4b3f4$47bc9570$6101a8c0@renoir>
References: <S269013AbUJQCk1/20041017024027Z+4684@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <S269013AbUJQCk1/20041017024027Z+4684@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hi -

i dont have tons of linux experience.  my in-depth unix experience was many
years ago.

im building a system containing:
- abit ic7g motherboard
- 2 wd 160gb sata hard drives
- red hat linux workstation version 3

the drives have been physically installed and the bios configured to run the
disks as a raid (either raid0 or raid1). this is verified during the post.

when i try to install linux, the disk partitioning program reports two disks
/dev/sda & /dev/sdb individually with 160gb capacities available for
partitioning, not one.  whether using bios raid0 or raid1, only 1 disk
should be available (with 160 or 320 gb available, depending on the raid
flavor).

whats wrong?

bob singer 

