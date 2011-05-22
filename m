From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: HBA Adaptor advice
Date: Sun, 22 May 2011 18:09:23 +0800
Message-ID: <4DD8E0D3.1030905@fnarfbargle.com>
References: <4DD50C89.8060006@wildgooses.com> <20110520020853.GC4759@bitfolk.com> <4DD61948.8050302@wildgooses.com> <4DD6409F.9070904@hardwarefreak.com> <4DD79F4E.7000509@wildgooses.com> <4DD8D1A7.1090803@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD8D1A7.1090803@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 22/05/11 17:04, Stan Hoeppner wrote:

> WD's Green drives have a 5400 rpm 'variable' spindle speed.  The Seagate
> 2.5" SAS drive has a 7.2k spindle speed.

Actually, I'm pretty sure the WD drives have a 5400 rpm spindle speed 
period. I've got 15 of them here and I have no evidence of any form of 
spindle speed variation. They say the drives have spindle speed : 
"intellipower" which is marketspeak for slow enough to save a few watts, 
but fast enough to do the job.

> It's difficult to align partitions properly on the Green drives due to
> native 4K sectors translated by drive firmware to 512B sectors.  The
> Seagate SAS drive has native 512B sectors.

Actually it's not difficult at all. You just make sure all your 
partitions start on an even multiple of 8 sectors. No magic in it. Just 
the same as all my SSD partitions start on 512k boundaries.

> The Green drives have aggressive power saving firmware not suitable for
> business use as the heads are auto parked every 8 seconds or so.  IIRC
> the drive goes into sleep mode after a short period of inactivity on the
> host interface.  In short, these drives are designed optimally for the
> "is not running" case rather than the "running" case.  Hence the name
> "Green".  How do you save power?  Turn off the drive.  And that's
> exactly what these drives are designed to do.

You can turn off the aggressive head parking with a little DOS utility, 
and they don't go to sleep at all unless you tell them to. They will 
happily keep spinning just the same as any other disk.

I'm running them in a couple of large(ish) RAID arrays. I'm not saying 
it's a good idea, it's just been my experience with ultra-cheap drives 
that if you burn in the drives to weed out the early failures, and you 
keep them running 24/7 in a nice environment they tend to last long 
enough to do the job. I tend to replace my drives at around ~30,000 
hours, so these have a long way to go yet.

On the other hand, I have my company data on Seagate Cheetah SAS drives 
in RAID-10, but I back up to the large WD Green arrays.

