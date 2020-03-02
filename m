From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Linux 5.5 Breaks Raid1 on Device instead of Partition, Unusable
 I/O
Date: Mon, 2 Mar 2020 11:51:41 +0500
Message-ID: <20200302115141.1e796b7c@natsu>
References: <e46b2ae7-3b88-05f2-58d7-94ee3df449e4@suddenlinkmail.com>
        <20200302102542.309e2d19@natsu>
        <920df583-1d9e-6037-1d61-cbd5e1133d4d@suddenlinkmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <920df583-1d9e-6037-1d61-cbd5e1133d4d@suddenlinkmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Cc: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 2 Mar 2020 00:38:16 -0600
"David C. Rankin" <drankinatty@suddenlinkmail.com> wrote:

> On 03/01/2020 11:25 PM, Roman Mamedov wrote:
> > On Sun, 1 Mar 2020 19:50:03 -0600
> > "David C. Rankin" <drankinatty@suddenlinkmail.com> wrote:
> > 
> >>   Let me know if there is anything else I can send, and let me know if I
> >> should stop the scrub or just let it run. I'm happy to run any diagnostic you
> >> can think of that might help. Thanks.
> > 
> > It doesn't seem convincing that the issue is raw devices vs partitions, or
> > even kernel version related, especially since you rolled it back and the issue
> > remains.
> > 
> > What else you could send is "smartctl -a" of all devices;
> > 
> > and most importantly, while the "slow" scrub is running on md4, start:
> > 
> >   iostat -x 2 /dev/sdc /dev/sdd
> > 
> > (enlarge the terminal window) and see if any of the 2 devices is pegged into
> > 100.0 in the last "%util" column, or just showing much higher values there
> > than the other one.
> > 
> 
> Thank you Roman, iostat and smartctl -a for sdc/sdd attached,
> 
>   sdc has a few errors from a power hit taken 3000 hours ago or so, but since
> that time it has been fine. I had rolled back to several earlier kernels from
> Jan 14, Jan 21, and Jan 27 with no change, I then updated to current which is
> Archlinux 5.5.6-arch1-1.

These show not just a few errors, but that it is basically dying:

  5 Reallocated_Sector_Ct   0x0033   089   089   010    Pre-fail  Always  13648
197 Current_Pending_Sector  0x0012   085   085   000    Old_age   Always   2544
198 Offline_Uncorrectable   0x0010   085   085   000    Old_age   Offline  2544

>   I'm not sure what to make of the iostat output, but the r_await looks
> suspicious. Could this all be due to one flaky disk without it throwing any
> errors?

Yes, replace the drive ASAP, and see if that solves it.

-- 
With respect,
Roman
