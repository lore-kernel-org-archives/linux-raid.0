From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: RAID rebuild on Create
Date: Mon, 30 Apr 2007 11:19:24 -0700
Message-ID: <e9c3a7c20704301119v1c69aaf0xb272fe85697934cd@mail.gmail.com>
References: <Pine.LNX.4.61.0704301958530.29151@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0704301958530.29151@yvahk01.tjqt.qr>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/30/07, Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
> Hi list,
>
>
> when a user does `mdadm -C /dev/md0 -l <any> -n <whatever fits>
> <devices>`, the array gets rebuilt for at least RAID1 and RAID5, even if
> the disk contents are most likely not of importance (otherwise we would
> not be creating a raid array right now). Could not this needless resync
> be skipped - what do you think?
>
If you want his behavior you can always create the array with a
'missing' device to hold off the resync process.  Otherwise, if all
disks are available, why not let the array make forward progress to a
protected state?

Also, the resync thread automatically yields to new data coming into
the array, so you can effectively sync an array by writing to all the
blocks.

>
> Jan

--
Dan
