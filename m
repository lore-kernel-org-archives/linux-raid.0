From: Peter Rabbitson <rabbit@rabbit.us>
Subject: Re: Help with chunksize on raid10 -p o3 array
Date: Mon, 12 Mar 2007 22:16:01 +0100
Message-ID: <45F5C311.7030302@rabbit.us>
References: <45ED4FE1.5020105@rabbit.us> <17908.55047.408840.852816@notabene.brown> <45F567BB.3090804@rabbit.us> <45F59FE0.2000307@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45F59FE0.2000307@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Richard Scobie wrote:
> Peter Rabbitson wrote:
> 
>> Is this anywhere near the top of the todo list, or for now raid10 
>> users are bound to a maximum read speed of a two drive combination?
> 
> I have not done any testing with the md native RAID10 implementations, 
> so perhaps there are some other advantages, but have you tried setting 
> up your 4 drives as a RAID 0 made up of a pair of RAID1s?

The advantage is higher redundancy when I can have any two drives fail 
in a x3 layout unlike the raid1/0 setup, although I sacrifice available 
disk space. But yes, I agree that if I was after pure throughput raid1/0 
would be more beneficial, with the downside of 1.5 disk failure redundancy.
