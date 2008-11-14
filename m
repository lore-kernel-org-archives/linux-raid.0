From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: typo in raid[456] kernel code/no change based on type?
Date: Fri, 14 Nov 2008 08:05:38 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0811140743050.20662@p34.internal.lan>
References: <alpine.DEB.1.10.0811121855470.10512@p34.internal.lan> <alpine.DEB.1.10.0811121858300.10512@p34.internal.lan> <20081114121942.GN17966@skl-net.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081114121942.GN17966@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Fri, 14 Nov 2008, Andre Noll wrote:

> On 18:58, Justin Piszcz wrote:
>
> Please try the patch below which fixes this inconsistency.
>
> Andre
>
> commit 6c2f32376c59f08a893cd4736d92f000618dd88f
> Author: Andre Noll <maan@systemlinux.org>
> Date:   Fri Nov 14 13:31:56 2008 +0100
>
>    Improve raid printout for raid levels 4 and 6.
>
>    As noted by Justin Piszcz we currently log a "RAID5 conf printout:" message
>    also for raid4 and raid6 arrays. This trivial patch prints the correct raid
>    level, adds KERN_INFO to all printk's in print_raid5_conf() and fixes a minor
>    coding style issue.
>
>    Signed-off-by: Andre Noll <maan@systemlinux.org>

[ patch ]

# patch -p1 < /home/jpiszcz/patch 
patching file drivers/md/raid5.c
Hunk #1 succeeded at 4302 (offset -41 lines).

Ok, fixed some of them but not all:

before (vanilla 2.6.27.5/6):

[   21.404744] raid5: allocated 10568kB for md3
[   21.406935] raid5: raid level 6 set md3 active with 8 out of 10 devices, algo
rithm 2
[   21.409239] RAID5 conf printout:
                ^^^^^
[   21.411544]  --- rd:10 wd:8
[   21.413812]  disk 0, o:1, dev:sdd1
[   21.416068]  disk 1, o:1, dev:sdk1
[   21.418345]  disk 2, o:1, dev:sde1
[   21.420621]  disk 3, o:1, dev:sdf1
[   21.422836]  disk 6, o:1, dev:sdg1
[   21.424941]  disk 7, o:1, dev:sdh1
[   21.426926]  disk 8, o:1, dev:sdl1
[   21.428824]  disk 9, o:1, dev:sdi1

after: (with your patch):

[   21.430884] raid5: allocated 10568kB for md3
[   21.433023] raid5: raid level 6 set md3 active with 10 out of 10 devices, algorithm 2
[   21.435236] RAID6 printout:
                ^^^^^ patch fixed this one, but it still says raid5 in other
                      parts of the code
[   21.437316]  --- rd:10 wd:10
[   21.439291]  disk 0, o:1, dev:sdd1
[   21.441204]  disk 1, o:1, dev:sdk1
[   21.443013]  disk 2, o:1, dev:sde1
[   21.444749]  disk 3, o:1, dev:sdf1
[   21.446383]  disk 4, o:1, dev:sdc1
[   21.447937]  disk 5, o:1, dev:sdj1
[   21.449444]  disk 6, o:1, dev:sdg1
[   21.450873]  disk 7, o:1, dev:sdh1
[   21.452276]  disk 8, o:1, dev:sdl1
[   21.453618]  disk 9, o:1, dev:sdi1

Here is the current output that still contains 'raid5':

$ dmesg | grep -i raid5
[   19.881548] md: raid5 personality registered for level 5
[   21.408354] raid5: device sdl1 operational as raid disk 8
[   21.410583] raid5: device sdk1 operational as raid disk 1
[   21.412789] raid5: device sdj1 operational as raid disk 5
[   21.414994] raid5: device sdi1 operational as raid disk 9
[   21.417217] raid5: device sdh1 operational as raid disk 7
[   21.419420] raid5: device sdg1 operational as raid disk 6
[   21.421622] raid5: device sdf1 operational as raid disk 3
[   21.423810] raid5: device sde1 operational as raid disk 2
[   21.425970] raid5: device sdd1 operational as raid disk 0
[   21.428090] raid5: device sdc1 operational as raid disk 4
[   21.430884] raid5: allocated 10568kB for md3
[   21.433023] raid5: raid level 6 set md3 active with 10 out of 10 devices, algorithm 2


Justin.
