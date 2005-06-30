From: "Dinesh" <dinesh@asacomputers.com>
Subject: Re: linux-raid compatable w/ Adaptec AIC-7902?
Date: Thu, 30 Jun 2005 08:51:49 -0700
Message-ID: <001801c57d8b$a0cbe3d0$1800a8c0@concard>
References: <200506291538.03233.eric@pretorious.net> <200506291738.30516.eric@pretorious.net> <200506291808.54549.eric@pretorious.net>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: eric@pretorious.net, linux-raid@vger.kernel.org
Cc: Mike V <mike@asacomputers.com>, tech@asacomputers.com
List-Id: linux-raid.ids

Hello Eric,
>>SCSI disk error : host 0 channel 0 id 0 lun 0 return code = 10000
>>I/O error: dev 08:07, sector 2980224
>>raid1: disk failure on sda7, disabling device.
>> Operation continuing on 1 devices
>>raid1: mirro resync was not fully finished, restarting next time.
>>md4: no spare disk to reconstruct array! -- continuing in degraded mode
>>md: md_do_sync() got signal ... exiting

From messages above it clearly says that sda7 is bad. so remove sda7 and put 
the new disk in and rebuild RAID. RAID will rebuild in background so you 
will feel a little bit slow response from the system. Once it finished RAID, 
system comes back to normal.

> I expected that a mirror would be more robust than to bring-down the 
> entire
> system when one RAID member fails. Was this assumption incorrect?

You don't need bring down system when one RAID member fails. Just replace 
the faulty one with new one.

Thanks
Dinesh 


