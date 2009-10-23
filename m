From: "NeilBrown" <neilb@suse.de>
Subject: Re: Is My Data DESTROYED?!
Date: Sat, 24 Oct 2009 10:07:03 +1100
Message-ID: <4b85f6ec7a52d1a124696941b382c2b0.squirrel@neil.brown.name>
References: <170350.56146.qm@web38803.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <170350.56146.qm@web38803.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: adfas asd <chimera_god@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, October 24, 2009 6:24 am, adfas asd wrote:
> Now I'm repeatedly getting this:
>
> This is an automatically generated mail message from mdadm
> running on hex
>
> A DegradedArray event had been detected on md device /dev/md0.

Clearly md0 is degraded - one device is missing.
You need to find out why.  Then if you trust the missing device to
keep working, add it back in (mdadm --add ...)

dmesg or /var/log/something might have hints as to what the error
was that caused md to reject the device.

NeilBrown


>
> Faithfully yours, etc.
>
> P.S. The /proc/mdstat file currently contains the following:
>
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
> [multipath]
> md2 : active raid10 sdb3[0] sdc3[1]
>       1868558336 blocks 1024K chunks 2 offset-copies [2/2] [UU]
>       bitmap: 6/223 pages [24KB], 4096KB chunk
>
> md1 : active (auto-read-only) raid10 sdb2[0] sdc2[1]
>       6297088 blocks 256K chunks 2 offset-copies [2/2] [UU]
>       bitmap: 0/193 pages [0KB], 16KB chunk
>
> md0 : active raid1 sdb1[0]
>       78654144 blocks [2/1] [U_]
>       bitmap: 2/151 pages [8KB], 256KB chunk
>
> unused devices: <none>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

