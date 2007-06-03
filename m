From: Karsten Desler <kdesler@soohrt.org>
Subject: Re: 5 HDD RAID5 not starting after controller failure
Date: Sun, 3 Jun 2007 13:02:54 +0200
Message-ID: <20070603110254.GJ22122@soohrt.org>
References: <20070603094714.GI22122@soohrt.org> <18018.39101.44096.914966@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18018.39101.44096.914966@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

* Neil Brown wrote:
> So I would just
>   mdadm -ARf /dev/md6 /dev/sd[abcd]8 /dev/sde1
> and let mdadm pick the best drives.  Then add the remaining one in as
> a hot-add.

Thank you very much. It chose to exclude /dev/sdc8 which I re-added and
the array is rebuilding now.

Best Regards,
 Karsten Desler
