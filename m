From: Andrew Hogue <hogue@cs.yorku.ca>
Subject: Re: recommended sata controllers?
Date: Tue, 18 Nov 2003 14:33:45 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0311181431340.11397@nemesis.cs.yorku.ca>
References: <Pine.LNX.4.44.0311181027270.20994-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0311181027270.20994-100000@coffee.psychology.mcmaster.ca>
To: Mark Hahn <hahn@physics.mcmaster.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I tried the Adaptec 1210-SA, however it's linux drivers are only for stock
redhat 7.2 and redhat 8 kernels... and its closed source.  So I wouldn't
recommend it until they open it up.

I'm currently using the onboard controller which is a CMD Technology 3112
device, seems to work pretty well with the current driver in 2.4.22.

-- Andrew


On Tue, 18 Nov 2003, Mark Hahn wrote:

> do you have any recommendations for multiport sata controllers?
> my bias is in the direction of multiple cheap cards, rather than
> expensive ones like 3ware.
>
> ideally, I'd like 8-12 ports in a box, preferably on PCI-X.
> (I'll be using a dual-Opteron/Xeon server board with 1 CPU,
> and don't mind dumb controllers at all)
>
> has anyone had good luck with either the Promise FastTrack s150/tx4
> (4pt, and seems to be well-supported but is PCI-X compatible?)
> or the highpoint rr1820 (6 ports, claims 64x133 PCI-X).
>
> thanks, mark hahn.
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
