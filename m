From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: 95a05b3 broke mdadm --add on my superblock 1.0 array
Date: Wed, 21 Sep 2016 02:40:21 -0400
Message-ID: <57E22B55.4010001@suse.com>
References: <20160919163229.uccdr6bxiwetqvwo@derobert.net>
 <57E0CB6C.2040000@suse.com>
 <63417807-ae42-ed60-8c8b-3b699994c34c@derobert.net>
 <57E10311.7040601@suse.com> <20160920171223.n7t3wa673qopky4c@derobert.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160920171223.n7t3wa673qopky4c@derobert.net>
Sender: linux-raid-owner@vger.kernel.org
To: Anthony DeRobertis <anthony@derobert.net>, linux-raid@vger.kernel.org, 837964@bugs.debian.org
List-Id: linux-raid.ids



On 09/20/2016 01:12 PM, Anthony DeRobertis wrote:
>
>> Which kernel version are you used to created the array in case the kernel
>> was updated?
> I've had the array for a while (the superblocks with -E show a creation
> time of Wed Jun 16 14:25:08 2010). If I had to take a guess, I'd guess
> it was created with the Debian squeeze alpha1 installer... So probably
> 2.6.30 or 2.6.32.
>

Hmm, lots of things are changed from 2.6.30, so it is possible that 
latest mdadm
can't work well with array which was created with the old kernel.

Thanks,
Guoqing
