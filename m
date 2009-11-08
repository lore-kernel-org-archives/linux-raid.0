From: Joe Landman <landman@scalableinformatics.com>
Subject: Re: RAID 6 Failure follow up
Date: Sun, 08 Nov 2009 13:34:05 -0500
Message-ID: <4AF70F1D.4010604@scalableinformatics.com>
References: <4AF6D0A9.6000901@gmail.com> <4AF6D461.3050109@gmail.com> <4AF6D5FD.2010602@gmail.com> <4AF70791.9080007@sauce.co.nz> <4AF70C61.5030301@gmail.com>
Reply-To: landman@scalableinformatics.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF70C61.5030301@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Dunn <andrew.g.dunn@gmail.com>
Cc: Richard Scobie <richard@sauce.co.nz>, Roger Heflin <rogerheflin@gmail.com>, robin@robinhill.me.uk, linux-raid list <linux-raid@vger.kernel.org>, nfbrown@novell.com
List-Id: linux-raid.ids

Andrew Dunn wrote:
> New data now, I got this from dmesg when it went down again. Hopefully
> there is some significance to you guys.
> 
>> [14269.650381] sd 10:0:3:0: rejecting I/O to offline device
>> [14269.650453] sd 10:0:3:0: rejecting I/O to offline device
>> [14269.650524] sd 10:0:3:0: rejecting I/O to offline device
>> [14269.650595] sd 10:0:3:0: rejecting I/O to offline device
>> [14269.650672] sd 10:0:3:0: [sdh] Unhandled error code
>> [14269.650675] sd 10:0:3:0: [sdh] Result: hostbyte=DID_NO_CONNECT
> driverbyte=DRIVER_OK
>> [14269.650680] end_request: I/O error, dev sdh, sector 1435085631
>> [14269.650749] raid5:md0: read error not correctable (sector
> 1435085568 on sdh1).
>> [14269.650753] raid5: Disk failure on sdh1, disabling device.
>> [14269.650754] raid5: Operation continuing on 7 devices.
>> [14269.650886] raid5:md0: read error not correctable (sector
> 1435085576 on sdh1).
>> [14269.650890] raid5:md0: read error not correctable (sector
> 1435085584 on sdh1).
>> [14269.650894] raid5:md0: read error not correctable (sector
> 1435085592 on sdh1).

[...]

I am not convinced this is a drive failure (yet).  You have 
sdh,sdi,sdj,sdk,sdl,sdm all reporting errors or error recovery.

This sounds like a physical backplane failure (is this on an expander 
system? we have seen this/had this happen before), a cable to the SATA 
card failing (we have seen this/had this happen before), or a power 
supply issue (can't handle all the drives in constant operation, which 
we have seen before as well).

Driver issues are possible, but it is pursuing normal failure code 
paths, so unless the driver is tickling the remove code on its own ...

Smart could be offlining the drive, and having it non-responsive. 
Something else could be doing that as well (vibration, power quality, ...)

What does

	hdparm -I /dev/sdh

tell us?

If nothing, we need to use sdparm to get some information.

Joe

-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics, Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/jackrabbit
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615
