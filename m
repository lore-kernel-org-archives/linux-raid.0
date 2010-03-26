From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: An oddity: UNC error while re-adding/resyncing
Date: Thu, 25 Mar 2010 20:50:41 -0700
Message-ID: <4877c76c1003252050m17e28444nfea37065867e29b@mail.gmail.com>
References: <4BAC0319.4010901@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BAC0319.4010901@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Mar 25, 2010 at 5:43 PM, John Robinson
<john.robinson@anonymous.org.uk> wrote:
> I did `mdadm --add /dev/md1 /dev/sdd2` and got the following in my ke=
rnel
> log:
>
> Mar 25 23:56:21 beast kernel: md: bind<sdd2>
> Mar 25 23:56:21 beast kernel: RAID5 conf printout:
> Mar 25 23:56:21 beast kernel: =A0--- rd:3 wd:2 fd:1
> Mar 25 23:56:21 beast kernel: =A0disk 0, o:1, dev:sda2
> Mar 25 23:56:21 beast kernel: =A0disk 1, o:1, dev:sdb2
> Mar 25 23:56:21 beast kernel: =A0disk 2, o:1, dev:sdd2
> Mar 25 23:56:21 beast kernel: md: syncing RAID array md1
> Mar 25 23:56:21 beast kernel: md: minimum _guaranteed_ reconstruction=
 speed:
> 1000 KB/sec/disc.
> Mar 25 23:56:21 beast kernel: md: using maximum available idle IO ban=
dwidth
> (but not more than 2
> 00000 KB/sec) for reconstruction.
> Mar 25 23:56:21 beast kernel: md: using 128k window, over a total of
> 976655360 blocks.
> Mar 25 23:56:22 beast kernel: ata3.00: exception Emask 0x0 SAct 0x3 S=
Err 0x0
> action 0x0
> Mar 25 23:56:22 beast kernel: ata3.00: irq_stat 0x40000008
> Mar 25 23:56:22 beast kernel: ata3.00: cmd
> 60/00:00:a5:3f:03/04:00:00:00:00/40 tag 0 ncq 524288
> in
> Mar 25 23:56:25 beast kernel: =A0 =A0 =A0 =A0 =A0res
> 41/40:00:a0:41:03/8c:00:00:00:00/40 Emask 0x409 (medi
> a error) <F>
> Mar 25 23:56:25 beast kernel: ata3.00: status: { DRDY ERR }
> Mar 25 23:56:26 beast kernel: ata3.00: error: { UNC }
> Mar 25 23:56:26 beast kernel: ata3.00: configured for UDMA/133
> Mar 25 23:56:26 beast kernel: ata3: EH complete
> Mar 25 23:56:26 beast kernel: SCSI device sda: 1953525168 512-byte hd=
wr
> sectors (1000205 MB)
> Mar 25 23:56:26 beast kernel: sda: Write Protect is off
> Mar 25 23:56:27 beast kernel: SCSI device sda: drive cache: write bac=
k
> Mar 25 23:56:27 beast kernel: ata3.00: exception Emask 0x0 SAct 0x3 S=
Err 0x0
> action 0x0
> Mar 25 23:56:28 beast kernel: ata3.00: irq_stat 0x40000008
> Mar 25 23:56:28 beast kernel: ata3.00: cmd
> 60/00:08:a5:3f:03/04:00:00:00:00/40 tag 1 ncq 524288
> in
> Mar 25 23:56:28 beast kernel: =A0 =A0 =A0 =A0 =A0res
> 41/40:00:a2:41:03/8c:00:00:00:00/40 Emask 0x409 (medi
> a error) <F>
> Mar 25 23:56:28 beast kernel: ata3.00: status: { DRDY ERR }
> Mar 25 23:56:28 beast kernel: ata3.00: error: { UNC }
> Mar 25 23:56:29 beast kernel: ata3.00: configured for UDMA/133
> Mar 25 23:56:29 beast kernel: ata3: EH complete
> Mar 25 23:56:29 beast kernel: SCSI device sda: 1953525168 512-byte hd=
wr
> sectors (1000205 MB)
> Mar 25 23:56:29 beast kernel: sda: Write Protect is off
> Mar 25 23:56:29 beast kernel: SCSI device sda: drive cache: write bac=
k
> Mar 25 23:56:34 beast kernel: md: md1: sync done.
> Mar 25 23:56:34 beast kernel: RAID5 conf printout:
> Mar 25 23:56:34 beast kernel: =A0--- rd:3 wd:3 fd:0
> Mar 25 23:56:34 beast kernel: =A0disk 0, o:1, dev:sda2
> Mar 25 23:56:34 beast kernel: =A0disk 1, o:1, dev:sdb2
> Mar 25 23:56:34 beast kernel: =A0disk 2, o:1, dev:sdd2
>
> i.e. a brief whinge about another of the discs in the RAID, while doi=
ng the
> resync. And this is repeatable. Now, is this simply a sign that I nee=
d a new
> disc, or is there something else funny going on? It's not as if eithe=
r of
> the discs (the one I was re-adding or the one that had the UNC during=
 the
> resync) is getting dropped from the array. But the one with the UNC d=
oes
> have one offline uncorrectable and two current pending sectors, accor=
ding to
> smartctl.
>
> NB CentOS 5, 2.6.18-128.4.1.el5 kernel, mdadm 2.6.4. Probably time I =
updated
> a few packages.
>
> Cheers,
>
> John.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Niel, I'm not sure if this is good advice or not, since the data is
the same it may be cached.  However I propose:

1) resync the device (validate the reads are good)  -- scratch that
it's raid 5 and doesn't know to assign lesser trust to slower drives.

1) Unmount the filesystem in question (use a recover cd or usb drive wh=
atever)
2) Determine your DATA stripe size, In this case it appears to be
(128K per drive? for 256K per stripe?) or 128K (per stripe)?
3) badblocks -b $((256*1024)) -n /dev/whatever

-n is non-destructive read-write; which should cause the entire device
contents to be read and safely re-written to the drives.  This should
cause the replacement of any pending sectors.

This is less optimal than just performing the desired operation on the
segment in question, but a LOT safer since the tools in question take
effort to make mistakes.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
