From: Mathias Mueller <raidfail@gmx.de>
Subject: Re: broken raid level 5 array caused by user error
Date: Mon, 09 Nov 2015 16:41:08 +0100
Message-ID: <ed5f0f3cde3f017eae97bab65c792983@pingofdeath.de>
References: <15194c2e14b9a7c3431853dea9dc8b5e@pingofdeath.de>
 <alpine.DEB.2.02.1511091254290.24520@uplift.swm.pp.se>
 <5640A4B1.4050207@turmel.org>
 <07de4cd96f39ecb6154794d072ca12e7@pingofdeath.de>
 <5640B8AD.3030800@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5640B8AD.3030800@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> I trimmed the rest because a valid signature was at the very beginning
> of the device.  So you had either v0.90 or v1.0 metadata.  I would bet
> it's v0.90.  I would also bet that the chunk size is 64k.
> 
> I suggest you try that first:
> 
> mdadm --create --assume-clean --level=5 --raid-devices=4 --chunk=64 \
>   --metadata=0.90 /dev/md1 /dev/sd{d,c,b,e}1
> 
> Do *not* mount it yet!
> 
> Do a non-destructive fsck to see if my guess was accurate:
> 
> fsck -n /dev/md1
> 
> Generally, if this has many errors, you would stop the array, and try
> the other order combinations (but always with sdd1 first) in turn.
> 
> However, you don't say, and we can't tell from the new metadata, how
> far into the reshape mdadm had gotten.  If very far, there will be
> many errors no matter what order you try, and your array is toast.
> 
> But a result with few fsck errors is almost certainly success,
> and you can mount your array.
> 
> BTW, if you recall where you found the suggestion to re-create your
> array, please go back and report there how crazy that is, and point
> them at this mailing list.
> 
> Phil


Hi Phil,

thanks for your reply and sorry for my mistakes, I'm new with the 
mailinglist.

I tried your suggestion but it did not work, fsck could not find a 
superblock. I'm very sure, that I used the metadata v1.2 (and also kind 
of sure that I used a chunk size of 512k). Sadly I tried to mount the 
array yesterday when I was trying the different device orders.

Is it helpful to post the hexdump of the other devices as well?

Thanks for your Help!


