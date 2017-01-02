From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Using mdadm --grow to resize a RAID1
Date: Mon, 2 Jan 2017 21:24:12 +0500
Message-ID: <20170102212412.19832496@natsu>
References: <4716208e-12a9-1ae8-46f4-a89ae15d9077@gmail.com>
        <586A454F.1010308@youngman.org.uk>
        <ca87be95-bfb1-10c6-18d4-9aca4a6e3558@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ca87be95-bfb1-10c6-18d4-9aca4a6e3558@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Benjammin2068 <benjammin2068@gmail.com>
Cc: Wols Lists <antlists@youngman.org.uk>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 2 Jan 2017 09:55:34 -0600
Benjammin2068 <benjammin2068@gmail.com> wrote:

> 
> 
> On 01/02/2017 06:19 AM, Wols Lists wrote:
> > On 02/01/17 10:18, Benjammin2068 wrote:
> >> I get stuck at the --size max.
> >>
> >> it seems the correct syntax is "--size=" but that "max" is not supported as an argument.

First you say it's unsupported as an argument, but then actually 

> > [root@quantum ~]# mdadm --grow /dev/md1 --size max
> > mdadm: component size of /dev/md1 unchanged at 239490048K
> 
> > [root@quantum ~]# mdadm --grow /dev/md1 --size=max
> > mdadm: component size of /dev/md1 unchanged at 239490048K

Unsupported as an argument looks like that:

> mdadm --grow /dev/md1 --size=blah
> mdadm: invalid size: blah

In your case mdadm appears to think there is nowhere to grow the array.

Check with "blockdev --getsz /dev/sda3" and sdb3 that they actually do have a
proper size (the result will be in 512-byte sectors). 

If not, maybe your kernel didn't re-read the partition table after resizing
partitions (if that was what you did)?

If the blockdevice size is wrong, do a "blockdev --rereadpt /dev/sda" and sdb,
or just rebooting (as in some cases rereading will fail with a "device busy"
error).

-- 
With respect,
Roman
