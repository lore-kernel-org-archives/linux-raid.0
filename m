From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: Help creating filesystem (xfs) and partitioning
Date: Wed, 24 Jul 2013 23:34:18 -0300
Message-ID: <CAH3kUhF0OmeBf1SHxoNy93Ni0xhOYUt07ws-ZYjqZK-rX+8pvw@mail.gmail.com>
References: <CAH3kUhFqX5fB0=eYbECxrR_52Yv3_v5oodG=6Z-8L_gcTwiC4Q@mail.gmail.com>
	<51EF7AA2.9000604@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51EF7AA2.9000604@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

sorry i was sending as html (i was at android gmail), now as text...

-------
Nice other doubts

What about fdisk align?
Could i use ext3 or ext4 for boot filesystem? I need crash security
(ok a ups is the best solution) xfs could be used too?
Or maybe.. Could i use only two partitions, swap at beginning of
disks, and the raid1 with xfs partition?

If i need a home directory with crypt filesystem, what should i use?
Two partitions one with xfs and other with dmcrypt (for example) and
xfs, or only one partition and a loop mount with crypt and quota limit
for home directory?

Thanks guys
