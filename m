From: "Tuomas Leikola" <tuomas.leikola@gmail.com>
Subject: Re: Check/repair on composite RAID
Date: Sat, 9 Sep 2006 21:00:51 +0300
Message-ID: <5b170a7d0609091100r631442e9ma17a88cee92c8706@mail.gmail.com>
References: <45024AB5.4050703@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45024AB5.4050703@sauce.co.nz>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 9/9/06, Richard Scobie <richard@sauce.co.nz> wrote:
> If I have a RAID 10, comprising a RAID 0, /dev/md3 made up of RAID1,
> /dev/md1 and RAID1, /dev/md2 and I do an:
>
> echo repair > /sys/block/md3/md/sync_action
>
> will this run simultaneous repairs on the the underlying RAID 1's, or
> should seperate repairs be done to md1 and 2?

check/repair is pointless on raid0, as there is no redundancy.

You should run separate checks (repairs) on the underlying devices.
