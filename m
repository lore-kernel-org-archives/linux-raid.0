From: Anshuman Aggarwal <anshuman.aggarwal@gmail.com>
Subject: Re: Split RAID: Proposal for archival RAID using incremental batch checksum
Date: Wed, 29 Oct 2014 14:01:59 +0530
Message-ID: <CAK-d5dZQ6D-HVLv-MG1kizDhZ5-Fy73Z=zoN-9T4dGULeQotEA@mail.gmail.com>
References: <CAK-d5dbdF160hoa1==jWxEQZRpwQ7Sa76=9MREmp2V6Y24U8Kw@mail.gmail.com>
 <20141029123235.56910b68@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141029123235.56910b68@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 Actually I already use a combination of these solutions (MD raid,
multiple devices + LVM2 to join). Unfortunately, none of these
solutions address the following:

- Full data loss in case of disk failure beyond the raid level ( 2
disks in raid5, 3 disks in raid6). This solution allows for single
disk data loss
- Continous read/write to all disks causing wear and tear reducing
life and increasing end user cost

mhddfs (or something like it) will probably be used on top of the N
devices in this proposal to join but that is upto the requirement of
the user.


On 29 October 2014 13:02, Roman Mamedov <rm@romanrm.net> wrote:
> On Wed, 29 Oct 2014 12:45:34 +0530
> Anshuman Aggarwal <anshuman.aggarwal@gmail.com> wrote:
>
>> I'm outlining below a proposal for a RAID device mapper virtual block
>> device for the kernel which adds "split raid" functionality on an
>> incremental batch basis for a home media server/archived content which
>> is rarely accessed.
>
>> Existing solutions considered:
>
> Some of the already-available "home media server" setup schemes you did not
> mention:
>
> http://linuxconfig.org/prouhd-raid-for-the-end-user
> a smart way of managing MD RAID given multiple devices of various sizes;
>
> http://louwrentius.com/building-a-raid-6-array-of-mixed-drives.html
> what to do with a set of mixed-size drives, in simpler terms;
>
> https://romanrm.net/mhddfs
> File-level "concatenation" of disks, with smart distribution of new files;
>
> --
> With respect,
> Roman
