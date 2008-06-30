From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Software RAID1 deadlock in 2.6.25 kernels
Date: Mon, 30 Jun 2008 09:32:00 -0400
Message-ID: <4868E050.7090904@tmr.com>
References: <48650567.3000501@w1nr.net> <18533.20961.694041.556763@notabene.brown> <20080630092348.GJ17557@boogie.lpds.sztaki.hu> <4868C410.2060005@w1nr.net> <20080630115926.GA31564@ruf099.fkie.fgan.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080630115926.GA31564@ruf099.fkie.fgan.de>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Bussmann <bus@mb-net.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Bussmann wrote:
> Hi,
>
> On 2008-06-30 07:31:28 -0400, Mike McCarthy wrote:
>   
>>>>>    System locks up after running a short time.  Had it hang once 
>>>>> during installation.  Tried both Reiserfs and EXT3.
>>>>>           
>
>   
>> When the system hangs, the mouse movement is tracked across the screen  
>> and I can ping the node. There is no response to clicking on a mouse  
>> button or trying to type anything into a field. It also does not respond  
>> to ssh or to <CTRL><ALT><F1>.
>>     
>
> Maybe it's a totally different issue, but I also noticed system lockups,
> that started after I converted the system to Software-RAID1.  However, in
> my case the lockups only occur after 3-10 days uptime.  One day I was able
> to capture a couple of syslog entries:
>
> | Jun 12 09:50:47 tardis kernel: hdg: lost interrupt
> | Jun 12 09:50:47 tardis kernel: hdg: drive_cmd: status=0x51 { DriveReady SeekComplete Error }
> | Jun 12 09:50:47 tardis kernel: hdg: drive_cmd: error=0x04 { DriveStatusError }
> | Jun 12 09:50:47 tardis kernel: ide: failed opcode was: 0xb0
> | Jun 12 09:51:07 tardis kernel: hdg: dma_timer_expiry: dma status == 0x21
> | (2 x WD2500SB-01RFA0 on a PDC20276 (MBFastTrak133))
>
> The HDD LED is permanently on.
>   

Wonder if hardware or software is happening, sounds like an mishandled 
hardware error, but I'm guessing. I have a server with RAID1 and Fedora 
2.6.22.14-72.fc6PAE kernel, up 72 days, no problems.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


