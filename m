From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Planning a bug-fix release for mdadm: mdadm 3.2.6
Date: Sat, 20 Oct 2012 19:28:34 +0400
Message-ID: <5082C322.6020506@msgid.tls.msk.ru>
References: <20121018154807.461ddd29@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121018154807.461ddd29@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 18.10.2012 08:48, NeilBrown wrote:
>  The "mdadm-3.2.x" branch of my git tree (git://neil.brown.name/mdadm)
>  contains what I have so far.  If anyone knows of bugs in current mdadm that
>  really should be fixed for the next release and aren't in that tree, please
>  let me know (or even send me a patch).

There's apparently a small (but annoying when you hit it) bug mentioned in
http://bugs.debian.org/686703 -- when specifying --uuid, --homehost is NOT
ignored as it should be.  I'm looking at it right now, so for now it is JFYI.

Thanks,

/mjt
