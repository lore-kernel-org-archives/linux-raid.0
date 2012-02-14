From: CoolCold <coolthecold@gmail.com>
Subject: Re: XFS on top RAID10 with odd drives count and 2 near copies
Date: Tue, 14 Feb 2012 11:31:01 +0400
Message-ID: <CAGqmV7qoKW-7S26VwOS5szRRfvkr_cKh=ggXkXueMifhjJMhfA@mail.gmail.com>
References: <CAGqmV7o7AQFY1K-1JLDk02Cv6GpAUQFjiSdM2Wbdbu6Zh_t0Wg@mail.gmail.com>
	<4F35E925.6000003@hardwarefreak.com>
	<CAGqmV7rBa39U-RWkzH-cTci1pNrrY1sfS=DkyK1wHE80bMt6qA@mail.gmail.com>
	<4F38FD5D.1010201@hardwarefreak.com>
	<CAGqmV7o6SNGV_A=iP2-uJXAJpPwh83GuqTZ-BzuY6vceMJJPVg@mail.gmail.com>
	<20120213230228.GA5822@www5.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120213230228.GA5822@www5.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: keld@keldix.com
Cc: stan@hardwarefreak.com, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Feb 14, 2012 at 3:02 AM,  <keld@keldix.com> wrote:
> On Tue, Feb 14, 2012 at 01:40:25AM +0400, CoolCold wrote:
>> On Mon, Feb 13, 2012 at 4:09 PM, Stan Hoeppner <stan@hardwarefreak.c=
om> wrote:
>> > On 2/12/2012 2:16 PM, CoolCold wrote:
>> >> First of all, Stan, thanks for such detailed answer, I greatly ap=
preciate this!
>> >
>> > You're welcome. ?You may or may not appreciate this reply. ?It got
>> > really long. ?I tried to better explain the XFS+md linear array se=
tup.
>> >
>> >> There are several reasons for this - 1) I've made decision to use=
 LMV
>> >> for all "data" volumes (those are except /, /boot, /home , etc) ?=
2)
>> >> there will be mysql database which will need backups with snapsho=
ts 3)
>> >
>> > So you need LVM for snaps, got it.
>
>
> Well, I do not think LVM gives you snaps. I think you need to close d=
own the mysql database
> to have a consistent DB, then make backup, then reactivate mysql. I m=
ay be wrong, tho.
You are a bit wrong here. MySQL in general supports two storage types
- MyISAM & InnoDB. While InnoDB is ACID transactional engine, MyISAM
isn't.
So, one should be able to backup InnoDB with snapshots without
interrupting workload and it will do recovery/transaction rollbackup
on startup.
=46or MyISAM engine, snapshots will produce unpredictable results as
partial update may happen. But, snapshots are useful in any case,
because they allow to do backup in 4 steps:
1) "FLUSH TABLES WITH READ LOCK" - this will flush all buffers and
close databases
2) lvcreate -s && unlock tables.... - doing snapshot of data and releas=
ing lock
3) copying it somewhere
4) lvremove .... - releasing snapshot

So, in such situation, work will stop for 1) & 2) , not cosuming time f=
or 3) .


> LVM is great if you want to resize partitions. XFS cannot be shrinked=
, tho, only grown.
> For snapshots you need somthing like btrfs. But to have the DB consis=
tent you need to close it
> before taking a backup.
>
> And anyway, I think a 7 spindle raid10,f2 would be much faster than
> a md linear array setup, both for small files and for largish
> sequential files. But try it out and report to us what you find.
Quick & dirty iozone doesn't show this yet ...

>
> I would expect =A0a linear md, and also most other MD raids would ten=
d to perform better in
> the almost empty state, as the files will be placed on the faster par=
ts of the spindles.
> raid10,f2 would have a more uniform performance as it gets filled, be=
cause read access to
> files would still be to the faster parts of the spindles.
>
>
> best regards
> Keld
>
> ---

[snip]

--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
