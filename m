From: Jim Paris <jim@jtan.com>
Subject: Re: partition sizing and raid1
Date: Thu, 4 Nov 2004 00:24:36 -0500
Message-ID: <20041104052436.GA31128@jim.sh>
References: <4179D9DB.2070709@classforge.com> <4189B3B4.2060203@classforge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4189B3B4.2060203@classforge.com>
Sender: linux-raid-owner@vger.kernel.org
To: matt brennan <raid@classforge.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I created a new raid1 array on two 300GB disks
...
> >Disk /dev/hda: 255 heads, 63 sectors, 16709 cylinders
> >Units = cylinders of 16065 * 512 bytes
...
> kernel: 2.4.18

255 * 63 * 16709 * 512 = 137GB.  

From the Large Disk HOWTO:

"For large IDE disks (over 137 GB): make sure your kernel is 2.4.19/2.5.3 or later."

-jim
