From: dean gaudet <dean@arctic.org>
Subject: Re: external bitmaps.. and more
Date: Tue, 11 Dec 2007 23:21:18 -0800 (PST)
Message-ID: <alpine.DEB.0.99999.0712112315060.20869@twinlark.arctic.org>
References: <47581E8A.2010203@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47581E8A.2010203@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 6 Dec 2007, Michael Tokarev wrote:

> I come across a situation where external MD bitmaps
> aren't usable on any "standard" linux distribution
> unless special (non-trivial) actions are taken.
> 
> First is a small buglet in mdadm, or two.
> 
> It's not possible to specify --bitmap= in assemble
> command line - the option seems to be ignored.  But
> it's honored when specified in config file.

i think neil fixed this at some point -- i ran into it / reported 
essentially the same problems here a while ago.


> The thing is that when a external bitmap is being used
> for an array, and that bitmap resides on another filesystem,
> all common distributions fails to start/mount and to
> shutdown/umount arrays/filesystems properly, because
> all starts/stops is done in one script, and all mounts/umounts
> in another, but for bitmaps to work the two should be intermixed
> with each other.

so i've got a debian unstable box which has uptime 402 days (to give you 
an idea how long ago i last tested the reboot sequence).  it has raid1 
root and raid5 /home.  /home has an external bitmap on the root partition.

i have /etc/default/mdadm set with INITRDSTART to start only the root 
raid1 during initrd... this manages to work out later when the external 
bitmap is required.

but it is fragile... and i think it's only possible to get things to work 
with an initrd and the external bitmap on the root fs or by having custom 
initrd and/or rc.d scripts.

-dean
