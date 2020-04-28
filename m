From: Robert Steinmetz <rob@steinmetznet.com>
Subject: Re: Hard Drive Partition Table shows partition larger than drive
Date: Tue, 28 Apr 2020 10:28:38 -0400
Message-ID: <c2c0bdf0-ebff-d52f-8f76-9fe3af3d58bb@steinmetznet.com>
References: <6ee9392d-8867-f0b5-193e-17a516bb7e0e@steinmetznet.com>
 <5EA5ED5D.8060006@youngman.org.uk>
 <c3b5d1be-3ee6-303e-63f5-51faf2053f63@steinmetznet.com>
 <991449ea-82e8-8f80-d73c-ad9701cf2d88@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <991449ea-82e8-8f80-d73c-ad9701cf2d88@turmel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/27/20 1:54 PM, Phil Turmel wrote:
> here is the output of lsdrv for the drive.
>>
>> USB [usb-storage] Bus 001 Device 002: ID 152d:2338 JMicron Technology 
>> Corp. / JMicron USA Technology Corp. JM20337 Hi-Speed USB to SATA & 
>> PATA Combo Bridge {000000000005}
>> └scsi 4:0:0:0 TOSHIBA  HDWD110          {585T7P6NS}
>>   └sdb 931.51g [8:16] Partitioned (dos)
>                                     ^^^^^
> There's your answer.  This drive is using a dos partition table, not 
> GPT.  But there's some info where the GPT would be that is confusing 
> parted.
>
>>    └sdb1 931.51g [8:17] Empty/Unknown
>
> As you can see, this partition entry is rational.
>
> Try displaying the partition table with fdisk instead of parted.

Here is what fdisk says:

Disk /dev/sdb: 931.5 GiB, 1000204886016 bytes, 244190646 sectors
Units: sectors of 1 * 4096 = 4096 bytes
Sector size (logical/physical): 4096 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: dos
Disk identifier: 0x19e6cd02

Device     Boot Start        End    Sectors  Size Id Type
/dev/sdb1  *     2048 1953523711 1953521664  7.3T fd Linux raid autodetect

Note the discrepancy between the disk size and the partition size.

It seems the end sector for partition /dev/sdb1 is incorrect and should 
be 244190646 or 244190645 depending on how sectors are numberd that is 
if there is a sector 0 or it starts at 1.

-- 

Rob
