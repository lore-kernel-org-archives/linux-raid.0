From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2 Hard Drives & RAID
Date: Sat, 9 Sep 2006 15:48:24 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0609091548080.14845@p34.internal.lan>
References: <ednknc$gk$4@sea.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ednknc$gk$4@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: "Sandra L. McGrew" <momo_1@alltel.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Wed, 6 Sep 2006, Sandra L. McGrew wrote:

> I have two hard drives installed in this DELL GX110 Optiplex computer. I
> believe that they are configured in RAID5, but am not certain. Is there a
> graphical method of determining how many drives are being used and how they
> are configured???
> I'm using Debian, 'Sarge'...
>
> The computer is incrediby fast... I'm thinking that could be because it's a
> DELL or because the drives are mirrored...
>             I would apppreciate any help that you can give me...
>                   Most sincerley,
>                                Dan (nurse1@longviewcomm[removethis].net)
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

RAID5 requires 3 drives or more.

To check your disks type: fdisk -l as root.

Justin.

