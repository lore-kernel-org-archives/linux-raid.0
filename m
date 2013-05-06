From: Ole Tange <tange@binf.ku.dk>
Subject: Re: Linux mdadm --grow RAID6: Something wrong - reshape aborted
Date: Mon, 6 May 2013 13:42:05 +0200
Message-ID: <CANU9nTm6LDSR4JkP=UWfR3En02+g51Tq4pd5qNLBoNPjWY35Gw@mail.gmail.com>
References: <CANU9nT=_7HYg14sR57qffH1B8KXUoRyghQC8P1oz2KxRbZr1jA@mail.gmail.com>
 <20130506164434.2804bb68@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130506164434.2804bb68@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, May 6, 2013 at 8:44 AM, NeilBrown <neilb@suse.de> wrote:
> On Thu, 2 May 2013 13:56:09 +0200 Ole Tange <tange@binf.ku.dk> wrote:
>
:
>> I thought this would be enough:
>>
>>   mdadm -v --grow /dev/md1 --raid-devices=10 --backup-file=/root/back-md1
:
>> The last command works, but the 2 first commands fail with:
>>
>>   mdadm: Need to backup 7168K of critical section..
>>   mdadm: /dev/md2: Something wrong - reshape aborted
:
> Very sensible to test first.  However to reshape a RAID6 from 9 to 10, you
> need each device to be at least 7*8*chunksize*2 - possibly a bit more than
> that.
> Your script uses a chunksize of 128K, so you need at least 15Meg
> Your script creates 1Meg devices.
>
> Try your test with a  much smaller chunk size and a somewhat larger device
> size.

Spot on. If I adjust the size of the loop-back devices to 30M instead
of 1M, then everything works.


/Ole
