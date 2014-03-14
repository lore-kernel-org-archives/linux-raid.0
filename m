From: Phil Turmel <philip@turmel.org>
Subject: Re: mapping disk sectors to files
Date: Fri, 14 Mar 2014 08:13:05 -0400
Message-ID: <5322F251.2080600@turmel.org>
References: <00000144bf42b0b6-2fe18839-c08d-4c8a-a358-a68135c6d340-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <00000144bf42b0b6-2fe18839-c08d-4c8a-a358-a68135c6d340-000000@email.amazonses.com>
Sender: linux-raid-owner@vger.kernel.org
To: Thorsten von Eicken <tve@voneicken.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good morning Thorsten,

On 03/14/2014 02:23 AM, Thorsten von Eicken wrote:
> I've just had a disk in a raid1 mirror set die and that exposed some bad
> block on the remaining drive -- ooops! I'd now like to map the bad
> blocks to files so I can restore the affected files from backups, but I
> can't figure out the mapping. What I've done:

[trim /]

> The GPT is:
> Disk /dev/sda: 3907029168 sectors, 1.8 TiB

>    3          935936      3907029134   1.8 TiB     FD00  Linux RAID

> The md device says:
> # mdadm --examine /dev/sda3
> /dev/sda3:
>           Magic : a92b4efc
>         Version : 1.2

>      Raid Level : raid1
> 
>     Data Offset : 2048 sectors

These key pieces of info tell you that the blocks in /dev/md0 start at
sector 2048 in /dev/sda3, which itself starts at sector 935936 of the
disk as a whole.  As a raid1, the blocks are 1:1 linear from there.

So all you've missed in your calculations is the 2048 sector offset of
the md data area.  Add that to your partition start value and you'll be
golden.

HTH,

Phil
