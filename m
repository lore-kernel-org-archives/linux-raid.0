From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: How to fix Current_Pending_Sector?
Date: Thu, 11 Mar 2010 04:06:50 -0800
Message-ID: <4877c76c1003110406g7b09f6e6ya793321f76e6c3ed@mail.gmail.com>
References: <C7BE89DC.10FE9%groups@email.iain.rauch.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C7BE89DC.10FE9%groups@email.iain.rauch.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Iain Rauch <groups@email.iain.rauch.co.uk>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Mar 11, 2010 at 3:51 AM, Iain Rauch
<groups@email.iain.rauch.co.uk> wrote:
> Smartd emailed me to say I have "1 Currently unreadable (pending) sec=
tors".
> This actually happened for two disks now.
>
> I ran a check and then a repair on my array and they both gave mismat=
ch_cnt
> of 8.
>
> I ran a long self-test on both and they completed without error with =
no
> errors logged. Yet the 'Current_Pending_Sector' is still 1 on both, a=
nd one
> disk also has a 'UDMA_CRC_Error_Count' of 1.
>
> I ran 'hdrecover' on both and they are both telling me "Couldn't reco=
ver
> sector 2930277168". It's asking if I want to overwrite it with zeros =
to fix
> it, but I would assume this will damage my array?
>
> The disk sizes are 1500301910016 bytes and I use 1500250M partition s=
izes
> for the array components. Does that sector fall outside my partition,=
 and
> hence would it be safe to overwrite it with zeros?
>
> Also, why did I have a mismatch_cnt? I haven't run another check sinc=
e I did
> the repair, as I wanted to fix the pending sector.
>
> BTW, I have a 15 drive RAID6.
>
> Hope y'all can help.
>
>
> Iain
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

If you are running RAID6 and it can read from all but two drives then
it should still be able to calculate whatever would match the
remaining (presumed good) reads to fill the later two drives.  RECENT
kernels will try to write over failed sectors automatically; and only
kick the drive if the write fails.

Please provide more information.

Kernel version
mdadm version

Information about how the source block devices are split up before
mdadm sees them, and any related messages from the system-log.  The
relevant section should be near the end of a dmesg output when you've
just completed a check or repair.  Your syslog probably already
captured the same data and stored it elsewhere.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
