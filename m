From: David Brown <david@westcontrol.com>
Subject: Re: XFS on top RAID10 with odd drives count and 2 near copies
Date: Tue, 14 Feb 2012 10:05:53 +0100
Message-ID: <4F3A23F1.6090908@westcontrol.com>
References: <CAGqmV7o7AQFY1K-1JLDk02Cv6GpAUQFjiSdM2Wbdbu6Zh_t0Wg@mail.gmail.com> <4F35E925.6000003@hardwarefreak.com> <CAGqmV7rBa39U-RWkzH-cTci1pNrrY1sfS=DkyK1wHE80bMt6qA@mail.gmail.com> <4F38FD5D.1010201@hardwarefreak.com> <CAGqmV7o6SNGV_A=iP2-uJXAJpPwh83GuqTZ-BzuY6vceMJJPVg@mail.gmail.com> <20120213230228.GA5822@www5.open-std.org> <CAGqmV7qoKW-7S26VwOS5szRRfvkr_cKh=ggXkXueMifhjJMhfA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGqmV7qoKW-7S26VwOS5szRRfvkr_cKh=ggXkXueMifhjJMhfA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: CoolCold <coolthecold@gmail.com>
Cc: keld@keldix.com, stan@hardwarefreak.com, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 14/02/2012 08:31, CoolCold wrote:
> On Tue, Feb 14, 2012 at 3:02 AM,<keld@keldix.com>  wrote:
>> On Tue, Feb 14, 2012 at 01:40:25AM +0400, CoolCold wrote:
>>> On Mon, Feb 13, 2012 at 4:09 PM, Stan
>>> Hoeppner<stan@hardwarefreak.com>  wrote:
>>>> On 2/12/2012 2:16 PM, CoolCold wrote:
>>>>> First of all, Stan, thanks for such detailed answer, I
>>>>> greatly appreciate this!
>>>>
>>>> You're welcome. ?You may or may not appreciate this reply. ?It
>>>> got really long. ?I tried to better explain the XFS+md linear
>>>> array setup.
>>>>
>>>>> There are several reasons for this - 1) I've made decision to
>>>>> use LMV for all "data" volumes (those are except /, /boot,
>>>>> /home , etc) ?2) there will be mysql database which will need
>>>>> backups with snapshots 3)
>>>>
>>>> So you need LVM for snaps, got it.
>>
>>
>> Well, I do not think LVM gives you snaps. I think you need to close
>> down the mysql database to have a consistent DB, then make backup,
>> then reactivate mysql. I may be wrong, tho.
> You are a bit wrong here. MySQL in general supports two storage
> types - MyISAM&  InnoDB. While InnoDB is ACID transactional engine,
> MyISAM isn't. So, one should be able to backup InnoDB with snapshots
> without interrupting workload and it will do recovery/transaction
> rollbackup on startup. For MyISAM engine, snapshots will produce
> unpredictable results as partial update may happen. But, snapshots
> are useful in any case, because they allow to do backup in 4 steps:
> 1) "FLUSH TABLES WITH READ LOCK" - this will flush all buffers and
> close databases 2) lvcreate -s&&  unlock tables.... - doing snapshot
> of data and releasing lock 3) copying it somewhere 4) lvremove .... -
> releasing snapshot
>
> So, in such situation, work will stop for 1)&  2) , not cosuming time
> for 3) .
>
>

Very roughly speaking, taking an LVM snapshot is like pulling the plug 
on the system - if the database engine is able to recover reliably from 
a power fail (by replaying logs, or whatever), then it can restore data 
copied by a snapshot.  I don't know MySQL well enough to say if it can 
do such recovery.

I believe that if you have XFS on LVM, then making a snapshot will first 
"freeze" the filesystem, take the snapshot, then "thaw" the filesystem. 
  This process will sync the system, flushing out outstanding writes, 
and delay new writes until the "thaw" - thus you get a bit better than a 
"power-off copy".  In particular, you don't get zeroed-out files no 
matter what you've done with your barrier settings.

I think ext4 also freezes in the same way, but only with later kernels.

mvh.,

David


