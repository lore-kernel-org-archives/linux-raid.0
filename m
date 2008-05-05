From: Federico <undicizeri@gmail.com>
Subject: Re: mdadm raid1 stops to work after kernel panic
Date: Mon, 5 May 2008 14:09:51 +0200
Message-ID: <26c008d70805050509q40acc59cg94d22d0f9ad3b8b6@mail.gmail.com>
References: <26c008d70805042347g1afaa67em5a7af935bed434ca@mail.gmail.com>
	 <56088.192.168.1.70.1209979931.squirrel@neil.brown.name>
	 <26c008d70805050256q65972fa7jb86c6d5254828fc1@mail.gmail.com>
	 <54900.192.168.1.70.1209987714.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54900.192.168.1.70.1209987714.squirrel@neil.brown.name>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>  What happens if you:
>   mdadm -S /dev/md2
>   mdadm -A /dev/md2 /dev/sda1 /dev/sdc1

root@persifae:~#mdadm -S /dev/md2
mdadm: stopped /dev/md2
root@persifae:~#mdadm -A /dev/md2 /dev/sda1 /dev/sdc1
mdadm: failed to add /dev/sdc1 to /dev/md2: Invalid argument
mdadm: /dev/md2 assembled from 0 drives - not enough to start the array.
