From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: [PATCH] RAID-6 check standalone md device
Date: Sat, 2 Apr 2011 13:03:40 +0200
Message-ID: <20110402110340.GA15507@lazy.lzy>
References: <20110221204551.GA15675@lazy.lzy>
 <20110321140244.2314b4b4@notabene.brown>
 <20110321104007.GA15379@lazy.lzy>
 <20110321220457.29d52f5c@notabene.brown>
 <20110321115440.GA15635@lazy.lzy>
 <20110322095905.737fb1d5@notabene.brown>
 <20110331185346.GA5210@lazy.lzy>
 <4D96597C.1020103@tuxes.nl>
 <20110402071310.GA2640@lazy.lzy>
 <4D96FB7D.3060305@tuxes.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D96FB7D.3060305@tuxes.nl>
Sender: linux-raid-owner@vger.kernel.org
To: Bas van Schaik <bas@tuxes.nl>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Bas,

On Sat, Apr 02, 2011 at 11:33:33AM +0100, Bas van Schaik wrote:
> On 04/02/2011 08:13 AM, Piergiorgio Sartor wrote:
> > Hi Bas,
> >
> > On Sat, Apr 02, 2011 at 12:02:20AM +0100, Bas van Schaik wrote:
> >> Dear Piergiorgio,
> >>
> >> On 03/31/2011 07:53 PM, Piergiorgio Sartor wrote:
> >>> please find below the promised patch for the
> >>> RAID-6 check, which allows to pass only the
> >>> MD device, start and length.
> >>> (...)
> >> Recently, I repeatedly ran into block mismatches in my 8x2TB RAID-6
> >> array (and a corrupted EXT3 filesystem). I've been playing with the idea
> >> (as expressed in my posts to the linux-raid list in the last month) to
> >> extend the RAID-6 check in order to report more verbose information
> >> about a block mismatch, which might help to identify the failing hard drive.
> >>
> >> Do I understand correctly that your recent patches implement exactly
> >> this feature?
> > yes, that's the target.
> That's great! The code can currently only be found in GIT, right? I'll

you'll have to add the latest patch, from two days ago,
yourself, I do not see it in git, yet.
It is for mdadm 3.2, that is the development branch.

> try to fetch it from there and compile the user-space binaries. Of

Just unpack the tar.gz, patch it and "make raid6check".

> course I'll report any suggestions back to you, including patches if I
> feel confident enough...

Yes please, I'll try to follow.
 
> Thanks,

Thank you,

bye,

pg

>   Bas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

piergiorgio
