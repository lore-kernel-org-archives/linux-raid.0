From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Subject: Re: Help - raid not assembling right on boot (was: Resizing a RAID1)
Date: Thu, 27 Jan 2011 16:14:45 -0500
Message-ID: <AANLkTi=0LyXXyEusHKN6NDVO2wCkZSK+=FYkAfmr-=_D@mail.gmail.com>
References: <AANLkTimJiZHjAYkd4+93=-5b3QZfSqxaz2Ap+YPLYLEL@mail.gmail.com>
 <alpine.DEB.2.00.1101270656230.31246@p34.internal.lan> <AANLkTikP3mVU+=F6Luy5dzj7J9+6cvfZKUaifFW6RUf6@mail.gmail.com>
 <20110128074758.3cb39926@notabene.brown> <AANLkTinMhbozd3_28TRszxbqDuGyyvr7PcijFWWZEJEP@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinMhbozd3_28TRszxbqDuGyyvr7PcijFWWZEJEP@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Sorry if it is a double post, I forgot to switch to plain text.

On Thu, Jan 27, 2011 at 3:47 PM, NeilBrown <neilb@suse.de> wrote:
>
> These start numbers are multiples of 64K.
>
> With 0.90 metadata, md thinks that the metadata for a partition that starts
> at a multiple of 64K and ends a the end of the device looks just like metadata
> for the whole devices.
>

I have a similar problem with GRUB2, shouldn't MD check for partitions
first, then disks?
I've got the same problem at home with my RAID5 in GPT partitions,
GRUB sees the whole disk as RAID however I have 3 partitions on each.
Because of mdadm.conf it is OK but I guess type 0xFD on standard MBR
would fail too.
I had a discussion with the GRUB team of checking partitions first
then whole disk and was referred to this list to see if it is how we
should proceed or not.

>
> If you use 1.0 (or 1;1 or 1.2) metadata this problem will disappear.
>
> NeilBrown
>
