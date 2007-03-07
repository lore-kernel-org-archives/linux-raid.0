From: Peter Rabbitson <rabbit@rabbit.us>
Subject: Re: Help with chunksize on raid10 -p o3 array
Date: Wed, 07 Mar 2007 10:28:46 +0100
Message-ID: <45EE85CE.6010501@rabbit.us>
References: <45ED4FE1.5020105@rabbit.us> <45EE07EB.8050604@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45EE07EB.8050604@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen wrote:
> Peter Rabbitson wrote:
>> Hi,
>> I have been trying to figure out the best chunk size for raid10 before 

> By any chance did you remember to increase stripe_cache_size to match 
> the chunk size? If not, there you go.

At the end of /usr/src/linux/Documentation/md.txt it specifically says 
that stripe_cache_size is raid5 specific, and it made sense to me, as 
caching stuff to avoid re-doing parity is beneficial. I will test later 
today trying to set the cache higher. Are there any guidelines on how 
large should it be in relation to the chunk size/number of drives for 
raid10?
