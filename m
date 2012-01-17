From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: RAID6, failed device, unresponsive system?
Date: Tue, 17 Jan 2012 11:43:43 +0000
Message-ID: <CADNH=7GrCN5ec5YahZvAGiHTW65eiptE74KN=F1oe_gGQpHTow@mail.gmail.com>
References: <CADNH=7FyxQ=C=gdirjpTsc5q0tJ2=SSXtryRM36icTH=ncC_0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7FyxQ=C=gdirjpTsc5q0tJ2=SSXtryRM36icTH=ncC_0A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 17 January 2012 11:25, Mathias Bur=C3=A9n <mathias.buren@gmail.com> =
wrote:
> Hi list,
>
> This is the setup:
>
> 8x 2TB HDDs partitioned 2048 sectors in, then almost filled (left 2GB
> or so at the end), so md0 consists of /dev/s[b-h]1 , 64KB chunk size.
> I got an email from mdadm saying that sdb1 has failed, so I SSH in.
> The array is in "checking" state (guessing it's my weekly cron job
> that kicked in), but it's at 38KB/s so I attempt to "echo idle >
> md0/sync_action", but that hangs. I decide to check the SMART details
> of sdb, and it is indeed very broken, RMA is now in progress. So this
> is where I'm at. I've stopped all services relating to the mount poin=
t
> of md0, and trying to unmount but it doesn't work, it just sits there=
=2E
> I can't even cat /proc/mdstat , that hangs as well. I'll leave this
> for a few hours before I get home. If it's not responsive by the time
> I get home (cat /proc/mdstat for example) then I'll just disconnect
> the bad HDD and boot to single user mode to check the array status.
>
> Why is the system unresponsive, shouldn't it still be OK after a driv=
e failure?
>
>
> Best regards,
> Mathias

Hm, I'm seeing this in dmesg, could it be related? (ioctl lock)


[425480.928740] md/raid:md0: read error corrected (8 sectors at
223617240 on sdb1)
[425480.928748] md/raid:md0: read error corrected (8 sectors at
223617248 on sdb1)
[425480.928756] md/raid:md0: read error corrected (8 sectors at
223617256 on sdb1)
[425480.928764] md/raid:md0: read error corrected (8 sectors at
223617264 on sdb1)
[425480.928771] md/raid:md0: read error corrected (8 sectors at
223617272 on sdb1)
[425480.928779] md/raid:md0: read error corrected (8 sectors at
223617280 on sdb1)
[425480.928787] md/raid:md0: read error corrected (8 sectors at
223617288 on sdb1)
[468280.254190] md: ioctl lock interrupted, reason -4, cmd -2142762735
[469362.614553] nfsd: last server has exited, flushing export cache
[471485.048791] md: ioctl lock interrupted, reason -4, cmd -2142762735

/M
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
