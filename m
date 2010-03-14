From: Kapetanakis Giannis <bilias@edu.physics.uoc.gr>
Subject: Re: large filesystem corruptions
Date: Sun, 14 Mar 2010 05:26:43 +0200
Message-ID: <4B9C5773.9020804@edu.physics.uoc.gr>
References: <4B9A9D81.3000009@edu.physics.uoc.gr> <4B9AA5AC.9090005@redhat.com> <4B9ADC61.7080007@edu.physics.uoc.gr> <4B9C23AC.5010404@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B9C23AC.5010404@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 14/03/10 01:45, Bill Davidsen wrote:

> I did not notice the LVM on your first post, it's far enough down that I
> missed it. I would be suspicious that the problem is in LVM rather than
> md, but if you're going for a new install soon it's probably not worth
> checking.
>
> If you have video issues with FC12 you may need to run the vesa driver
> as a quick solution. There have been learning experiences in the video
> drivers in recent kernels, not just Fedora.

No it's not the LVM layer.
I have crashes without LVM as well.

gpt label is also corrupted, so my guesses go
to raid layer (that's why i posted here in the first place)
or maybe the driver-adaptec.

Giannis

