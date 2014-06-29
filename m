From: Chris Murphy <lists@colorremedies.com>
Subject: Re: writing zeros to bad sector results in persistent read error
Date: Sat, 28 Jun 2014 18:05:29 -0600
Message-ID: <6C47950B-13E8-479C-BC3B-C21C379A95FB@colorremedies.com>
References: <B7EA34DA-1064-45B1-B0C0-B7C423C7EB47@colorremedies.com> <20140607075140.277c0880@natsu> <0E76B97E-96DF-43A3-B8EC-4867964BF8E9@colorremedies.com> <20140609193723.79F1B3809B0@gemini.denx.de> <19559C36-08B4-4C2F-ABC3-9DE79BE37B54@colorremedies.com> <53970ACE.6080001@turmel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53970ACE.6080001@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Wolfgang Denk <wd@denx.de>, Roman Mamedov <rm@romanrm.net>, "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Jun 10, 2014, at 7:40 AM, Phil Turmel <philip@turmel.org> wrote:

> On 06/09/2014 10:48 PM, Chris Murphy wrote:
>> 
>> On Jun 9, 2014, at 1:37 PM, Wolfgang Denk <wd@denx.de> wrote:
>> 
>>> Dear Chris,
>>> 
>>> In message
>>> <0E76B97E-96DF-43A3-B8EC-4867964BF8E9@colorremedies.com> you
>>> wrote:
>>>> 
>>>> # dd if=/dev/zero of=/dev/sda seek=430234064 count=8 oflag=direct
>>>> 8+0 records in 8+0 records out 4096 bytes (4.1 kB) copied,
>>>> 3.73824 s, 1.1 kB/s
>>> 
>>> This has been pointed out before - if this is a 4k sector drive, 
>>> then you should really write in units of 4 k, not 8 x 512 bytes as 
>>> you do here.
>> 
>> It worked so, why?
> 
> Because writing 512 bytes into a 4096 byte physical sector requires a
> read-modify-write cycle.  That will fail if the physical sector is
> unreadable.  If you try to overwrite a bad 4k sector with eight 512-byte
> writes, each will trigger an RMW, and the 'R' of the RMW will fail for
> all eight logical sectors.  If you tell dd to use a block size of 4k, a
> single write will be created and passed to the drive encompassing all
> eight logical sectors at once.  So the drive doesn't need an RMW
> cycle--a write attempt can be made without the preceding read.  Then the
> drive has the opportunity to complete its rewrite or remap logic.

By doing some SCSI command tracing with the kernel, I've learned some things about this. Whether the drive has 512 byte or 4096 byte sectors has no bearing on the actual command issued to the drive. But the use of oflag=direct does change the behavior at the SCSI layer (for both drive types).

http://www.fpaste.org/114087/
[1]

The following commands all produce the same single write command to both types of drives:

# dd if=/dev/zero of=/dev/sdb bs=512 count=8
# dd if=/dev/zero of=/dev/sdb bs=4096 count=1
# dd if=/dev/zero of=/dev/sdb bs=4096 count=1 oflag=direct

The SCSI layer is clearly combining the bs=512 count=8 into a single write command. This is inhibited with oflag=direct.

I also found intermittent issuance of READ_10 to the drive, before WRITE_10, but wasn't able to figure out why it's intermittant. Maybe dd issues READ_10 the first time it's going to write to sector, and it was the READ_10 command triggering the read failure from the drive, preventing the WRITE_10 from even being issued. I can't test this because the drive no longer reports LBAs for any bad sectors.

> 
>> The drive interface only accepts LBAs based on 512 byte sectors, so 
>> bs=512 count=8 is the same as bs=4096 count=1, it has to get
>> translated into 512 byte LBAs regardless.
> 
> The sector address does have to be translated to 512-byte LBAs.  That
> has nothing to do with the *size* of each write.  So *NO*, it is *not*
> the same.

These two dd commands definitely result in the same write command for the same size (txlen=8) to the drive being issued by the SCSI layer:
# dd if=/dev/zero of=/dev/sdb bs=512 count=8
# dd if=/dev/zero of=/dev/sdb bs=4096 count=1


> "dd" is a terrible tool, except when it is perfect.  As a general rule,
> if you aren't specifying 'bs=' every time you use it, you've messed up.

I get the same WRITE_10 command for these two commands:

# dd if=/dev/zero of=/dev/sdb count=8
# dd if=/dev/zero of=/dev/sdb bs=4096 count=1

> And if you specify 'direct', remember that each block sized read or
> write issued by dd will have to *complete* through the whole driver
> stack before dd will issue the next one.

That's consistent with the tracing results.


> 
>> If it were a 4096 byte logical sector drive I'd agree.
> 
> You do know that drives are physically incapable of writing partial
> sectors?  It has to be emulated, either in drive firmware or OS driver
> stack.  What you've written suggests you've missed that basic reality.
> The rest is operator error.  Roman and Wolfgang were too polite when
> pointing out the need for bs=4096 -- it isn't 'should', it is 'must'.

