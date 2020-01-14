From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Debian Squeeze raid 1 0
Date: Tue, 14 Jan 2020 07:23:58 +0000
Message-ID: <5E1D6C8E.8030607@youngman.org.uk>
References: <CAC4UdkbjUVSpkBM88HB0UJMqXh+Pd7CRLaya=s81xMGs-9+m_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC4UdkbjUVSpkBM88HB0UJMqXh+Pd7CRLaya=s81xMGs-9+m_Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Rickard Svensson <myhex2020@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 13/01/20 23:34, Rickard Svensson wrote:
> Hi all
> 
> One disk in my raid 1 0 failed the other night.
> It has been running for +8 years, on my server, a Debian Squeeze.

8 years old, debian squeeze, what version of mdadm is that.

> (And yes, I was just about to update them, bought the HD's and everything)
> 
Great. First things first, ddrescue all drives on to the new ones! I
think recovering your data won't be too hard, so might as well back up
the data on to your new drives then recover that.

> I thought that i would be able to backup the data, but i got ext4
> error aswell, and when i tried to repair that with fsck i got:
> "
> # fsck -n /dev/md0
> fsck.ext4: Attempt to read block from filesystem resulted in short
> read while trying to open /dev/md0
> Could this be a zero-length partition?
> "
My fu isn't good here but I strongly suspect the read failed with an
"array not running" problem ...
> 
> So i am wondering if my mdadm raid is okay.
> The "State  [clean|active]" and "Array State : AA.."    is not so easy
> to interpret, tried to read parts of the threads, but at the same time
> is worried that more disks should failt... And I'm starting to get
> really stressed :(

All the more reason to ddrescue your disks ...
> 
> All the disk are the same type.  And apparently does not support SCT,
> which I was not aware of before.
> /dev/sde2  seems to be gone.
> 
Can you check the drive in another system? Is it the drive, or is it a
controller issue?

The fact that the three event counts we have are near-identical is a
good sign. The worry is that sde2 disappeared a long time ago - have you
been monitoring the system? If you ddrescue it will it give an event
count almost the same as the others? If it does, that makes me suspect a
controller issue has knocked two drives out, one of which has recovered
and the other hasn't ...
> "
> cat /proc/mdstat
> Personalities : [raid10]
> md0 : active raid10 sda2[0] sde2[3](F) sdc2[2](F) sdb2[1]
>       5840999424 blocks super 1.2 512K chunks 2 near-copies [4/2] [UU__]
> "

<snip>
> 
> 
> I really hope someone can help me!
> 
https://raid.wiki.kernel.org/index.php/Linux_Raid#When_Things_Go_Wrogn

Note that when it says "use the latest version of mdadm" it means it - I
suspect your version may be well out-of-date.

Give us a bit more information, especially the version of mdadm you're
using. See if you can ddrescue /dev/sde, and what that tells us, and I
strongly suspect a forced assembly of (copies of) your surviving disks
will recover almost everything.

Cheers,
Wol
