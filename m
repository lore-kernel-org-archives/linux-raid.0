From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Subject: Re: proactive disk replacement
Date: Tue, 21 Mar 2017 12:55:03 +0100
Message-ID: <CAJH6TXhhmAjemQ810J=M4+=pB7iTcPG66k0PPdhxvuUHCTZ=3w@mail.gmail.com>
References: <3FA2E00F-B107-4F3C-A9D3-A10CA5F81EC0@allygray.2y.net>
 <11c21a22-4bbf-7b16-5e64-8932be768c68@websitemanagers.com.au>
 <CAPrpM6wtQe=h1AE-PbFr0-DyZ_wRN7gvibjfn86W0mQz77xnLg@mail.gmail.com>
 <f0916e66-8ea7-3363-3600-1d2cd68e85af@thelounge.net> <02316742-3887-b811-3c77-aad29cda4077@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <02316742-3887-b811-3c77-aad29cda4077@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Reindl Harald <h.reindl@thelounge.net>, Jeff Allison <jeff.allison@allygray.2y.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2017-03-21 11:54 GMT+01:00 Adam Goryachev <mailinglists@websitemanagers.com.au>:
> I can't say I'm an expert in this, but in actual fact, I disagree with both
> your arguments against RAID6...
> You say recovery on a RAID10 is a simple linear read from one drive (the
> surviving member of the RAID1 portion) and a linear write on the other (the
> replaced drive). You also declare that there is no random IO with normal
> work load + recovery. I think you have forgotten that the "normal workload"
> is probably random IO, but certainly once combined with the recovery IO then
> it will be random IO.
>
> In addition, you claim that a drive larger than 2TB is almost certainly
> going to suffer from a URE during recovery, yet this is exactly the
> situation you will be in when trying to recover a RAID10 with member devices
> 2TB or larger. A single URE on the surviving portion of the RAID1 will cause
> you to lose the entire RAID10 array. On the other hand, 3 URE's on the three
> remaining members of the RAID6 will not cause more than a hiccup (as long as
> no more than one URE on the same stripe, which I would argue is ...
> exceptionally unlikely).
>
> In addition, with a 4 disk RAID6 you have a 100% chance of surviving a 2
> drive failure without data loss, yet with 4 disk RAID10 you have a 50%
> chance of surviving a 2 drive failure.
>
> Sure, there are other things to consider (performance, cost, etc) but on a
> reliability point, RAID6 seems to be the far better option.

Totally agree
