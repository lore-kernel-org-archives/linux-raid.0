From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: raid1 repair does not repair errors?
Date: Thu, 24 Oct 2013 12:58:18 +0400
Message-ID: <5268E12A.8070404@msgid.tls.msk.ru>
References: <526541CD.8000003@msgid.tls.msk.ru> <20131022121113.48958a0b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131022121113.48958a0b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

22.10.2013 05:11, NeilBrown wrote:
> On Mon, 21 Oct 2013 19:01:33 +0400 Michael Tokarev <mjt@tls.msk.ru> wrote:
>
>> Hello.
>>
>> I've a raid1 array (composed of 4 drives, so it is a 4-fold
>> copy of data), and one of the drives has an unreadable (bad)
>> sector in the partition belonging to this array.
>>
>> When I run md 'repair' action, it hits the error place, the
>> kernel clearly returns an error, but md does not do anything
>> with it.  For example:
>>
>> Oct 21 18:43:55 mother kernel: [190018.073098] md: requested-resync of RAID array md1
>> Oct 21 18:43:55 mother kernel: [190018.093910] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
>> Oct 21 18:43:55 mother kernel: [190018.114765] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for requested-resync.
>> Oct 21 18:43:55 mother kernel: [190018.136459] md: using 128k window, over a total of 2096064k.
>> Oct 21 18:45:11 mother kernel: [190094.091974] ata6.00: exception Emask 0x0 SAct 0xf SErr 0x0 action 0x0
>> Oct 21 18:45:11 mother kernel: [190094.114093] ata6.00: irq_stat 0x40000008
>> Oct 21 18:45:11 mother kernel: [190094.135906] ata6.00: failed command: READ FPDMA QUEUED
>> Oct 21 18:45:11 mother kernel: [190094.157710] ata6.00: cmd 60/00:00:00:3b:3e/04:00:00:00:00/40 tag 0 ncq 524288 in
>> Oct 21 18:45:11 mother kernel: [190094.157710]          res 41/40:00:29:3e:3e/00:00:00:00:00/40 Emask 0x409 (media error) <F>
>> Oct 21 18:45:11 mother kernel: [190094.202315] ata6.00: status: { DRDY ERR }
>> Oct 21 18:45:11 mother kernel: [190094.224517] ata6.00: error: { UNC }
>> Oct 21 18:45:11 mother kernel: [190094.248920] ata6.00: configured for UDMA/133
>> Oct 21 18:45:11 mother kernel: [190094.271003] sd 5:0:0:0: [sdc] Unhandled sense code
>> Oct 21 18:45:11 mother kernel: [190094.293044] sd 5:0:0:0: [sdc]
>> Oct 21 18:45:11 mother kernel: [190094.314654] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> Oct 21 18:45:11 mother kernel: [190094.336483] sd 5:0:0:0: [sdc]
>> Oct 21 18:45:11 mother kernel: [190094.357966] Sense Key : Medium Error [current] [descriptor]
>> Oct 21 18:45:11 mother kernel: [190094.379808] Descriptor sense data with sense descriptors (in hex):
>> Oct 21 18:45:11 mother kernel: [190094.402024]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
>> Oct 21 18:45:11 mother kernel: [190094.424502]         00 3e 3e 29
>> Oct 21 18:45:11 mother kernel: [190094.446338] sd 5:0:0:0: [sdc]
>> Oct 21 18:45:11 mother kernel: [190094.467995] Add. Sense: Unrecovered read error - auto reallocate failed
>> Oct 21 18:45:11 mother kernel: [190094.490075] sd 5:0:0:0: [sdc] CDB:
>> Oct 21 18:45:11 mother kernel: [190094.511870] Read(10): 28 00 00 3e 3b 00 00 04 00 00
>> Oct 21 18:45:11 mother kernel: [190094.533829] end_request: I/O error, dev sdc, sector 4079145
>> Oct 21 18:45:11 mother kernel: [190094.555800] ata6: EH complete
>> Oct 21 18:45:22 mother kernel: [190105.602687] md: md1: requested-resync done.
>>
>> There's no indication that raid code tried to re-write the bad spot,
>> and the bad block remains bad in the drive, so next read (direct from
>> the drive) return the same I/O error with the same kernel messages.
>>
>> Shouldn't `repair' action re-write the problem place?
>
> Yes it should.
> When end_sync_read() notices that BIO_UPTODATE isn't set it refuses to set
> R1BIO_Uptodate.
> When sync_request_write() notices that isn't set it calls
> fix_sync_read_error().
>
> fix_sync_read_error then calls sync_page_io() for each page in the region and
> if that fails (as you would expect, it goes on to the next disk and the next
> until a working one is found.  Then that block is written back to all those
> that failed.
> fix_sync_read_error doesn't report any success, but as it re-read the failing
> device you should see the SCSI read error reported a second time at least.

I see.  I thought it should too... ;)

> Are you able to add some tracing and recompile the kernel and see if you can
> find out what is happening?

Yes that's okay, except that before your reply, I did an experiment - I removed
the "bad" drive from the array, zeroed the superblock (to force full resync) and
added it back, so whole thing were re-written.  And this time, all bad block
were successfully reallocated.

So I don't have the testcase anymore.  Which is a very bad thing actually, because
something is definitely not right there and I'd really like to find and fix it...
Oh well.

I'll watch it, and sure will try to find out what's going on, but I still hope
there will be no new bad sectors... ;)

Thanks,

/mjt
