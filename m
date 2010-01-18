From: Neil Brown <neilb@suse.de>
Subject: Re: No resync
Date: Mon, 18 Jan 2010 16:48:31 +1300
Message-ID: <20100118164831.48fca98f@notabene>
References: <C6.49.19471.1200C4B4@cdptpa-omtalb.mail.rr.com>
	<4B4C0162.5040807@sauce.co.nz>
	<20100112083753.GA9891@cthulhu.home.robinhill.me.uk>
	<4B4CBF08.30700@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B4CBF08.30700@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 13 Jan 2010 07:27:20 +1300
Richard Scobie <richard@sauce.co.nz> wrote:

> Robin Hill wrote:
> 
> > You probably need to start it with missing members then, so it's able to
> > run but not to resync.
> 
> This is not an option in assemble mode either. It looks as though the 
> array has to be recreated. I'm not sure why any of these options are not 
> provided for assemble.
> 
> Anyway, in the end I did an "assemble --force" after stopping what was 
> left (5 drives dropped from a 16 drive RAID6), and it strated but did 
> not initiate a resync.

This is what I would expect.  When mdadm need to "fix" the array to get it to
assemble, it does the minimum work necessary to get the data available.  That
means that it normally won't add any 'redundant' data so no resync will
happen. (RAID10 is a bit of an exception for complex reasons that I don't
want to go in to at the moment).

> 
> Perhaps the behaviour here has changed, because I'm sure when I've done 
> this in the past, it resyncs straight away.

I would be surprised... (but that does happen).

> 
> There were some somewhat strange errors in the log:
> 
> Jan 12 17:09:09 sam kernel: end_request: I/O error, dev sdf, sector 
> 1953182527
> Jan 12 17:09:09 sam kernel: md: super_written gets error=-5, uptodate=0
> Jan 12 17:09:09 sam kernel: raid5: Disk failure on sdf1, disabling device.
> Jan 12 17:09:09 sam kernel: raid5: Operation continuing on 15 devices.
> Jan 12 17:09:09 sam kernel: end_request: I/O error, dev sdh, sector 
> 1953182527
> Jan 12 17:09:09 sam kernel: md: super_written gets error=-5, uptodate=0
> Jan 12 17:09:09 sam kernel: raid5: Disk failure on sdh1, disabling device.
> Jan 12 17:09:09 sam kernel: raid5: Operation continuing on 14 devices.
> Jan 12 17:09:09 sam kernel: end_request: I/O error, dev sdg, sector 
> 1953182527
> Jan 12 17:09:09 sam kernel: md: super_written gets error=-5, uptodate=0
> Jan 12 17:09:09 sam kernel: raid5: Disk failure on sdg1, disabling device.
> Jan 12 17:09:09 sam kernel: raid5: Operation continuing on 13 devices.
> Jan 12 17:09:09 sam kernel: end_request: I/O error, dev sdp, sector 
> 1953182527
> Jan 12 17:09:09 sam kernel: md: super_written gets error=-5, uptodate=0
> Jan 12 17:09:09 sam kernel: raid5: Disk failure on sdp1, disabling device.
> Jan 12 17:09:09 sam kernel: raid5: Operation continuing on 12 devices.
> Jan 12 17:09:09 sam kernel: end_request: I/O error, dev sdr, sector 
> 1953182527
> Jan 12 17:09:09 sam kernel: md: super_written gets error=-5, uptodate=0
> Jan 12 17:09:09 sam kernel: raid5: Disk failure on sdr1, disabling device.
> Jan 12 17:09:09 sam kernel: raid5: Operation continuing on 11 devices.
> 
> The cause is a controller problem, but after the first 2 drives were 
> disabled, I don't know why there were "raid5: Operation continuing 
> on..." messages as another 3 drives were offlined. A RAID6 array should 
> stop when a third device fails.

Yes it should .... I really should tidy that code up.

NeilBrown


> 
> Regards,
> 
> Richard
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

