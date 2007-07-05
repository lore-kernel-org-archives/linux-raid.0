From: "David Rees" <drees76@gmail.com>
Subject: Re: Expanding a RAID-5 in use from 3 disks to 6 disks
Date: Thu, 5 Jul 2007 16:43:51 -0700
Message-ID: <72dbd3150707051643t145d4fa9q1191aba89e2a4321@mail.gmail.com>
References: <11456058.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <11456058.post@talk.nabble.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: acostoya <adrian@costoya.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 7/5/07, acostoya <adrian@costoya.com> wrote:
>
> I've being trying to set a 6 disk RAID-5 for a few days but it took only 3
> disks (the other 3 gave Device busy error); in the meantime, an old server
> went out of order so I have to use the incomplete host and it is now online
> with user files.
>
> The question is, is there a way to expand my RAID-5 from 3 disks to 6 disks
> without losing data?.

Yes, it's possible. A quick google of 'linux expand raid 5' turned up
a bunch of hits, FYI.

Since you already have the 3 disks added to the array as spares, all
you should have to do is:

mdadm --grow /dev/md0 --raid-devices=6

Watch /proc/mdstat for the expansion status.

After it is complete, you need to expand your filesystem to utilize
the new larger device.

Keep in mind that most people recommend raid 6 for larger raid 5
arrays since the likelyhood of multiple device failures goes up
significantly the more drives you have in your array. Unfortunately I
don't think it is possible to convert a raid 5 array to raid 6.

-Dave
