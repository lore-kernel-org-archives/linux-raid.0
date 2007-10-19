From: =?ISO-8859-1?Q?BERTRAND_Jo=EBl?= <joel.bertrand@systella.fr>
Subject: Re: [BUG] Raid5 trouble
Date: Fri, 19 Oct 2007 10:04:08 +0200
Message-ID: <471864F8.9010209@systella.fr>
References: <4714BB92.7040701@systella.fr> <47161CE3.80909@systella.fr>	 <e9c3a7c20710170758p4046ca44labe370e94bca6e93@mail.gmail.com> <e9c3a7c20710170840u2ed8d6a9x26523eec6700ad11@mail.gmail.com> <47181CB2.1060602@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47181CB2.1060602@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-raid@vger.kernel.org, sparclinux@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen wrote:
> Dan Williams wrote:
>> I found a problem which may lead to the operations count dropping
>> below zero.  If ops_complete_biofill() gets preempted in between the
>> following calls:
>>
>> raid5.c:554> clear_bit(STRIPE_OP_BIOFILL, &sh->ops.ack);
>> raid5.c:555> clear_bit(STRIPE_OP_BIOFILL, &sh->ops.pending);
>>
>> ...then get_stripe_work() can recount/re-acknowledge STRIPE_OP_BIOFILL
>> causing the assertion.  In fact, the 'pending' bit should always be
>> cleared first, but the other cases are protected by
>> spin_lock(&sh->lock).  Patch attached.
>>   
> 
> Once this patch has been vetted, can it be offered to -stable for 
> 2.6.23? Or to be pedantic, it *can*, will you make that happen?

	I never see any oops with this patch. But I cannot create a RAID1 array 
with a local RAID5 volume and a foreign RAID5 array exported by iSCSI. 
iSCSI seems to works fine, but RAID1 creation randomly aborts due to a 
unknown SCSI task on target side.

	I have stressed iSCSI target with some simultaneous I/O without any 
trouble (nullio, fileio and blockio), thus I suspect another bug in raid 
code (or an arch specific bug). The last two days, I have made some 
tests to isolate and reproduce this bug:

1/ iSCSI target and initiator seem work when I export with iSCSI a raid5 
array;
2/ raid1 and raid5 seem work with local disks;
3/ iSCSI target is disconnected only when I create a raid1 volume over 
iSCSI (blockio _and_ fileio) with following message:

Oct 18 10:43:52 poulenc kernel: iscsi_trgt: cmnd_abort(1156) 29 1 0 42 
57344 0 0
Oct 18 10:43:52 poulenc kernel: iscsi_trgt: Abort Task (01) issued on 
tid:1 lun:0 by sid:630024457682948 (Unknown Task)

	I run for 12 hours some dd's (read and write in nullio) between 
initiator and target without any disconnection. Thus iSCSI code seems to 
be robust. Both initiator and target are alone on a single gigabit 
ethernet link (without any switch). I'm investigating...

	Regards,

	JKB
