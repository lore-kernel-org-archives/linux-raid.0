From: "Nicolas" <nm-ml@fingerprint.fr>
Subject: RE: System keep booting in degradedmode
Date: Mon, 25 Nov 2002 12:11:51 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <NFEBKDECMMGIAKCMGJGDMEPKDNAA.nm-ml@fingerprint.fr>
References: <Pine.LNX.4.33.0211251151200.15189-100000@nooks.wimpunk.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.33.0211251151200.15189-100000@nooks.wimpunk.com>
To: Wim Vinckier <wim-raid@tisnix.be>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Well, you're right... I did forget to change my partition type to FD...
Seems quite obvious now I know it...
Thanks a lot



-----Message d'origine-----
De : linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org]De la part de Wim Vinckier
Envoye : lundi 25 novembre 2002 11:52
A : Nicolas
Cc : linux-raid@vger.kernel.org
Objet : Re: System keep booting in degradedmode


I'm not sure but maybe it's just a partiontable issue.  Did you change the
partitiontable?



On Mon, 25 Nov 2002, Nicolas wrote:

> Hey list
>
> I want to get RAID1 running on a system currently running with no RAID.
> I followed the RAID howto
> I added one more disk and created a raidtab file with my currently running
> disk as failed-disk. I made my raid device on my new disk, gave him a
> filesystem, dumped my currently running disk on it, modified lilo.conf,
ran
> lilo, and rebooted on the raid disk. It worked great. According to
> /proc/mdstat, My raid disk was OK, in degraded mode. I changed my
> failed-disk into a raid-disk in the raidtab file, and raidhotadd(ed) my
old
> disk in the array. Again, it worked fine, and after reconstruction, the
raid
> array was no longer in degraded mode, and working fine (still according to
> /proc/mdstat).
> My problem is, each time I reboot, the raid is in degraded mode again, as
if
> I had never modified the raidtab. If I raidhotadd my old disk, it will be
OK
> again, until the next reboot, and so on.
> Does anybody know what's wrong?
>
> Thanks
>
> Nicolas
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

------------------------------------------------------------------------
Wim VINCKIER
Wasstraat 38                                          Wim-Raid@tisnix.be
B-9000  Gent                                               ICQ 100545109
------------------------------------------------------------------------
'Windows 98 or better required' said the box... so I installed linux

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

