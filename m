From: Killian De Volder <killian.de.volder@megasoft.be>
Subject: Re: Two Questions about Linux MD
Date: Fri, 18 Jul 2014 17:30:35 +0200
Message-ID: <53C93D9B.5020709@megasoft.be>
References: <CANH1pmvFap21btE8oy55_TByC2G0gmjDWowF_Rj1HEO1dbG85Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANH1pmvFap21btE8oy55_TByC2G0gmjDWowF_Rj1HEO1dbG85Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Henry Cai <henryplusplus@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I) Can you give the complete mdadm command used to create it ?
Normally it should create a RAID5 without spares. (unless instructed otherwise/you passed the wrong options)
Also giving us the output of mdadm --detail /dev/mdXXX could help

II) ***Disclaimer*** following information below might not be accurate, but such a system could work.
If it's incorrect it should help you understand when someone corrects me.

mdadm --examine /dev/sdXX shows me "Internal Bitmap : 8 sectors from superblock"
This would indicate there is a bitmap on each drive (although I'm not sure, theoretically you could RAID it, but why increase complexity).

However the RAID only need 1 write indent map.
But in the worst case scenario only 1 disk is left, so a copy is maintained on each drive.

Example:
Write indent map for 512K disk using 64K chunks

Bit 1: Synchronized
Bit 0: Not synced

| Chunk | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
| Bit   | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |

When you write in Chunk 1, the bit is set to 0.
Now assume 1 of the disk power connector flies of, and the write to the chunk fails.
| Chunk | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
| Bit   | 0 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |

Meanwhile another write is done to Chunk 2, new bitmap:
| Chunk | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
| Bit   | 0 | 0 | 1 | 1 | 1 | 1 | 1 | 1 |

Now when you plug the disk back in it looks for unwritten chunks, and it find 1 and 2, now it nows it can start from this.
(Note it reject the bitmap of the disk you plugged back in.)

In case you are building a new raid something simular occurs:
This would be the start bitmap:
| Chunk | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
| Bit   | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |

As each chunk is sycned the bit is set to 1:
C1234578
B0000000 Later it becomes:
B1000000 Then later it becomes
B1100000 ...

So at any point you can reboot, and the raid will know where to continue by looking at the non-sycned bitmaps.

Also see the wiki: https://raid.wiki.kernel.org/index.php/Write-intent_bitmap

Killian De Volder

On 18-07-14 16:21, Henry Cai wrote:
> Hi,
>
> Here, I got two confusing questions about Linux MD:
>
> I.  Why when initial create RAID5, mdadm marks a physical disk as "spare"?
>
>     Is this for random write with RMW, or for "sync" speed?
>
>
> II. The write intent bitmap, each disk in RAID with a "write intent
> bitmap", or the whole RAID with one "write intent bitmap"?
>
>     If the whole RAID with one "write intent bitmap", how to know
> which disk's data need reconstruct, or just use the data disks'
>
>    data to calculate the P data, and write to the P disk? If the only
> one "write intent bitmap", how to decide which disk to save
>
>    the "write intent bitmap"?
>
> And is there has any MD design architecture document?
>
> Thanks a lot
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

