From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: RAID needs more to survive a power hit, different /boot layout
 for example (was Re: draft howto on making raids for surviving a disk crash)
Date: Mon, 04 Feb 2008 00:04:15 +0300
Message-ID: <47A62C4F.3080409@msgid.tls.msk.ru>
References: <47A612BE.5050707@pobox.com> <47A623EE.4050305@msgid.tls.msk.ru> <47A62A17.70101@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47A62A17.70101@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: Moshe Yudkowsky <moshe@pobox.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Moshe Yudkowsky wrote:
> Michael Tokarev wrote:
> 
>> Speaking of repairs.  As I already mentioned, I always use small
>> (256M..1G) raid1 array for my root partition, including /boot,
>> /bin, /etc, /sbin, /lib and so on (/usr, /home, /var are on
>> their own filesystems).  And I had the following scenarios
>> happened already:
> 
> But that's *exactly* what I have -- well, 5GB -- and which failed. I've
> modified /etc/fstab system to use data=journal (even on root, which I
> thought wasn't supposed to work without a grub option!) and I can
> power-cycle the system and bring it up reliably afterwards.
> 
> So I'm a little suspicious of this theory that /etc and others can be on
> the same partition as /boot in a non-ext3 file system.

If even your separate /boot failed (which should NEVER fail), what to
say about the rest?

I mean, if you'll save your /boot, what help it will be for you, if
your root fs is damaged?

That's why I said /boot is mostly irrelevant.

Well.  You can have some recovery stuff in your initrd/initramfs - that's
for sure (and for that to work, you can make your /boot more reliable by
creating a separate filesystem for it).  But if to go this route, it's
better to boot off some recovery CD instead of trying recovery from very
limited toolset available in your initramfs.

/mjt
