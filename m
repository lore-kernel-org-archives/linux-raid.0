From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: [PATCH] proactive raid5 disk replacement for 2.6.11
Date: Mon, 15 Aug 2005 13:29:35 +0200
Message-ID: <ddpuau$nv8$1@sea.gmane.org>
References: <1124050204.3810.28.camel@localhost.localdomain>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Pallai Roland <dap@mail.index.hu> wrote:
>  this is a feature patch that implements 'proactive raid5 disk
> replacement' (http://www.arctic.org/~dean/raid-wishlist.html),
> that could help a lot on large raid5 arrays built from cheap sata
...
>  linux software raid is very fragile by default, the typical (nervous)

I just had a fast look over your patch, so please forgive me if I could
have found the answer in the code.
What I'm wondering about is how does your patch make the whole system
behave in case of more harmful errors?
The read errors you are talking about are quite harmless regarding
subsequent access to the device. Unfortunately there *are* errors (even
read errors, too), especially when you are talking about cheap IDE (ATA,
SATA) equipment, where subsequent access to the device results in
infinite (bus-)lockups. I think, this is the reason why Software-RAID
does never ever touch a failing drive again. If you are changing this
behaviour in general, you risk lock-ups of the raid-device just because
one of the drives got locked up.
What I did not find in your patch is some differentiation between the
harmless and harmful error conditions. I'm not even sure, if this is
possible at all.

regards
   Mario
-- 
Um mit einem Mann gluecklich zu werden, muss man ihn sehr gut
verstehen und ihn ein bisschen lieben.
Um mit einer Frau gluecklich zu werden, muss man sie sehr lieben
und darf erst gar nicht versuchen, sie zu verstehen.

