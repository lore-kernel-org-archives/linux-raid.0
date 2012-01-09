From: pg@lxra2.to.sabi.co.UK (Peter Grandi)
Subject: Re: SMART, RAID and real world experience of failures.
Date: Mon, 9 Jan 2012 20:23:20 +0000
Message-ID: <20235.19640.497632.21478@tree.ty.sabi.co.UK>
References: <4F063808.6040000@crc.id.au>
	<20230.55643.346235.891308@tree.ty.sabi.co.UK>
	<4F06DDAC.1050501@crc.id.au>
	<4F06F969.1010205@turmel.org>
	<20234.65226.464692.42166@tree.ty.sabi.co.UK>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20234.65226.464692.42166@tree.ty.sabi.co.UK>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>> [ ... ] In general there are vanishingly few cases in which
>>> RAID6 makes sense, and in the 4 drive case a RAID10 makes
>>> even more sense than usual. [ ... ]

>> In this case, the raid6 can suffer the loss of any two drives
>> and continue operating.  Raid10 cannot, unless you give up
>> more space for triple redundancy. [ ... ]

[ ... ]

> * While RAID6 can =ABsuffer the loss of any two drives and
>   continue operating=BB, RAID10 can "suffer the loss of any
>   number of non paired drives and continue operating", [ ... ]

Let's put behind the (euphemism alert) entertaining
misunderestimation that RAID6 is safer than RAID10 even if a
(wide) RAID10 can take more than 2 non-paired failures while
continuing service, and has much more desirable rebuild profiles
and statical risks, which is a bigger deal in practice.

But the possibly amusing detail here is that while I have a
server at home with 4 drives I don't use RAID10 for that.

What I use is not-RAID: I have 2 "active" drives, and 2 "backup"
drives, and I image-copy each partition in each pair during the
night (using a simple CRON script), because:

  * I don't particularly value the additional performance that
    RAID10 would give for a "home" server.

  * Data preservation by the the avoidance of common modes to
    maximize the advantages of redundancy seems more important
    to me. I have 4 drives of different makes and models, and I
    keep 2 separate "active" drives so *maintenance* or a
    failure of one or the other does not fully terminate service
    (a minor concern though for my "home" server), and the 2
    backup drives can be kept in sleep mode until the night-time
    copy, and have a completely different stress profile from
    the 2 "active" drives (and between them too).
    Unfortunately all 4 are in the same cage in the same PC box
    though, and thus in the same environmental conditions and
    all 'online', and thus with undesirable common modes. Thus I
    also have 'offline' drives that I put in an external eSATA
    cradle every now and then to further copy the contents of
    the 2 active drives onto them, and then I put them on a
    shelf, in totally different environmental conditions.

  * I could be using continuous RAID1 for the mirroring between
    "active" and "backup" drives, even for the additional eSATA
    offline mirrors, and I do that on some "work" servers. But I
    prefer for the mirroring to be noncontinuous and periodic,
    to enjoy a sort of simple minded versioning system (and to
    reduce stress on the "backup" drives also allowing them to
    be in low-power sleep mode for most of the day). So I can
    then recover accidental deletions that are up to a day old
    from the "inline" nightly copies, or up to several days or
    weeks with the "offline" copies.

  * Since for my "home" server I don't really need continuous
    availability, if an "active" drive fails I just power down,
    swap cables with the "backup" drive and reboot, accepting
    losing up to a day of updates.

But for most "work" servers (which have higher continuous
availability targets) I use RAID1 for those that don't have high
write transfer rate requirements, or RAID10 for those that do
(very very very rarely narrow 2+1 or even 3+1 RAID5 for mostly
readonly content caches). For mostly readonly very multithreaded
loads with small data sizes I have occasionally used 3-4 drive
RAID1s. For very "transient" data areas with low availability
requirements even more rarely RAID0s (never a 'concat'!).

Always using MD (without ever reshaping), virtually never hw
RAID (most hw RAID cards are amazingly buggy as well as having
configuration oddities) and almost never DM/LVM2; that is except
for DM's snapshots sometimes, and I am not using yet but very
interested in COW file-systems that offer builting snapshotting.
And using as a rule JFS or XFS (looking sometimes wistfully at
OCFS2) as file-systems, and almost never growing any of their
filetrees (I tend to use 1 or at most 2 filetrees per disk or
RAID set).
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
