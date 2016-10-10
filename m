From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: Why not just return an error?
Date: Mon, 10 Oct 2016 21:47:04 +0100
Message-ID: <b9e7054f-8d68-c576-41a5-aec60c53aa9b@youngman.org.uk>
References: <57F6DF18.40703@yandex.ru> <20161007112151.GA4405@metamorpher.de>
 <e887908f-ba51-0f88-f891-f60e8bac50bd@turmel.org>
 <57F7CC10.3050607@yandex.ru>
 <94b1a4f4-adec-90b7-e804-2d8d2c94a7af@turmel.org>
 <57F7DF05.8090605@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57F7DF05.8090605@yandex.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Dark Penguin <darkpenguin@yandex.ru>, Phil Turmel <philip@turmel.org>, Andreas Klauer <Andreas.Klauer@metamorpher.de>, Rudy Zijlstra <rudy@grumpydevil.homelinux.org>, keld@keldix.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 07/10/16 18:44, Dark Penguin wrote:
>
> I actually wanted to ask about that. Can you really ddrescue a drive
> with a "hole" in it, re-add it and expect it to work?.. What happens if
> you try to read from that "hole" again? And while I'm talking about
> re-adding, when does it become impossible to "re-add" a drive?..

If you want to do some kernel development work, this is something you 
can do something about :-)

ddrescue creates a log of sectors that failed to copy. I've been 
thinking a bit about this, not least because other people have mentioned it.

Modern disk partitioning tools usually leave a chunk of space. What we 
want is some way of making ddrescue dump a signature on the disk, along 
with a list of all blocks that failed to copy. Then we need to patch the 
low-level disk access code so that it reads this list of "bad blocks" 
and returns a read error if any attempt is made to read one. If a block 
is written, it's removed from the list. In effect, this is a "bad block" 
list, only instead of being at the disk firmware level, it's at the OS's 
disk driver level.

That way, at least you know, if you copy a damaged disk with errors, 
then the filesystem layer will be told that the file is damaged, rather 
than returning duff data with no indication that it is duff.

THIS IS NOT THERE TODAY, but if you want a kernel project, this isn't a 
bad one. This will mean that you can recover a broken raid with no data 
loss, provided you have enough drives to be able to assemble a redundant 
array, and you aren't unlucky enough to have two drives have an error in 
the same place.

Cheers,
Wol
