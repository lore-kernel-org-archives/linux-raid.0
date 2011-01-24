From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Optimize RAID0 for max IOPS?
Date: Mon, 24 Jan 2011 10:25:02 -0500 (EST)
Message-ID: <alpine.DEB.2.00.1101241024230.14640@p34.internal.lan>
References: <20110118210112.D13A236C@gemini.denx.de> <4D361F26.3060507@stud.tu-ilmenau.de> <20110119192104.1FA92D30267@gemini.denx.de> <AANLkTikx4g99-Cf_09kEGfF2mmf4Dnuh2A5gTrtKweDy@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="655872-1146966783-1295882702=:14640"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikx4g99-Cf_09kEGfF2mmf4Dnuh2A5gTrtKweDy@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: CoolCold <coolthecold@gmail.com>
Cc: Wolfgang Denk <wd@denx.de>, stefan.huebner@stud.tu-ilmenau.de, linux-raid@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--655872-1146966783-1295882702=:14640
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Mon, 24 Jan 2011, CoolCold wrote:

>> So can anybody help answering these questions:
>>
>> - are there any special options when creating the RAID0 to make it
>> =A0perform faster for such a use case?
>> - are there other tunables, any special MD / LVM / file system /
>> =A0read ahead / buffer cache / ... parameters to look for?
> XFS is known for it's slow speed on metadata operations like updating
> file attributes/removing files..but things gonna change after 2.6.35
> where delaylog is used. Citating Dave Chinner :
> < dchinner> Indeed, the biggest concurrency limitation has
> traditionally been the transaction commit/journalling code, but that's
> a lot more scalable now with delayed logging....
>
> So, you may need to benchmark fs part.

Some info on XFS benchmark with delaylog here:
http://comments.gmane.org/gmane.comp.file-systems.xfs.general/34379

Justin.

--655872-1146966783-1295882702=:14640--
