From: Luca Berra <bluca@comedia.it>
Subject: Re: Zero Superblock... any ways to recover?
Date: Mon, 1 Mar 2004 19:12:41 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040301181240.GC4340@percy.comedia.it>
References: <E1AxoKd-0004GZ-00@intern.SerNet.DE>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <E1AxoKd-0004GZ-00@intern.SerNet.DE>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Mar 01, 2004 at 03:23:43PM +0100, Timo.Bolse@SerNet.DE wrote:
>Hi List,
>
>The following Problem:
>
>I dd'ed a whole harddisk with the RAID Partitions to another harddisk. The new
>harddisk was a little bit bigger than the original one. Now if i'am doing an
>mdadm -E /dev/hdc on the new harddisk i get this:
>
>pentium-test:/proc/ide # mdadm -E /dev/hdc
>mdadm: No super block found on /dev/hdc (Expected magic a92b4efc, got 00000000)
>
>There must be a way to find the superblock on the new device... is there anyone
>who has a solution for this problem?
>
>I thougt about searching for a92b4efc on the device...
>
if you know the size of the old device you can find it starting at
(sector aligned) DEVICE_SIZE - 64k
since you do not give more information on how your raid was set-up prior
to this activity it is difficult to give firther help

Regards,
L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
