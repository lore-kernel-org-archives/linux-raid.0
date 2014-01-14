From: David Brown <david.brown@hesbynett.no>
Subject: Re: [RFC v2 0/2] New RAID library supporting up to six parities
Date: Tue, 14 Jan 2014 10:25:06 +0100
Message-ID: <52D50272.3000704@hesbynett.no>
References: <1389000716-3274-1-git-send-email-amadvance@gmail.com> <CAK2H+efOLtq6onYASnZ5DsghVMp5AN70fx_uN8Ha5Wr3RxKx3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK2H+efOLtq6onYASnZ5DsghVMp5AN70fx_uN8Ha5Wr3RxKx3A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>, Andrea Mazzoleni <amadvance@gmail.com>
Cc: Neil Brown <neilb@suse.de>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/01/14 19:13, Mark Knecht wrote:
> Andrea,
>    As others have said it looks interesting. Thanks for the efforts.
> 
>    Question: As an end-user type who currently uses mdadm RAID6, if I
> wanted to set up a dedicated machine to do some SnapRAID testing then
> what's the minimum disk hardware I'd need assuming Linux is just on
> it's own disk?
> 
> 1) 1 drive for Linux
> 2) 4 (or possibly 3) drives for a SnapRAID RAID6 device?
> 3) 3 drives for a SnapRAID RAID5 device? (If RAID5 can even use
> SnapRAID. Not sure it can)
> 
>    Are there any known issues using both mdadm and SnapRAID devices in
> the same system? Again, I don't care if there are and the machine dies
> a brutal death (which I doubt from your announcement) but just asking.
> 
> Cheers,
> Mark
> 

If you want to do testing (once there is mdadm support for making the
multi-raid devices), then an easy way is to make some big empty files on
an existing disk and set them up as loopback devices.  Then you can use
these "fake" drives for the arrays.  You can then test a 6+4 quad parity
array using 10 1G files rather than needing 10 physical drives, and you
can play with resyncing, fault testing (using the md "faulty" layout),
reshaping, etc.

Of course, you can't test real-world speed this way.  However, you /can/
test parity generation/recovery speeds nicely by putting the loopback
files in a tmpfs system in memory - that eliminates the hard disk speeds
and lets you do hard testing of the raid code.


