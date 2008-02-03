From: Moshe Yudkowsky <moshe@pobox.com>
Subject: Re: RAID needs more to survive a power hit, different /boot layout
 for example (was Re: draft howto on making raids for surviving a disk crash)
Date: Sun, 03 Feb 2008 14:54:47 -0600
Message-ID: <47A62A17.70101@pobox.com>
References: <47A612BE.5050707@pobox.com> <47A623EE.4050305@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47A623EE.4050305@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Tokarev wrote:

> Speaking of repairs.  As I already mentioned, I always use small
> (256M..1G) raid1 array for my root partition, including /boot,
> /bin, /etc, /sbin, /lib and so on (/usr, /home, /var are on
> their own filesystems).  And I had the following scenarios
> happened already:

But that's *exactly* what I have -- well, 5GB -- and which failed. I've 
modified /etc/fstab system to use data=journal (even on root, which I 
thought wasn't supposed to work without a grub option!) and I can 
power-cycle the system and bring it up reliably afterwards.

So I'm a little suspicious of this theory that /etc and others can be on 
the same partition as /boot in a non-ext3 file system.

-- 
Moshe Yudkowsky * moshe@pobox.com * www.pobox.com/~moshe
  "Thanks to radio, TV, and the press we can now develop absurd
   misconceptions about peoples and governments we once hardly knew
   existed."	-- Charles Fair, _From the Jaws of Victory_
