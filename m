From: Moshe Yudkowsky <moshe@pobox.com>
Subject: Re: RAID needs more to survive a power hit, different /boot layout
 for example (was Re: draft howto on making raids for surviving a disk crash)
Date: Mon, 04 Feb 2008 05:06:09 -0600
Message-ID: <47A6F1A1.7030407@pobox.com>
References: <47A612BE.5050707@pobox.com> <20080203200150.GB22004@cthulhu.home.robinhill.me.uk> <47A6283E.1000706@pobox.com> <20080203220158.GC22004@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080203220158.GC22004@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Robin, thanks for the explanation. I have a further question.

Robin Hill wrote:

> Once the file system is mounted then hdX,Y maps according to the
> device.map file (which may actually bear no resemblance to the drive
> order at boot - I've had issues with this before).  At boot time it maps
> to the BIOS boot order though, and (in my experience anyway) hd0 will
> always map to the drive the BIOS is booting from.

At the time that I use grub to write to the MBR, hd2,1 is /dev/sdc1. 
Therefore, I don't quite understand why this would not work:

grub <<EOF
root(hd2,1)
setup(hd2)
EOF

This would seem to be a command to have the MBR on hd2 written to use 
the boot on hd2,1. It's valid when written. Are you saying that it's a 
command for the MBR on /dev/sdc to find the data on (hd2,1), the 
location of which might change at any time? That's... a  very strange 
way to write the tool. I thought it would be a command for the MBR on 
hd2 (sdc) to look at hd2,1 (sdc1) to find its data, regardless of the 
boot order that caused sdc to be the boot disk.

-- 
Moshe Yudkowsky * moshe@pobox.com * www.pobox.com/~moshe
  "Bring me the head of Prince Charming."
    				-- Robert Sheckley & Roger Zelazny
