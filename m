From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: No resync
Date: Wed, 13 Jan 2010 07:27:20 +1300
Message-ID: <4B4CBF08.30700@sauce.co.nz>
References: <C6.49.19471.1200C4B4@cdptpa-omtalb.mail.rr.com> <4B4C0162.5040807@sauce.co.nz> <20100112083753.GA9891@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100112083753.GA9891@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Robin Hill wrote:

> You probably need to start it with missing members then, so it's able to
> run but not to resync.

This is not an option in assemble mode either. It looks as though the 
array has to be recreated. I'm not sure why any of these options are not 
provided for assemble.

Anyway, in the end I did an "assemble --force" after stopping what was 
left (5 drives dropped from a 16 drive RAID6), and it strated but did 
not initiate a resync.

Perhaps the behaviour here has changed, because I'm sure when I've done 
this in the past, it resyncs straight away.

There were some somewhat strange errors in the log:

Jan 12 17:09:09 sam kernel: end_request: I/O error, dev sdf, sector 
1953182527
Jan 12 17:09:09 sam kernel: md: super_written gets error=-5, uptodate=0
Jan 12 17:09:09 sam kernel: raid5: Disk failure on sdf1, disabling device.
Jan 12 17:09:09 sam kernel: raid5: Operation continuing on 15 devices.
Jan 12 17:09:09 sam kernel: end_request: I/O error, dev sdh, sector 
1953182527
Jan 12 17:09:09 sam kernel: md: super_written gets error=-5, uptodate=0
Jan 12 17:09:09 sam kernel: raid5: Disk failure on sdh1, disabling device.
Jan 12 17:09:09 sam kernel: raid5: Operation continuing on 14 devices.
Jan 12 17:09:09 sam kernel: end_request: I/O error, dev sdg, sector 
1953182527
Jan 12 17:09:09 sam kernel: md: super_written gets error=-5, uptodate=0
Jan 12 17:09:09 sam kernel: raid5: Disk failure on sdg1, disabling device.
Jan 12 17:09:09 sam kernel: raid5: Operation continuing on 13 devices.
Jan 12 17:09:09 sam kernel: end_request: I/O error, dev sdp, sector 
1953182527
Jan 12 17:09:09 sam kernel: md: super_written gets error=-5, uptodate=0
Jan 12 17:09:09 sam kernel: raid5: Disk failure on sdp1, disabling device.
Jan 12 17:09:09 sam kernel: raid5: Operation continuing on 12 devices.
Jan 12 17:09:09 sam kernel: end_request: I/O error, dev sdr, sector 
1953182527
Jan 12 17:09:09 sam kernel: md: super_written gets error=-5, uptodate=0
Jan 12 17:09:09 sam kernel: raid5: Disk failure on sdr1, disabling device.
Jan 12 17:09:09 sam kernel: raid5: Operation continuing on 11 devices.

The cause is a controller problem, but after the first 2 drives were 
disabled, I don't know why there were "raid5: Operation continuing 
on..." messages as another 3 drives were offlined. A RAID6 array should 
stop when a third device fails.

Regards,

Richard
