From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Raid-0 speed
Date: Thu, 26 Aug 2004 12:41:48 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200408261641.i7QGfr317326@watkins-home.com>
References: <412DB35B.7090802@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <412DB35B.7090802@wasp.net.au>
To: 'Brad Campbell' <brad@wasp.net.au>, 'Daniel Pittman' <daniel@rimspace.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Based on the error message, 4096 should also fail.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Brad Campbell
Sent: Thursday, August 26, 2004 5:55 AM
To: Daniel Pittman
Cc: linux-raid@vger.kernel.org
Subject: Re: Raid-0 speed

Daniel Pittman wrote:

>>With the raid-0 running, doing a dd if=/dev/md1 of=/dev/null I get about
>>	55MB/s read speed.
>>
>>I can't quite figure out why the md is so slow. Given its using
>>streaming reads with no seeking it should be over 100MB/s.
> 
> 
> Your chunk size is way to low to give good streaming reads.  The kernel
> needs to switch between devices every 128 kilobytes, while is rather
> low.
> 
> Try slowly pushing the chunk size to 16384 and see when your performance
> gets back up to your expected level.

Nope.. Any chunk size > 4096 gives me
too big chunk_size: 8388608 > 4194303.

And the performance difference between chunk=16 and chunk=4096 is less than
5MB/s

--chunk=16 gives me   48.43 MB/s
--chunk=4096 gives me 51.52 MB/s

Regards,
Brad
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

