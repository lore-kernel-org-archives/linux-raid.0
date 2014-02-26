From: Jakob Unterwurzacher <jakobunt@gmail.com>
Subject: Re: md raid6: slow resync if fs is mounted rw
Date: Wed, 26 Feb 2014 10:40:44 +0100
Message-ID: <CAPv9ZmnXWBPGC585YGOEujGVwmeF+igApJ1K0-=gPFmbFszX3A@mail.gmail.com>
References: <530D1F53.5070703@gmail.com>
	<530D521B.7060509@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <530D521B.7060509@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>, NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Feb 26, 2014 at 3:31 AM, Brad Campbell
<lists2009@fnarfbargle.com> wrote:
> You are probably expeririencing an effect of this :
>
> http://www.thomas-krenn.com/en/wiki/Ext4_Filesystem#Lazy_Initialization

That's it. ext4lazyinit shows up in the blktrace and also flashes up
every now and then in iotop - I did not notice it before.
I reformatted with "mkfs.ext4 -E
lazy_itable_init=0,lazy_journal_init=0" and the issue is gone. Of
course, just waiting a bit with the filesystem mounted rw would have
done it, too.

Thanks a lot Neil and Brad!
Jakob
