From: Jeff Wiegley <jeffw@csun.edu>
Subject: Re: Why would a recreation cause a different number of blocks??
Date: Fri, 25 Apr 2014 00:05:26 -0700
Message-ID: <535A0936.9060207@csun.edu>
References: <20140424070548.445497dd@netstation> <20140424194832.2d0a867f@netstation> <CAK_KU4a+Ep7=F=NSbb-hqN6Rvayx4QPWm-M2403OHn5-LVaNZw@mail.gmail.com> <20140424203506.5fdee0d3@netstation> <CAK_KU4Zh-azXEEzW4f1m=boCZDKevqaSHxW0XoAgRdrCbm2PkA@mail.gmail <53598F69.5070700@csun.edu> <alpine.DEB.2.02.1404250533040.19744@uplift.swm.pp.se> <5359EC4D.7000308@csun.edu> <alpine.DEB.2.02.1404250800190.19744@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1404250800190.19744@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Here's something about my closer call...

In the original the mdstat lists:

md3 : active raid6 sda1[0] sdc1[2] sde1[4] sdb1[1] sdd1[6]
       1073735680 blocks super 1.2 level 6, 512k chunk, algorithm 2 
[6/5] [UUUUU_]

What do the numbers after the drives mean? It appears to match
the number in the Device Role in an examine.

When I recreated the array with 3.1.4 I used:
/mdadm --create --assume-clean --level=6 --raid-devices=6 /dev/md0 
/dev/sdd1 /dev/sdb1 /dev/sde1 /dev/sdc1 /dev/sda1 missing

now mdadm (which luks is happy with) reports:
Personalities : [raid6] [raid5] [raid4]
md0 : active raid6 sdd1[0] sda1[4] sdc1[3] sde1[2] sdb1[1]
       1073735680 blocks super 1.2 level 6, 512k chunk, algorithm 2 
[6/5] [UUUUU_]

which are not the same numbers. Now I figure I can reorder my
command line arguments but (due to prior drive failures) I think
the mapping (from the original) should be:

0: /dev/sda1
1: /dev/sdb1
2: /dev/sdc1
3: ????
4: /dev/sde1
5: ?????
6: /dev/sdd1
7: /dev/sdf1 (this is my current dead drive that I have to leave out
               and bring the array degraded because this drive is
               probably very out of sync)

Though I know to substitute "missing" for /dev/sdf1 to leave it
out, my question is: What do I do about the active devices 3 and 5
on the command line? Also put missing for those?? I don't think
that will work because wouldn't it think I have 3 drives dead and
refuse to start the array?

But it does seem like I'm getting closer... and if I can get
this partition up then I have high probability of recovering
the larger important array that is in /dev/sd[a-o]2

Thanks again,

- Jeff

On 4/24/2014 11:01 PM, Mikael Abrahamsson wrote:
> On Thu, 24 Apr 2014, Jeff Wiegley wrote:
>
>> If it's mdadm then could I just grab old copies of mdadm sources and
>> compile them one version after the other and try each one?
>
> As far as I know, it's mdadm version specific. If you look in the archives
> I'm sure you'll be able to find the old offsets and you can use the latest
> mdadm with those offsets and hopefully things will work.
>

