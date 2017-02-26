From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: RAID10 reshape and change lout possible?
Date: Sun, 26 Feb 2017 23:57:49 +0100
Message-ID: <8f887638-fcc9-0433-3d35-537357bd4d8e@thelounge.net>
References: <ae9c2ffb-808a-c905-ea29-1c8f5493b2ad@thelounge.net>
 <20170226185147.GD21587@bitfolk.com>
 <3ef7f0b2-1f3e-40e2-ab23-3ff9436f9ced@thelounge.net>
 <20170226211728.GE21587@bitfolk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170226211728.GE21587@bitfolk.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Am 26.02.2017 um 22:17 schrieb Andy Smith:
> Hi,
>
> On Sun, Feb 26, 2017 at 09:28:34PM +0100, Reindl Harald wrote:
>> Am 26.02.2017 um 19:51 schrieb Andy Smith:
>>> https://manpages.debian.org/jessie/mdadm/mdadm.8.en.html suggests
>>> that --grow --layout can be changed on RAID-10.
>
> […]
>
>> [root@testserver:~]$ mdadm --grow /dev/md0 --layout=f2
>> mdadm: Cannot reshape RAID10 to far-mode
>
> Hmm, that man page says that Debian jessie has version 3.3.2-5 and
> still it says:
>     …changing the chunk size and layout for RAID 0,4,5,6,10 as well
>     as adding or removing a write-intent bitmap.
>
> So is the man page wrong?
>
> Admittedly until I looked I thought RAID-10 couldn't be reshaped at
> all in any way. And now I don't know at all. :)

well, change to "offset" seems to be supported (also not that long at 
all) if there is enough room and Google round confirms that

[root@testserver:~]$ mdadm --grow /dev/md0 --layout=o2
mdadm: insufficient head-room on /dev/sdg1

with the knowledge from today i would have chosen RAID1+0 or two RAID1 
and LVM stripe on top at least for the data partitions which would 
support the current 4 disk setup with "writemostly" and so achieve the 
full read performance out of the two SSD instead need another 2 SSD 
disks or build the raid-setup from scratch, both not making me terrible 
happy :-)
