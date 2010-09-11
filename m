From: Neil Brown <neilb@suse.de>
Subject: Re: How to initialize "composite" RAID
Date: Sat, 11 Sep 2010 15:09:23 +1000
Message-ID: <20100911150923.41043519@notabene>
References: <AANLkTim9TnyTGMWnRr65SrmJDrLN=Maua_QnVLLDerwS@mail.gmail.com>
	<20100910222814.CB50615242D@gemini.denx.de>
	<20100911083748.14843721@notabene>
	<AANLkTi=kKKYWY9rLG57i-kqV02Lnf2QPhe5cqaBKEVyW@mail.gmail.com>
	<20100911090709.580f3539@notabene>
	<AANLkTi=rA-z6qEO6os+sYQYUh=pJd4vabtaaUpQ5JevN@mail.gmail.com>
	<20100911102319.2435d878@notabene>
	<AANLkTi=Ze-TPiWJNzoxma9Q3h6nHqsNAS2Osu0n+VUP=@mail.gmail.com>
	<20100911144226.59ebc03d@notabene>
	<AANLkTin7T8rsF=XhWYTZyEwUkb5BUzK6dswVoTB-Sbbs@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTin7T8rsF=XhWYTZyEwUkb5BUzK6dswVoTB-Sbbs@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Hartman <mike@hartmanipulation.com>
Cc: Wolfgang Denk <wd@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 11 Sep 2010 00:58:21 -0400
Mike Hartman <mike@hartmanipulation.com> wrote:

> > If you add a bitmap (mdadm --grow /dev/md0 --bitmap=internal) after the
> > current resync finished, then any subsequent resync due to an unclean
> > shutdown will be much faster.
> 
> I read somewhere (I think in the wiki) that an intent bitmap only
> works properly on ext2 and ext3 and can cause trouble on other file
> systems. Can I use one on ext4 (what I'm using)? I'm hoping/assuming
> what I read just predates the common use of ext4.

That is completely wrong.  An intent bitmap works properly no matter what
filesystem is on top.
It does impose a small performance penalty for writes which is very
work-load-dependant, and it is not impossible that different filesystems
would suffer more or less from this, but I doubt you would notice.

If you can find it again let me know and I'll try to get it fixed.

> 
> Will I need to remove the bitmap before adding another disk and
> growing the array to use it? If I don't, will it speed up that
> operation any?

You, you will need to remove the bitmap before growing the array.  I really
should fix that but it doesn't seem to rise to the top of my to-do list...

And no, a bitmap would have no effect on a reshape operation even if it were
allowed to be present.

NeilBrown

