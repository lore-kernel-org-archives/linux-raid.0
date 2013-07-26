From: Roberto Spadim <rspadim@gmail.com>
Subject: Re: Help creating filesystem (xfs) and partitioning
Date: Thu, 25 Jul 2013 22:47:24 -0300
Message-ID: <CAH3kUhHtU84KrMoGSKi2hK1o3foBOkOLQ0-z5+Rb9hVsBX6cbg@mail.gmail.com>
References: <CAH3kUhFqX5fB0=eYbECxrR_52Yv3_v5oodG=6Z-8L_gcTwiC4Q@mail.gmail.com>
	<51F19E0F.5000400@tmr.com>
	<CAH3kUhEMtauLoymUL7k8s==4NtvX=CRzOJhhtfL2EdJzYygd+A@mail.gmail.com>
	<51F1B478.4050901@hardwarefreak.com>
	<CAH3kUhHzZ3DoA-mJiQG+27gai1=MZEu6t8JTMtmMvQ7q0ipEoQ@mail.gmail.com>
	<51F1D12F.8030507@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51F1D12F.8030507@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> And truthfully, for a system of this caliber, you don't really gain
> anything by using XFS, certainly not from a performance standpoint.  If
> you were already an XFS user on large systems and it was simply your "go
> to" filesystem, then using it on this system may make sense.  And if you
> don't have a working UPS, you should definitely stay away from XFS.
> Power failure shouldn't cause filesystem corruption, but it may well
> corrupt or zero out files that are open for write but not written.  XFS
> journals metadata, not data.

i'm using xfs because i tested with ext4, xfs and reiserfs (v3) and
xfs was the fastest
i use UPS, but... well you know... some one can remove the power
cable... users sometime make mistakes :) hehe
i didn't tested the btrfs yet, i think it's not mature for production use

well power failure is a problem in any filesystem... what filesystem
you consider is the "best"?

considering that:
i'm running filesystem over md raid1
best = good power failure
files with >40gb (some mysql tables are big)
a big directory structure (root directory with man pages libs, linux
kernel and some packages that i compile (php, mariadb, apache), and
others linux tools, etc...)
a home directory with maybe many temporary files, mysql sometime
create temporary files for query sorting, in this case crud operations
happens very often, create file/put data/read/delete file

well i think it's a test scenario, but experiences/ideas are wellcome

-- 
Roberto Spadim
