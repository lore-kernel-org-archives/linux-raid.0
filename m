From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Convert RAID1 to standard ext2
Date: Mon, 13 Aug 2007 17:52:45 -0400
Message-ID: <46C0D2AD.8040308@tmr.com>
References: <a85387af0708130114xab0edbfs9b521da6a19fd96a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a85387af0708130114xab0edbfs9b521da6a19fd96a@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Timothy Weaver <timothyweaver@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Timothy Weaver wrote:
> Hi,
>
> I had 2x750GB drives in a RAID1 configuration in a D-Link NAS
> (DNS-323) device with embedded Linux as an ext2 volume. The
> configuration was corrupted and the NAS no longer saw the RAID.
>
> I put the drives in another Linux box and was able to use mdadm to
> scan the drives. It recognized the RAID1 configuration and created the
> RAID device at /dev/md0. Unfortunately, it says it is corrupt and
> cannot be mounted. I tried using e2fsck / fsck but it says the
> superblock is corrupt. Trying to use copies of the superblock were
> unsuccessful.
>
> I am confident the data is still there and want to get to it. Is there
> a way to take one of the drives and convert it from being in the RAID1
> set to just a standard ext2 partition in a non-destructive way? I
> figured this should be possible with the second drive just to be sure
> not to destroy both copies of the data.

Try a read-only loopback mount of the partition (either). However, I 
think you're missing something else, although I don't have a clue what. 
Unless the O/S started writing bad data or the hardware got sick, you 
should be able to recover. In any case this allows you to do something 
non-destructive and use offset= depending on the superblock location.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

