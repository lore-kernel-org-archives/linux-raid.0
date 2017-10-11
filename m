From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Can't mount /dev/md0 Raid5
Date: Wed, 11 Oct 2017 16:01:31 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1710111600210.31961@uplift.swm.pp.se>
References: <59DDF18A.9060800@gmail.com> <8628ddba-8cec-24d8-e07a-195d47f579be@grumpydevil.homelinux.org> <59DDFD19.1040700@gmail.com> <e6566c4a-2476-4554-549a-12b6c90b152f@websitemanagers.com.au> <59DE0705.502@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59DE0705.502@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joseba Ibarra <wajalotnet@gmail.com>
Cc: Adam Goryachev <adam@websitemanagers.com.au>, Rudy Zijlstra <rudy@grumpydevil.homelinux.org>, list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 11 Oct 2017, Joseba Ibarra wrote:

> Now I see the RAID, however can't be mounted. So, I'm not sure how to backup 
> the data. Gparted shows the partition /dev/md0p1 with the used and free 
> space.

Do you know what file system you had? Looks like next step is to try to 
run fsck -n (read-only) on md0 and/or md0p1.

What does /etc/fstab contain regarding md0?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
