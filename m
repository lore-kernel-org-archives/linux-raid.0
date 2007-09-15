From: "J. David Beutel" <jdb@getsu.com>
Subject: Re: reducing the number of disks a RAID1 expects
Date: Sat, 15 Sep 2007 11:13:46 -1000
Message-ID: <46EC4B0A.9040906@getsu.com>
References: <46E49991.9000000@getsu.com>	<46E4AC1A.3010509@sauce.co.nz>	<46E4F2EA.3020901@getsu.com>	<20070910095557.GA22549@teal.hq.k1024.org> <18150.41048.240735.467994@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18150.41048.240735.467994@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Iustin Pop <iusty@k1024.org>, Richard Scobie <richard@sauce.co.nz>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:
> 2.6.12 does support reducing the number of drives in a raid1, but it
>     will only remove drives from the end of the list. e.g. if the
>     state was
>
>       58604992 blocks [3/2] [UU_]
>
> then it would work.  But as it is
>
>       58604992 blocks [3/2] [_UU]
>
> it won't.  You could fail the last drive (hdc8) and then add it back
> in again.  This would move it to the first slot, but it would cause a
> full resync which is a bit of a waste.
>   

Thanks for your help!  That's the route I took.  It worked ([2/2] 
[UU]).  The only hiccup was that when I rebooted, hdd2 was back in the 
first slot by itself ([3/1] [U__]).  I guess there was some contention 
in discovery.  But all I had to do was physically remove hdd and the 
remaining two were back to [2/2] [UU].

> Since commit 6ea9c07c6c6d1c14d9757dd8470dc4c85bbe9f28 (about
> 2.6.13-rc4) raid1 will repack the devices to the start of the
> list when trying to change the number of devices.
>   

I couldn't find a newer kernel RPM for FC3, and I was nervous about 
building a new kernel myself and screwing up my system, so I went the 
slot rotate route instead.  It only took about 20 minutes to resync (a 
lot faster than trying to build a new kernel).

My main concern was that it would discover an unreadable sector while 
resyncing from the last remaining drive and I would lose the whole 
array.  (That didn't happen, though.)  I looked for some mdadm command 
to check the remaining drive before I failed the last one, to help avoid 
that worst case scenario, but couldn't find any.  Is there some way to 
do that, for future reference?

Cheers,
11011011
