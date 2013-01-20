From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Suboptimal raid6 linear read speed
Date: Sun, 20 Jan 2013 22:09:00 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1301202155310.12098@uplift.swm.pp.se>
References: <20130115123301.GA11948@rabbit.us> <50F55046.7050605@turmel.org> <20130115125507.GA12184@rabbit.us> <50F614F7.20104@hardwarefreak.com> <20130116025857.GA31112@rabbit.us> <50F70DB7.6020104@hardwarefreak.com> <alpine.DEB.2.00.1301171648260.12098@uplift.swm.pp.se>
 <50F90857.3010305@hardwarefreak.com> <alpine.DEB.2.00.1301181015270.12098@uplift.swm.pp.se> <50F9D32F.7090606@hardwarefreak.com> <alpine.DEB.2.00.1301190838440.12098@uplift.swm.pp.se> <20732.17741.587765.199649@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20732.17741.587765.199649@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg@lxra2.for.sabi.co.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, 20 Jan 2013, Peter Grandi wrote:

> NB: while in general I think that most (euphemism) less informed
> people should use only RAID10, there are a few narrow cases where
> the rather skewed performance envelopes of RAID5 and even of RAID6
> match workload and budget requirements. But it takes apparently
> unusual insight to recognize these cases, so just use RAID10 even
> if you suspect it is one of those narrow cases.

In your whole post you never touched on URE rates (well you did, but you 
didn't seem to this was a problem).

I'm using RAID6 because I don't really care about performance, but I do 
want to be able to fail one drive and have scattered URE handled while 
rebuilding. I have had scattered URE hit me numerous times over the past 
10 years. With RAID6 they are handled nicely even with a failed drive.

If I cared about performance, I would either do what was discussed earlier 
in the thread (use smaller enterprise drives with better BER) in RAID10, 
or I would use threeway mirror RAID1 and use lvm to vg several RAID1:s 
together.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