That's true for oflag=direct, it's not true without it.

Also included for interest is the result of issue an hdparm write command. It works without a size specification, so I don't actually know what happens on the drive itself, plus the command that gets issued to the drive isn't "WRITE_10" but "ATA_16".


> As for the secure erase, I too am surprised that it didn't take care of
> pending errors.  But I am *not* surprised that that new errors were
> discovered shortly after, as pending errors are only ever discovered
> when *reading*.

SMART read the whole drive and said no errors found, even though current pending still reports a non-zero value. I think that is surprising.


Chris Murphy




[1]
Formats better in fpaste once clicking on Wrap. But I'll post the raw data here in case someone looks at this more than a month from now.
512/512

# dd if=/dev/zero of=/dev/sdb bs=512 count=8
              dd-891   [000] ....   550.352639: scsi_dispatch_cmd_start: host_no=1 channel=0 id=0 lun=0 data_sgl=1 prot_sgl=0 prot_op=SCSI_PROT_NORMAL cmnd=(WRITE_10 lba=0 txlen=8 protect=0 raw=2a 00 00 00 00 00 00 00 08 00)
              
# dd if=/dev/zero of=/dev/sdb bs=4096 count=1
              dd-894   [000] ....   566.506562: scsi_dispatch_cmd_start: host_no=1 channel=0 id=0 lun=0 data_sgl=1 prot_sgl=0 prot_op=SCSI_PROT_NORMAL cmnd=(WRITE_10 lba=0 txlen=8 protect=0 raw=2a 00 00 00 00 00 00 00 08 00)
            
# dd if=/dev/zero of=/dev/sdb bs=512 count=8 oflag=direct
              dd-1042  [000] .... 10261.418019: scsi_dispatch_cmd_start: host_no=1 channel=0 id=0 lun=0 data_sgl=1 prot_sgl=0 prot_op=SCSI_PROT_NORMAL cmnd=(WRITE_10 lba=0 txlen=1 protect=0 raw=2a 00 00 00 00 00 00 00 01 00)
              dd-1042  [000] .... 10261.418294: scsi_dispatch_cmd_start: host_no=1 channel=0 id=0 lun=0 data_sgl=1 prot_sgl=0 prot_op=SCSI_PROT_NORMAL cmnd=(WRITE_10 lba=1 txlen=1 protect=0 raw=2a 00 00 00 00 01 00 00 01 00)
              dd-1042  [000] .... 10261.418650: scsi_dispatch_cmd_start: host_no=1 channel=0 id=0 lun=0 data_sgl=1 prot_sgl=0 prot_op=SCSI_PROT_NORMAL cmnd=(WRITE_10 lba=2 txlen=1 protect=0 raw=2a 00 00 00 00 02 00 00 01 00)
              dd-1042  [000] .... 10261.419006: scsi_dispatch_cmd_start: host_no=1 channel=0 id=0 lun=0 data_sgl=1 prot_sgl=0 prot_op=SCSI_PROT_NORMAL cmnd=(WRITE_10 lba=3 txlen=1 protect=0 raw=2a 00 00 00 00 03 00 00 01 00)
              dd-1042  [000] .... 10261.419203: scsi_dispatch_cmd_start: host_no=1 channel=0 id=0 lun=0 data_sgl=1 prot_sgl=0 prot_op=SCSI_PROT_NORMAL cmnd=(WRITE_10 lba=4 txlen=1 protect=0 raw=2a 00 00 00 00 04 00 00 01 00)
              dd-1042  [000] .... 10261.419365: scsi_dispatch_cmd_start: host_no=1 channel=0 id=0 lun=0 data_sgl=1 prot_sgl=0 prot_op=SCSI_PROT_NORMAL cmnd=(WRITE_10 lba=5 txlen=1 protect=0 raw=2a 00 00 00 00 05 00 00 01 00)
              dd-1042  [000] .... 10261.419527: scsi_dispatch_cmd_start: host_no=1 channel=0 id=0 lun=0 data_sgl=1 prot_sgl=0 prot_op=SCSI_PROT_NORMAL cmnd=(WRITE_10 lba=6 txlen=1 protect=0 raw=2a 00 00 00 00 06 00 00 01 00)
              dd-1042  [000] .... 10261.419766: scsi_dispatch_cmd_start: host_no=1 channel=0 id=0 lun=0 data_sgl=1 prot_sgl=0 prot_op=SCSI_PROT_NORMAL cmnd=(WRITE_10 lba=7 txlen=1 protect=0 raw=2a 00 00 00 00 07 00 00 01 00)

