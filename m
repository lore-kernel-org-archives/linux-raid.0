From: "Yogesh Pahilwan" <pahilwan.yogesh@spsoftindia.com>
Subject: RE: Problem in creating RAID5 MD array with kernel 2.6.15
Date: Tue, 11 Apr 2006 12:49:25 +0530
Message-ID: <WM99EB121D93CD43f188D3116C52572664@spsoftindia.com>
References: <17467.21890.331141.217376@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17467.21890.331141.217376@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: 'Neil Brown' <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

I have set --bitmap-chunk=1024 and RAID5 gets created successfully.

But why I will have to set --bitmap-chunk for big size devices such as 500GB
each in my case?

What is the default value of --bitmap-chunk?

Thanks,
Yogesh

-----Original Message-----
From: Neil Brown [mailto:neilb@suse.de] 
Sent: Tuesday, April 11, 2006 12:37 PM
To: Yogesh Pahilwan
Cc: linux-raid@vger.kernel.org
Subject: Re: Problem in creating RAID5 MD array with kernel 2.6.15

On Tuesday April 11, pahilwan.yogesh@spsoftindia.com wrote:
> Hi Folks,
> 
> I am trying to create RAID5 array using mdadm on kernel 2.6.15 as
> 
> # mdadm -Cv /dev/md0 --assume-clean --force --bitmap=/tmp/bitmap.txt -l5
-n4
> /dev/sd{a,b,c,d}
> 
> But when I execute this command getting the following error:
> 
> mdadm: RUN_ARRAY failed: Cannot allocate memory

How big are your devices?

Try setting a larger bitmap chunk size
    --bitmap-chunk=1024
maybe.

NeilBrown

