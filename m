From: Mark Lord <liml@rtr.ca>
Subject: Re: Linux Software RAID is really RAID?
Date: Tue, 03 Jul 2007 19:08:56 -0400
Message-ID: <468AD708.2010806@rtr.ca>
References: <cd98e0260706261043t32fe6609ye1e4e252c722358c@mail.gmail.com>	 <46815C3F.6090204@wasp.net.au> <468A05A4.60006@gmail.com> <cd98e0260707030517y1fbb60ban29063439f2665834@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <cd98e0260707030517y1fbb60ban29063439f2665834@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Johny Mail list <maillist.johny@gmail.com>
Cc: Tejun Heo <htejun@gmail.com>, Brad Campbell <brad@wasp.net.au>, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

Johny Mail list wrote:
> 2007/7/3, Tejun Heo <htejun@gmail.com>:
>> Brad Campbell wrote:
>> > Johny Mail list wrote:
>> >> Hello list,
>> >> I have a little question about software RAID on Linux.
>> >> I have installed Software Raid on all my SC1425 servers DELL by
>> >> believing that the md raid was a strong driver.
>> >> And recently i make some test on a server and try to view if the RAID
>> >> hard drive power failure work fine, so i power up my server and after
>> >> booting and the prompt appear I disconnected the power cable of my
>> >> SATA hard drive. Normaly the MD should eleminate the failure hard
>> >> drive of the logical drive it build, and the server continue to work
>> >> fine like nothing happen. Oddly the server stop to respond and i get
>> >> this messages :
>> >> ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
>> >> ata4.00: cmd e7/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0
>> >>              res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
>> (timeout)
>> >> ata4: port is slow to respond, please be patient (Status 0xd0)
>> >> ata4: port failed to respond (30sec, Status 0xd0)
>> >> ata4: soft resetting port
>> >>
>> >> After that my system is frozen.
>>
>> How hard is it frozen?  Can you blink the Numlock LED?

I believe he said it was ICH5 (different post/thread).

My observation on ICH5 is that if one unplugs a drive,
then the chipset/cpu locks up hard when toggling SRST
in the EH code.

Specifically, it locks up at the instruction
which restores SRST back to the non-asserted state,
which likely corresponds to the chipset finally actually
sending a FIS to the drive.

A hard(ware) lockup, not software.
That's why Intel says ICH5 doesn't do hotplug.

Cheers
