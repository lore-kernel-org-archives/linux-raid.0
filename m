From: Chris Murphy <lists@colorremedies.com>
Subject: Re: O_DIRECT to md raid 6 is slow
Date: Sun, 19 Aug 2012 11:02:59 -0600
Message-ID: <20478BE0-7F06-4B37-A77A-CF808B789D84@colorremedies.com>
References: <CALCETrWCu=UPATPdqWP=Gpvswv-RDwaxfr1W1jxYtUMZsqKgSQ@mail.gmail.com> <502B8D1F.7030706@anonymous.org.uk> <CALCETrX=mi92qwOAjt_7Qu-ho_Hdg_5SHX-_8nXYRer4JnzD0w@mail.gmail.com> <201208152307.q7FN7hMR008630@xs8.xs4all.nl> <502CD3F8.70001@hardwarefreak.com> <502D6B0A.6090508@xs4all.net> <502DF357.8090205@hardwarefreak.com> <502E2817.8040306@xs4all.net> <502F237D.6060806@hardwarefreak.com> <502F698C.9010507@msgid.tls.msk.ru> <50305AB9.5080302@hardwarefreak.com>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50305AB9.5080302@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Aug 18, 2012, at 9:17 PM, Stan Hoeppner wrote:
>>=20
>=20
> Yes, as in the case of XFS journal alignment, where the maximum strip=
e
> unit (chunk) size is 256KB and the recommended size is 32KB.  This is=
 a
> 100% metadata workload, making full stripe writes difficult even with=
 a
> small stripe unit (chunk).  Large chunks simply make it much worse.  =
And
> every modern filesystem uses a journal=85

I agree that a bigger chunk size is not inherently better. I suspect 51=
2K is selected for the default because for most people storage loads, w=
hich aren't spectacularly heavy (either data or metadata). But all the =
documentation I find on mdadm fairly well hits home that to get the bes=
t performance, you have to test.

One small quibble, however, is that the three newest filesystems, don't=
 use journals: ZFS, btrfs, ReFS.

>=20
>> Overall, I think 512Kb is quite a good chunk size, even for a raid5
>> array.
>=20
> I emphatically disagree.  For the vast majority of workloads, with a
> 512KB chunk RAID5/6, nearly every write will trigger RMW, and RMW is
> what kills parity array performance.  And RMW is *far* more costly th=
an
> sending smaller vs larger IOs to the drives.

I thought that default seemed a bit high, but I'll bet you dollars to d=
onuts the vast majority of workloads using default settings for parity =
RAID, are 4+MB files like music and video. I think if you get a really =
busy mail server, lots of tiny files, then you've got a pretty strong c=
ase that 512K across maybe 6 disks, is going to lead to a lot of unnece=
ssary RMW, and a lower chunk size will help a lot.


Chris Murphy--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
