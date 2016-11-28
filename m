From: Phil Turmel <philip@turmel.org>
Subject: Re: md prefered minor has been renumbered
Date: Mon, 28 Nov 2016 17:12:39 -0500
Message-ID: <bccbeb42-82b5-87fc-aa74-11a34b8c9d8d@turmel.org>
References: <BC4985417D7F7B49B9AB545333BDB61B191FE1A2@Exchange-MBX1.esf.edu>
 <BC4985417D7F7B49B9AB545333BDB61B191FE1BC@Exchange-MBX1.esf.edu>
 <91b64061-6026-c738-75a6-8d80a177aec8@turmel.org>
 <BC4985417D7F7B49B9AB545333BDB61B191FE20C@Exchange-MBX1.esf.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BC4985417D7F7B49B9AB545333BDB61B191FE20C@Exchange-MBX1.esf.edu>
Sender: linux-raid-owner@vger.kernel.org
To: "Randall C. Grimshaw" <rgrimsha@esf.edu>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/28/2016 03:34 PM, Randall C. Grimshaw wrote:
> Phil:
>   Thank you for responding, it is much appreciated.
>   This is a recently assigned system so I must apologize for not having all of the history re fstab.
>   But when I try to boot into the 'normal' system it continues to use the new numbering, the mounts fail, (the duplicate md122 obviously fails), and the system panics.
>   I suspect the answer will have something to do with the command I googled: mdadm -A --update=superminor /dev/mdNEWNUMBER  /dev/sd...
> .. but I have zero experience with it.
> Randall

Use 'blkid' to find out the UUIDs of your filesystems.  Replace /dev/mdX
in your fstab with UUID="......"

then "mount -av"

Then you don't care what number shows up, and can resolve it at your
leisure.

Whatever mdadm.conf you end up with, run your distro's utility to get it
into your initramfs.  On ubuntu, it is "update-initramfs".

Phil

