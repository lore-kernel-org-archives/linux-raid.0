From: Dragan Simic <dsimic@urc.bl.ac.yu>
Subject: Re: recovery of hosed raid5 array
Date: Mon, 13 Oct 2003 15:54:06 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0310131544260.2746@oracle.urc.bl.ac.yu>
References: <slrnbog9og.t0c.lunz@orr.homenet> <no.Yo.24973.N.nN.0310111457280@business.com>
 <slrnboirt8.me8.lunz@orr.homenet> <Pine.LNX.4.58.0310121034090.7866@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.58.0310121034090.7866@twinlark.arctic.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 12 Oct 2003, dean gaudet wrote:

> querying SMART shouldn't cause this to happen -- but i've seen it occur
> with a promise controller and maxtor disks.  i used to query the SMART
> data once a night just to have a log.  then i switched it to once every 5
> minutes so i could graph the drive temperature... and when i went to once
> every 5 minutes the system became unstable.  the kernel would randomly
> lose the ability to talk to a disk.  the problem would go away after a
> reboot.  i assume it was some sort of race condition.

Just a small drop-in: I have a Promise FastTrak133 with two Maxtor HDDs
attached to it, and running smartmontools every 5 minutes, didn't notice
any troubles or signs of instability.

And, about data recovery, if there are two failing HDDs in a RAID5 array,
and you had nr-spare-disks equal to zero, I *think* there is no chance to
revover your data, because RAID5 is protecting you against at most one
HDD failure.

If I'm wrong, please correct me. ;)


-- 

.----------------------------------------------------------------------------.
| Pozdrav / Best Wishes,     dsimic@urc.bl.ac.yu  | LL   The Choice of       |
| Dragan Simic                 RS.BA Hostmaster   | LL            GNU        |
| URC B.Luka / RSKoming.NET  System/Network Admin | LLLL i n u x  Generation |
`----------------------------------------------------------------------------'

