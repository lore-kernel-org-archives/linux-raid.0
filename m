From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Linux Software RAID Bitmap Question
Date: Wed, 28 Feb 2007 14:44:23 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0702281443060.6844@p34.internal.lan>
References: <Pine.LNX.4.64.0702250903120.21821@p34.internal.lan>
 <17890.24681.249414.635536@notabene.brown> <Pine.LNX.4.64.0702281126120.19818@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0702281126120.19818@twinlark.arctic.org>
Sender: linux-raid-owner@vger.kernel.org
To: dean gaudet <dean@arctic.org>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids


On Wed, 28 Feb 2007, dean gaudet wrote:

> On Mon, 26 Feb 2007, Neil Brown wrote:
>
>> On Sunday February 25, jpiszcz@lucidpixels.com wrote:
>>> I believe Neil stated that using bitmaps does incur a 10% performance
>>> penalty.  If one's box never (or rarely) crashes, is a bitmap needed?
>>
>> I think I said it "can" incur such a penalty.  The actual cost is very
>> dependant on work-load.
>
> i did a crude benchmark recently... to get some data for a common setup
> i use (external journals and bitmaps on raid1, xfs fs on raid5).
>
> emphasis on "crude":
>
> time sh -c 'tar xf /var/tmp/linux-2.6.20.tar; sync'
>
> xfs journal     raid5 bitmap    times
> internal        none            0.18s user 2.14s system 2% cpu 1:27.95 total
> internal        internal        0.16s user 2.16s system 1% cpu 2:01.12 total
> raid1           none            0.07s user 2.02s system 2% cpu 1:20.62 total
> raid1           internal        0.14s user 2.01s system 1% cpu 1:55.18 total
> raid1           raid1           0.14s user 2.03s system 2% cpu 1:20.61 total
>
>
> raid5:
> - 4x seagate 7200.10 400GB on marvell MV88SX6081
> - mdadm --create --level=5 --raid-devices=4 /dev/md4 /dev/sd[abcd]1
>
> raid1:
> - 2x maxtor 6Y200P0 on 3ware 7504
> - two 128MiB partitions starting at cyl 1
> - mdadm --create --level=1 --raid-disks=2 --auto=yes --assume-clean /dev/md1 /dev/sd[fg]1
> - mdadm --create --level=1 --raid-disks=2 --auto=yes --assume-clean /dev/md2 /dev/sd[fg]2
> - md1 is used for external xfs journal
> - md2 has an ext3 filesystem for the external md4 bitmap
>
> xfs:
> - mkfs.xfs issued before each run using the defaults (aside from -l logdev=/dev/md1)
> - mount -o noatime,nodiratime[,logdev=/dev/md1]
>
> system:
> - dual opteron 848 (2.2ghz), 8GiB ddr 266
> - tyan s2882
> - 2.6.20
>
> -dean
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

I like your crude benchmark, it works well. I have not tested with a 
bitmap, but it does not seem worth it to use those.

Here are my results (for disk speed/purposes only):

All FS are XFS with similar mount options as yours.

Raid1 Dual 74GB Raptor (older models, no NCQ) [no bitmap]
# time sh -c 'tar xf linux-2.6.20.tar; sync'

real    0m40.226s
user    0m0.200s
sys     0m1.515s

Raid5 Quad 150 Raptor (NCQ) [no bitmap]
# time sh -c 'tar xf linux-2.6.20.tar; sync'

real    0m21.721s
user    0m0.174s
sys     0m1.541s

Raid5 Six 400GB Sata Drives (some NCQ, some not) [no bitmap]

# time sh -c 'tar xf linux-2.6.20.tar; sync'
real    1m7.322s
user    0m0.194s
sys     0m1.492s


