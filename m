From: Brad Campbell <brad@wasp.net.au>
Subject: Re: Raid-0 speed
Date: Thu, 26 Aug 2004 13:54:35 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <412DB35B.7090802@wasp.net.au>
References: <412C1E23.1070104@wasp.net.au> <87k6vneok0.fsf@enki.rimspace.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87k6vneok0.fsf@enki.rimspace.net>
To: Daniel Pittman <daniel@rimspace.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

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

And the performance difference between chunk=16 and chunk=4096 is less than 5MB/s

--chunk=16 gives me   48.43 MB/s
--chunk=4096 gives me 51.52 MB/s

Regards,
Brad
