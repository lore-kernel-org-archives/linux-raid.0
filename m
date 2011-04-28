From: Wolfgang Denk <wd@denx.de>
Subject: Re: High mismatch count on root device - how to best handle?
Date: Thu, 28 Apr 2011 07:31:23 +0200
Message-ID: <20110428053123.B031BD52709@gemini.denx.de>
References: <BANLkTikLN6P52tknwD0+D-+2iDUp3sF1fA@mail.gmail.com> <BANLkTikwv-PRcwknZkMsPY6T+N0p=-uC4w@mail.gmail.com> <BANLkTinS9=v+qHAyewRu19HgGr4iriwjkw@mail.gmail.com> <4DB71F3E.3040003@turmel.org> <BANLkTinpDOuTDu7fhbXNYwtvToUaCM=cmQ@mail.gmail.com> <4DB8BEFE.3020009@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <4DB8BEFE.3020009@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Mark Knecht <markknecht@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Dear Phil Turmel,

In message <4DB8BEFE.3020009@turmel.org> you wrote:
> 
> Hmmm.  Since its not swap, this would make me worry about the hardware.  Have you considered shuffling SATA port assignments to see if a pattern shows up?  Also consider moving some of the drive power load to another PS.

I do not think this is hardware related.  I see this behaviour on at
least 5 different machines which show no other problems except for the
mismatch count in the RAID 1 partitins that hold the /boot partition.

> > Still, if I haven't a clue which drive is causing the mismatch then I
> > cannot know which one to pull..
> 
> This is really a file system problem, and effort are underway to solve it.  Btrfs in particular, although it is still experimental.  I'm looking forward to that status changing.

It will probably take some time until grub can boot from a RAID1 array
with btrfs on it...

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
Q:  What's a light-year?
A:  One-third less calories than a regular year.
