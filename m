From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Choosing a SATA HD for RAID1
Date: Sat, 29 Feb 2020 10:28:15 +0000
Message-ID: <5E5A3CBF.4060706@youngman.org.uk>
References: <CAG6BYRzw4i6mtTfEVnMpwGAVW0r=BwODiN+0o-UggiaEyo4VSw@mail.gmail.com>
 <5E5A2C65.3090006@youngman.org.uk>
 <20200229071940.29a6320a@olgiati-in-paraguay.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200229071940.29a6320a@olgiati-in-paraguay.org>
Sender: linux-raid-owner@vger.kernel.org
To: "Renaud (Ron) OLGIATI" <renaud@olgiati-in-paraguay.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 29/02/20 10:19, Renaud (Ron) OLGIATI wrote:
> On Sat, 29 Feb 2020 09:18:29 +0000
> Wols Lists <antlists@youngman.org.uk> wrote:
> 
>> On 29/02/20 02:47, Hans Malissa wrote:
>>> I'm trying to select suitable SATA HD for RAID1 via mdadm. 
> 
> As an aside on this thread, should one aim to build RAID arrays from HDs of the same make and model, or on the contrary diversify HDs in the hope that disks of different makers and model are less likely to fail at the same time ?
>  
It's widely accepted that you should not buy all your raid disks at the
same time from the same manufacturer, precisely because they will
probably all suffer from similar defects.

Drives tend to fail quickly from defects, or wear out slowly from use.
Especially in a raid array where usage patterns are very similar, that
means you don't want similar drives with similar usage as they'll wear
out together.

Throw in the fact that rebuilding an array regularly stresses the other
drives to the point of failure ...

So no. Don't buy your drives in one hit. Either spread them out over
time, or mix models and manufacturers. With that said, a home user like
me is more likely to deliberately retire a drive than have it fail, so
from my point of view it's pretty irrelevant. And nowadays, with good
quality drives, that's also true for many companies - if an enterprise
drive comes with a five-year warranty and you expect to retire the drive
because it's become too small in five years time, well, the probability
that they'll all fail together is too small to worry about. The
probability that ONE drive will fail is tiny, let alone more ...

Cheers,
Wol
