From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: new array not starting
Date: Wed, 08 Nov 2006 11:58:31 -0500
Message-ID: <45520CB7.5090807@tmr.com>
References: <eirdlc$l7j$1@sea.gmane.org> <eiredo$mmo$1@sea.gmane.org> <eirfst$pd7$1@sea.gmane.org> <eirgp8$rd7$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <eirgp8$rd7$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Bowes <robin-lists@robinbowes.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Robin Bowes wrote:

>Robin Bowes wrote:
>  
>
>>Robin Bowes wrote:
>>    
>>
>>>This worked:
>>>
>>># mdadm --assemble --auto=yes  /dev/md2 /dev/sdc /dev/sdd /dev/sde
>>>/dev/sdf /dev/sdg /dev/sdh /dev/sdi /dev/sdj
>>>mdadm: /dev/md2 has been started with 8 drives.
>>>
>>>However, I'm not sure why it didn't start automatically at boot. Do I
>>>need to put it in /etc/mdadm.conf for it to star automatically? I
>>>thought md start all arrays it found at a start up?
>>>      
>>>
>>OK, I put /dev/md2 in /etc/mdadm.conf and it didn't make any difference.
>>
>>This is mdadm.conf (uuids are on same line as ARRAY):
>>
>>DEVICE partitions
>>ARRAY /dev/md1 level=raid1 num-devices=2
>>uuid=300c1309:53d26470:64ac883f:2e3de671
>>ARRAY /dev/md0 level=raid1 num-devices=2
>>uuid=89649359:d89365a6:0192407d:e0e399a3
>>ARRAY /dev/md2 level=raid6 num-devices=8
>>UUID=68c2ea69:a30c3cb0:9af9f0b8:1300276b
>>
>>I saw an error fly by as the server was booting saying "/dev/md2 not found".
>>
>>Do I need to create this device manually?
>>    
>>
>
>Well, at the risk of having a complete conversation with myself, I've
>created partitions of type "fd" on each disk and re-created the array
>out of the partitions instead of the whole disk.
>
>mdadm --create /dev/md2 --auto=yes --raid-devices=8 --level=6 /dev/sdc1
>/dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1 /dev/sdi1 /dev/sdj1
>
>I'm hoping this will enable the array to be auto-detected and started at
>boot.
>  
>
I'm guessing that whole devices don't get scanned when "partitions" is 
used. There was a fix for incorrect partition tables being used on whole 
drives, and perhaps that makes the whole device get ignored, or perhaps 
it never worked. Perhaps there's an interaction with LVM, the more 
complex you make your setup the greater the chance for learning experiences.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