# dd if=/dev/zero of=/dev/sdb bs=4096 count=1 oflag=direct
              dd-1045  [001] .... 10337.899923: scsi_dispatch_cmd_start: host_no=1 channel=0 id=0 lun=0 data_sgl=1 prot_sgl=0 prot_op=SCSI_PROT_NORMAL cmnd=(WRITE_10 lba=0 txlen=8 protect=0 raw=2a 00 00 00 00 00 00 00 08 00)


512/4096

# dd if=/dev/zero of=/dev/sdb bs=512 count=8

              dd-1814  [002] ...1   530.285126: scsi_dispatch_cmd_start: host_no=0 channel=0 id=0 lun=0 data_sgl=1 prot_sgl=0 prot_op=SCSI_PROT_NORMAL cmnd=(WRITE_10 lba=431467112 txlen=8 protect=0 raw=2a 00 19 b7 aa 68 00 00 08 00)

# dd if=/dev/zero of=/dev/sdb bs=4096 count=1

              dd-1881  [002] ...1  1094.707870: scsi_dispatch_cmd_start: host_no=0 channel=0 id=0 lun=0 data_sgl=1 prot_sgl=0 prot_op=SCSI_PROT_NORMAL cmnd=(WRITE_10 lba=431467112 txlen=8 protect=0 raw=2a 00 19 b7 aa 68 00 00 08 00)


# dd if=/dev/zero of=/dev/sdb bs=512 count=8 oflag=direct

              dd-1890  [003] ...1  1255.136864: scsi_dispatch_cmd_start: host_no=0 channel=0 id=0 lun=0 data_sgl=1 prot_sgl=0 prot_op=SCSI_PROT_NORMAL cmnd=(WRITE_10 lba=431467112 txlen=1 protect=0 raw=2a 00 19 b7 aa 68 00 00 01 00)
              dd-1890  [002] ...1  1255.422802: scsi_dispatch_cmd_start: host_no=0 channel=0 id=0 lun=0 data_sgl=1 prot_sgl=0 prot_op=SCSI_PROT_NORMAL cmnd=(WRITE_10 lba=431467113 txlen=1 protect=0 raw=2a 00 19 b7 aa 69 00 00 01 00)
              dd-1890  [002] ...1  1255.423167: scsi_dispatch_cmd_start: host_no=0 channel=0 id=0 lun=0 data_sgl=1 prot_sgl=0 prot_op=SCSI_PROT_NORMAL cmnd=(WRITE_10 lba=431467114 txlen=1 protect=0 raw=2a 00 19 b7 aa 6a 00 00 01 00)
              dd-1890  [002] ...1  1255.423386: scsi_dispatch_cmd_start: host_no=0 channel=0 id=0 lun=0 data_sgl=1 prot_sgl=0 prot_op=SCSI_PROT_NORMAL cmnd=(WRITE_10 lba=431467115 txlen=1 protect=0 raw=2a 00 19 b7 aa 6b 00 00 01 00)
              dd-1890  [000] ...1  1255.423625: scsi_dispatch_cmd_start: host_no=0 channel=0 id=0 lun=0 data_sgl=1 prot_sgl=0 prot_op=SCSI_PROT_NORMAL cmnd=(WRITE_10 lba=431467116 txlen=1 protect=0 raw=2a 00 19 b7 aa 6c 00 00 01 00)
              dd-1890  [002] ...1  1255.423921: scsi_dispatch_cmd_start: host_no=0 channel=0 id=0 lun=0 data_sgl=1 prot_sgl=0 prot_op=SCSI_PROT_NORMAL cmnd=(WRITE_10 lba=431467117 txlen=1 protect=0 raw=2a 00 19 b7 aa 6d 00 00 01 00)
              dd-1890  [002] ...1  1255.424110: scsi_dispatch_cmd_start: host_no=0 channel=0 id=0 lun=0 data_sgl=1 prot_sgl=0 prot_op=SCSI_PROT_NORMAL cmnd=(WRITE_10 lba=431467118 txlen=1 protect=0 raw=2a 00 19 b7 aa 6e 00 00 01 00)
              dd-1890  [002] ...1  1255.424309: scsi_dispatch_cmd_start: host_no=0 channel=0 id=0 lun=0 data_sgl=1 prot_sgl=0 prot_op=SCSI_PROT_NORMAL cmnd=(WRITE_10 lba=431467119 txlen=1 protect=0 raw=2a 00 19 b7 aa 6f 00 00 01 00)

# dd if=/dev/zero of=/dev/sdb bs=4096 count=1 oflag=direct

              dd-1895  [002] ...1  1388.656777: scsi_dispatch_cmd_start: host_no=0 channel=0 id=0 lun=0 data_sgl=1 prot_sgl=0 prot_op=SCSI_PROT_NORMAL cmnd=(WRITE_10 lba=431467112 txlen=8 protect=0 raw=2a 00 19 b7 aa 68 00 00 08 00)