From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RAID-6: help wanted
Date: Sun, 24 Oct 2004 00:09:29 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <417B5529.2070709@zytor.com>
References: <cleqh6$ps4$1@terminus.zytor.com> <417B3CF9.7090107@wasp.net.au> <417B546C.3050706@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <417B546C.3050706@zytor.com>
To: Brad Campbell <brad@wasp.net.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

H. Peter Anvin wrote:
> Brad Campbell wrote:
>>
>> Great, can we get a copy of the scripts to try and assist?
>>
>> Brad
> 
> In the process of being uploaded to:
> 
> http://www.zytor.com/~hpa/raid6-bug/
> 
> It'll be about 40 minutes until it's uploaded, because of the 80 MB data 
> file.
> 
> This will create a RAID-6 volume on a loopback device, fail a unit, and 
> then write a bunch of stuff, which will corrupt the filesystem.  The 
> corruption only happens when writing to a volume that is running in 
> degraded mode; it seems to happen both with 1 and 2 disks missing.
> 

Changed to:

http://userweb.kernel.org/~hpa/raid6-bug/

(It's a faster server, but it'll still take about 40 minutes from now 
until it's uploaded, but then it can at least be a quicker download.)

	-hpa
