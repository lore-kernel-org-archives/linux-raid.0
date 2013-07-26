From: Roberto Spadim <rspadim@gmail.com>
Subject: Re: Help creating filesystem (xfs) and partitioning
Date: Thu, 25 Jul 2013 21:36:39 -0300
Message-ID: <CAH3kUhHzZ3DoA-mJiQG+27gai1=MZEu6t8JTMtmMvQ7q0ipEoQ@mail.gmail.com>
References: <CAH3kUhFqX5fB0=eYbECxrR_52Yv3_v5oodG=6Z-8L_gcTwiC4Q@mail.gmail.com>
	<51F19E0F.5000400@tmr.com>
	<CAH3kUhEMtauLoymUL7k8s==4NtvX=CRzOJhhtfL2EdJzYygd+A@mail.gmail.com>
	<51F1B478.4050901@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51F1B478.4050901@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

ok =] in other words no problem about performace loss, just use one
xfs per disk, right?
the second doubt... i was thinking about /boot /home and /, in the
same partition, should i consider other design? a /boot with ext2 or
ext3 and a / with xfs?

i'm considering only one partition with swap and one partition with
raid1+xfs, what you think?
in a crash (power failure) i will have better rescure with only one
partition? or many partitions?
