From: Luca Berra <bluca@comedia.it>
Subject: Re: working sata raid - which controller?
Date: Thu, 12 Aug 2004 08:36:47 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040812063646.GC25079@percy.comedia.it>
References: <025b01c48030$f2d8da60$cf01a8c0@internal.kbs.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <025b01c48030$f2d8da60$cf01a8c0@internal.kbs.net.au>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Aug 12, 2004 at 03:55:19PM +1000, Paul wrote:
>
>Hi Guys,
>
>We are purchasing a new test server and I need to know which controllers are
>sata raid based and are hardware raid and not software raid. We currently
>use promise fast trak tx4's and have found in linux there is no mirroring
>support and it does not actively mirror data between the two disks.
...
>There is a function in win32 land you can run to "synch" the drives but we
>can't find an equivalent in linux and would prefer hardware. Cost is not a
>problem.
>
'tis not hardware, that is why those controller are also called
fakeraid. the raid is implemented in bios+windows driver.
there is a project to support those with linux 2.6 using device mapper,
it is called dmraid and is still in it's early stage, but it is evolving
well.

if cost is not a problem, go to scsi, and chose a controller with a
cache and a battery.
else probably the better supported sata raid controller are 3wares, even
if ppl are griping over suboptimal performance, also i believe adaptec
works, but i never had the chance to try one.

regards,
L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
