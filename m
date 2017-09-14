From: Nix <nix@esperi.org.uk>
Subject: Re: Encrypted software RAID1 with Debian Stretch
Date: Thu, 14 Sep 2017 12:08:25 +0100
Message-ID: <87r2v9sfkm.fsf@esperi.org.uk>
References: <28c61e8c14f44ec6727b8f3fb3c80c98@riseup.net>
        <59A92C91.7010508@youngman.org.uk> <87y3pjv6jw.fsf@esperi.org.uk>
        <3a85ea27-602a-3f5b-3537-d4159a56c2ed@thelounge.net>
        <87377qvh7t.fsf@esperi.org.uk> <59B95891.9040809@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59B95891.9040809@youngman.org.uk> (Wols Lists's message of "Wed,
        13 Sep 2017 17:10:57 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 13 Sep 2017, Wols Lists spake thusly:

> On 13/09/17 14:52, Nix wrote:
>> Nonetheless, fs/ext2 is almost unmaintained these days, and bugs are
>> slowly creeping back in. fs/ext4 can take up its duties perfectly well
>> these days, reading and writing both ext4-sans-journal and traditional
>> ext2 filesystems perfectly well.
>
> ext2 as filesystem code in linux no longer exists. Likewise, I believe,
> ext3. Both have been dropped and deleted. The only supported/maintained
> ext driver now is ext4, which has backwards compatibility with 3 and 2.

Oh! I failed to notice when that happened :)

... er, I just checked upstream master and ext2 still exists. ext3 was
removed in v4.3.

>> One person having no problems with a filesystem as new as btrfs does not
>> mean the filesystem is reliable enough to use for backup. The
>> reliability bar for such filesystems is far higher than that for fses in
>> daily use! ("The required-feature bar is often also much lower. All they
>> have to do is store stuff that rarely changes and not lose it!")
>
> "The required-feature bar is often also much lower. All they
> have to do is store stuff that rarely changes and not lose it!"
>
> Actually, btrfs is very good at that! PROVIDED you don't use the fancy
> new experimental features (like raid :-) in btrfs, it works very well.
> It's a nice, stable, very decent filesystem.

I lost two btrfses via "it had lots of space, now it's saying -ENOSPC,
and now I can't mount it any more" bugs. Both were rapidly fixed, but
that sort of thing dents your confidence :) mind you that was a couple
of years back and these things do improve with time.

> The rule is simple - don't abuse your tools, and btrfs - USED WITHIN ITS
> LIMITATIONS - is a powerful and reliable file system.

Yeah, but... if you avoid the advanced features, why use btrfs? In
particular, why use it *for a backup medium* (where such features are
distinctly less useful than on a non-backup medium)?

-- 
NULL && (void)
