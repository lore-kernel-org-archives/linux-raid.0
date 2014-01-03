From: Joe Landman <joe.landman@gmail.com>
Subject: Re: The chunk size paradox
Date: Thu, 02 Jan 2014 22:09:47 -0500
Message-ID: <52C629FB.3030801@gmail.com>
References: <52C1C01A.7010407@ubuntu.com>	<52C57C7B.80400@shiftmail.org>	<52C588A7.6010207@hardwarefreak.com>	<52C59468.6080200@ubuntu.com>	<52C5A9AA.9090300@hardwarefreak.com>	<52C5BC28.2020003@gmail.com> <21189.62662.712801.352081@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <21189.62662.712801.352081@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg@lxraid2.for.sabi.co.UK>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 01/02/2014 06:22 PM, Peter Grandi wrote:
> [ ... ]
>
>> 512 byte sector native drives are now far less common,
>
> Most smaller/faster SAS drivers still have 512 physical sectors,
> but >= 2TB drives, especially those with < 7200RPM, tend to have
> 4KiB physical sectors (because 4KiB sector drives are cheaper).

There was a reason for the 512 byte sectors, and that has something to 
do with the extended integrity sector length you can use if you format 
your drives for this.  There are a fair number of these enterprise class 
drives which might not play well with translation firmware.  Its easier 
to keep producing these and gradually wean those customers off as they 
migrate to 12g scenarios.

>
>> with many of the drives being native 4096 bytes witnh a
>> translation layer for legacy systems that require 512 bytes.
>
> On a PC here I have half-and-half:
>
>    # lsscsi | grep sd.
>    [0:0:0:0]    disk    ATA      WDC WD2002FAEX-0 05.0  /dev/sda
>    [1:0:0:0]    disk    ATA      ST2000DM001-1CH1 CC44  /dev/sdb
>    [2:0:0:0]    disk    ATA      ST2000DM001-9YN1 CC4C  /dev/sdc
>    [3:0:0:0]    disk    ATA      Hitachi HDS72202 JKAO  /dev/sdd
>    [6:0:0:0]    disk    ATA      WDC WD20EARX-32P AB51  /dev/sde
>    [6:0:1:0]    disk    ATA      ST2000DL003-9VT1 CC32  /dev/sdf
>
>    # grep . /sys/block/sd?/queue/physical_block_size
>    /sys/block/sda/queue/physical_block_size:512
>    /sys/block/sdb/queue/physical_block_size:4096
>    /sys/block/sdc/queue/physical_block_size:4096
>    /sys/block/sdd/queue/physical_block_size:512
>    /sys/block/sde/queue/physical_block_size:4096
>    /sys/block/sdf/queue/physical_block_size:512

Yeah, depends upon which disks you use.  The HGST's we use annoyingly 
all register as 512, but the Seagate we use are now mostly 4k.

>
> They are all 2TB "consumer" drives, mostly recent ones. I am
> slightly surprised that half still have 512 physical sectors.

Some could be the translation layer ... I don't have evidence of this, 
but I am guessing that HGST is keeping the layer in place to minimize 
problems with old OSes.  Thats the entire purpose of that translation 
layer ... pay a slight performance price for compatibility.


