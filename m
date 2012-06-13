From: David Brown <david.brown@hesbynett.no>
Subject: Re: metadata versions: 0.90 vs 1.2
Date: Wed, 13 Jun 2012 11:31:34 +0200
Message-ID: <4FD85DF6.4000805@hesbynett.no>
References: <1339563343.41566.YahooMailClassic@web190003.mail.sg3.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1339563343.41566.YahooMailClassic@web190003.mail.sg3.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: plug bert <plugbert@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 13/06/2012 06:55, plug bert wrote:
> Hello,
>
> i noticed this while twiddling with RAID1 arrays...
>
> On our old CentOS 4.7 box, i can mount a RAID1 array member
> independently of the array -- i.e. mount /dev/sdc1 /mountpoint....but
> on CentOS 5.x and later i am met with an unknown filesystem:
> linux_raid_member error.
>
> Somebody hinted that this had something to do with the metadata
> versions, so i recreated the RAID1 array on CentOS 5.x with the
> --metadata=0.90 parameter...and was able to mount the array member
> w/o any problems.
>
>
> Is this expected behavior? Are there any potential problems if i
> stick with metadata=0.90(apart from the 28 device and 2Tb disk space
> limit)?
>

Yes, this is expected behaviour (as Mikael explained).

As for potential problems, the big one is if you mount a member of a 
raid1 array (with metadata 0.90, 1.0) directly, and write to it, you'll 
corrupt the raid1 array.  So make sure you only mount it read-only, 
unless you never want to see the raid1 again.

Typical uses of such mounts are for recovery purposes, or for accessing 
the raid from a bootloader (newer grub can understand more raid arrays, 
but raid1 with metadata 0.90 is often used with older grub).


