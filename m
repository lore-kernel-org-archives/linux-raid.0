From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Subject: Re: Safely swapping a disk in a RAID456
Date: Fri, 30 Sep 2011 18:06:57 +0200
Message-ID: <4E85E921.1020808@grumpydevil.homelinux.org>
References: <20110930154217.GA11732@albatross.gern.madduck.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110930154217.GA11732@albatross.gern.madduck.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

On 09/30/2011 05:42 PM, martin f krafft wrote:
> Dear list,
>
> I would like to swap out a drive in a RAID6 (4 drives), but ideally
> without letting the RAID degrade. I was thinking that it should be
> possible to declare the new disk a copy of the old one, let it sync,
> then remove the old one and let the new one take over, but MD does
> not seem to support that.
If you can stop the array it can be done. Otherwise you will have to 
degrade it while replacing

Replacing without degrade:
- stop the raid
- do a dd from old disk to new disk
- replace the disk
- re-start the raid

Cheers,


Rudy

