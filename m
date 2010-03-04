From: "Ken D'Ambrosio" <ken@jots.org>
Subject: Re: RAID MIA.  Again.  (Kinda.)
Date: Thu, 4 Mar 2010 17:00:10 -0500 (EST)
Message-ID: <b305ada429c44b2b62b03c101f7ecf0a.squirrel@webmail.jots.org>
References: <ef2f0a4210283390480f4adbd9a547de.squirrel@webmail.jots.org>
    <20100305075016.51e98363@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100305075016.51e98363@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, March 4, 2010 3:50 pm, Neil Brown wrote:
> On Thu, 4 Mar 2010 11:12:29 -0500 (EST)
> "Ken D'Ambrosio" <ken@jots.org> wrote:

[bad things happened to Ken's RAID-5 here]

>
> You missed the bit where you provide concrete information rather than
> vaguaries.

Humble apologies; I'm not well-enough versed with the intricacies of Linux
RAID to know what's appropriate and not.

> I'm guessing that you created the array over whole-devices, and then
> partitioned the array - is that correct? If fdisk shows you an
> unpartitioned array, maybe just the partition table is corrupt.   Seems
> strange.

Actually, no.  These were created using /dev/sd[abcd]2 -- I saved off
space on sd[abcd]1 for swap, /tmp, etc.  Done via the Ubuntu installer, if
that makes a difference.  For the record, all the /dev/sd[abcd]1 non-RAID
partitions look fine.

> To so that I/we don't have to guess, please give exact commands that you
> run and the exact output so we have access to the same information as you.

Well, I rebooted, and was surprised that nothing RAID-esque came up. 
Since my OS is on one of the afore-mentioned non-RAIDed partitions, the
OS, itself, booted, but none of the RAID partitions mounted.  I tried to
mount, and failed.  That's when I checked the RAID device, /dev/md0. 
fdisk showed it lacking any partitions, but the mdadm.conf file hadn't
been touched for a couple of weeks, so I was pretty sure nothing there had
changed.  On the off chance that the SCSI drives had re-ordered
themselves, I went through all 24 permutations of
mdadm --assemble /dev/md0 /dev/sda2 /dev/sdb2 /dev/sdc2 /dev/sdd2
since I wasn't sure if the drive order was significant.  All of them
"worked," inasmuch as they created /dev/md0, but in all cases it was
partitionless.  I also tried mdadm --detail --scan, to verify that it
matched UUIDs with those in the /etc/mdadm.conf file, and it did (the
array line looks thusly:
ARRAY /dev/md0 level=raid5 num-devices=4
UUID=1e89645a:7e24dcef:9e77d54f:077a6a6f  )


> Too much data is much much better than not enough.

Granted... but, sometimes -- especially when learning -- there can be a
bad signal:noise ratio.  Tends to make me hesitant when I'm a (relative)
newbie to a given topic.  That being said, I *think* I've figured out what
I should be doing, but I also think I did it.  Did I miss something?

Thanks!

-Ken

> NeilBrown
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
>
>
> --
> This message has been scanned for viruses and
> dangerous content by MailScanner, and is believed to be clean.
>
>



-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.

