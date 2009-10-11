From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: md: could not bd_claim hde1
Date: Sun, 11 Oct 2009 12:35:52 +0400
Message-ID: <4AD198E8.2070707@msgid.tls.msk.ru>
References: <Pine.LNX.4.61.0910102326250.22812@soloth.lewis.org> <738ae0e0ab81ff72cc23b359d0011d1c.squirrel@neil.brown.name> <Pine.LNX.4.61.0910110051270.22812@soloth.lewis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0910110051270.22812@soloth.lewis.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Lewis <jlewis@lewis.org>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jon Lewis wrote:
> On Sun, 11 Oct 2009, NeilBrown wrote:
> 
>> Either hde1 or hde is definitely in use by something else.
>> Try:
>> cat /proc/mounts
> 
> # cat /proc/mounts
> rootfs / rootfs rw 0 0
> /dev/root / ext3 rw 0 0

That's what you get for using rh and their nash ;)

What IS /dev/root?  How does your root device
is specified in initramfs -- by uuid/label?

I bet it is running off /dev/hde1, not /dev/md0.

But this does not explain why it can't add
/dev/hde3 to md1.

Speaking of "LVM is not in use" -- I understand
it like "you didn't set it up", but are you sure
it does not stay on the way?  Like, the dm modules -
how about rmmod'ing them?

In any way, if nothing obvious comes on, your best
bet is to booting into single-user mode, stopping
all "extra" processes, umounting everyhing that's
possible, and trying mdadm from there.

Or from initramfs itself, if that has any tools in
there.

/mjt
