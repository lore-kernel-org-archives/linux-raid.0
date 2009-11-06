From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Is shrinking raid5 possible?
Date: Fri, 06 Nov 2009 18:32:15 +0000
Message-ID: <4AF46BAF.3020900@anonymous.org.uk>
References: <44960C45.9050407@anu.edu.au> <17558.10906.59066.196870@cse.unsw.edu.au> <449B3A80.4070602@tmr.com> <17563.17224.85968.572754@cse.unsw.edu.au> <bb145bd20606231116g7808e467w29a9bf273ba0df52@mail.gmail.com> <17567.36792.303403.35943@cse.unsw.edu.au> <bb145bd20606260433w2bafccfdu3448732f5b5c1c5f@mail.gmail.com> <4564B5C3.9050501@idgmail.se> <20091106131740.GA30506@Toms.NET>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091106131740.GA30506@Toms.NET>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Arthur Oehser <tom@toms.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/11/2009 13:17, Thomas Arthur Oehser wrote:
[...]
>  - resize2fs /dev/md3 <smaller>
>  - mdadm -G -z <smaller> /dev/md3
>  - fdisk /dev/sd[a-c]3 <smaller>
> 
> It _almost_ works fine... but... the mdadm -G keeps the (0.90) superblock
> at the _end_ of the _device_ ... which hasn't been resized yet ...
> 
> How do I put the superblock back after fdisk, or make -G move or recreate?

Are you sure it hasn't already put a copy of the superblock in the right 
place, within the <smaller> size, as well as leaving a copy at the end 
of the original larger partition? That's what I would do if I was the 
author, so the partition can still be recognised as a md one before the 
partition is resized; you wouldn't want the parition to become 
unrecognisable or unusable.

Cheers,

John.
