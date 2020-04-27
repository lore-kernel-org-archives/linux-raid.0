From: Phil Turmel <philip@turmel.org>
Subject: Re: Hard Drive Partition Table shows partition larger than drive
Date: Mon, 27 Apr 2020 13:54:27 -0400
Message-ID: <991449ea-82e8-8f80-d73c-ad9701cf2d88@turmel.org>
References: <6ee9392d-8867-f0b5-193e-17a516bb7e0e@steinmetznet.com>
 <5EA5ED5D.8060006@youngman.org.uk>
 <c3b5d1be-3ee6-303e-63f5-51faf2053f63@steinmetznet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c3b5d1be-3ee6-303e-63f5-51faf2053f63@steinmetznet.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Robert Steinmetz <rob@steinmetznet.com>, Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/27/20 10:40 AM, Robert Steinmetz wrote:
> On 4/26/20 4:21 PM, Wols Lists wrote:
>> Run lsdrv over the drive and see what that reports.
>> https://raid.wiki.kernel.org/index.php/Asking_for_help
>>
>> If you post that here, hopefully somebody can help you reconstruct
>> whatever was there.
>>
>> Cheers,
>> Wol
> 
> here is the output of lsdrv for the drive.
> 
> USB [usb-storage] Bus 001 Device 002: ID 152d:2338 JMicron Technology 
> Corp. / JMicron USA Technology Corp. JM20337 Hi-Speed USB to SATA & PATA 
> Combo Bridge {000000000005}
> └scsi 4:0:0:0 TOSHIBA  HDWD110          {585T7P6NS}
>   └sdb 931.51g [8:16] Partitioned (dos)
                                     ^^^^^
There's your answer.  This drive is using a dos partition table, not 
GPT.  But there's some info where the GPT would be that is confusing parted.

>    └sdb1 931.51g [8:17] Empty/Unknown

As you can see, this partition entry is rational.

Try displaying the partition table with fdisk instead of parted.

Phil
