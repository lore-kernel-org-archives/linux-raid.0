From: Mike Hardy <mhardy@h3c.com>
Subject: Re: [PATCH md 9 of 9] Optimise reconstruction when re-adding a recently
 failed drive.
Date: Thu, 17 Feb 2005 16:51:27 -0800
Message-ID: <42153C0F.1030904@h3c.com>
References: <20050218111131.790.patches@notabene> <E1D1wCK-0000Xe-Qm@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <E1D1wCK-0000Xe-Qm@notabene.cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


NeilBrown wrote:
> When an array is degraded, bit in the intent-bitmap are
> never cleared. So if a recently failed drive is re-added, we only need
> to reconstruct the block that are still reflected in the
> bitmap.
> This patch adds support for this re-adding.

Hi there -

If I understand this correctly, this means that:

1) if I had a raid1 mirror (for example) that has no writes to it since 
a resync
2) a drive fails out, and some writes occur
3) when I re-add the drive, only the areas where the writes occurred 
would be re-synced?

I can think of a bunch of peripheral questions around this scenario, and 
bad sectors / bad sector clearing, but I may not be understanding the 
basic idea, so I wanted to ask first.

-Mike
