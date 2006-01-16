From: Max Waterman <davidmaxwaterman+gmane@fastmail.co.uk>
Subject: Re: md faster than h/w?
Date: Mon, 16 Jan 2006 13:33:39 +0800
Message-ID: <43CB3033.8070803@fastmail.co.uk>
References: <dq7jii$n1c$1@sea.gmane.org> <Pine.LNX.4.44.0601131720090.24299-100000@coffee.psychology.mcmaster.ca> <20060114212341.GB20464@lug.udel.edu> <43CB2314.5000203@fastmail.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43CB2314.5000203@fastmail.co.uk>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Max Waterman wrote:
>
> Then I unmount /dev/sdb and it's back up to 155MB/s !?!?!
> 
> It's not making any sense to me :(
> 

OK, the 'hdparm -t' numbers are always low for a device that is mounted.

i.e. an unmounted device gets 3-4 times the bandwidth of a mounted device.

Of course, bonnie++ only works on mounted devices, but gives me
reasonable (but not great) numbers (130MB/s) which don't seem to vary
too much with the kernel version.

Max.
