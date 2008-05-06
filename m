From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm raid1 stops to work after kernel panic
Date: Tue, 6 May 2008 12:50:01 +1000
Message-ID: <18463.51033.969459.795526@notabene.brown>
References: <26c008d70805042347g1afaa67em5a7af935bed434ca@mail.gmail.com>
	<56088.192.168.1.70.1209979931.squirrel@neil.brown.name>
	<26c008d70805050256q65972fa7jb86c6d5254828fc1@mail.gmail.com>
	<54900.192.168.1.70.1209987714.squirrel@neil.brown.name>
	<26c008d70805050509q40acc59cg94d22d0f9ad3b8b6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Federico on Monday May 5
Sender: linux-raid-owner@vger.kernel.org
To: Federico <undicizeri@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday May 5, undicizeri@gmail.com wrote:
> >  What happens if you:
> >   mdadm -S /dev/md2
> >   mdadm -A /dev/md2 /dev/sda1 /dev/sdc1
> 
> root@persifae:~#mdadm -S /dev/md2
> mdadm: stopped /dev/md2
> root@persifae:~#mdadm -A /dev/md2 /dev/sda1 /dev/sdc1
> mdadm: failed to add /dev/sdc1 to /dev/md2: Invalid argument
> mdadm: /dev/md2 assembled from 0 drives - not enough to start the array.

Ahhh... They have a different "preferred minor".  Presumably when you
tried to boot with the wrong grub parameters it tried to assemble the
array as /dev/md0 instead of /dev/md2.

You can fix with:

  mdadm -A /dev/md2 /dev/sdc1
  mdadm /dev/md2 -a /dev/sda1

NeilBrown
