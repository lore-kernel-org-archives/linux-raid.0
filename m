From: "David M. Strang" <dstrang@shellpower.net>
Subject: Re: raid5: Disk failure on sdm, disabling device
Date: Wed, 31 Aug 2005 17:05:43 -0400
Message-ID: <00ba01c5ae6f$c002a990$c100a8c0@NCNF5131FTH>
References: <003401c5ae61$d982b5d0$c100a8c0@NCNF5131FTH> <4316050B.1060805@tls.msk.ru> <005201c5ae63$ef23e6f0$c100a8c0@NCNF5131FTH> <43160DF2.6000504@tls.msk.ru>  <007401c5ae6a$7e9cd160$c100a8c0@NCNF5131FTH> <1125520778.3194.18.camel@x1-6-00-0d-60-fd-e8-4c> <008b01c5ae6c$e4db5e90$c100a8c0@NCNF5131FTH> <1125521616.3194.22.camel@x1-6-00-0d-60-fd-e8-4c> <00ab01c5ae6f$1bb27410$c100a8c0@NCNF5131FTH> <1125522122.3194.29.camel@x1-6-00-0d-60-fd-e8-4c>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Forrest Taylor <ftaylor@redhat.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>> Is there something a little deeper to this error message?
>>
>> Aug 31 04:48:15 abyss kernel: scsi2 (12:0): rejecting I/O to offline 
>> device
>> Aug 31 04:48:15 abyss kernel: raid5: Disk failure on sdm, disabling 
>> device.
>
>This error would make me think that the disk is bad.  Have you tested
>the disk, or replaced it with a known-good disk?

I have removed the disk from the enclosure, and replaced it with a spare --  
however; the disk remains disabled within the OS.

-- David 

