From: SoulBlazer <soul@lamp-post.net>
Subject: Software Raid Cache
Date: Fri, 21 Feb 2003 15:50:23 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E56910F.6050509@lamp-post.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I was wondering if it would be possible to set aside a large (larger) 
amount of system memory to act as cache for software raid.
I have a few xeon systems here with 4-8gb of memory in them and based on 
watching the performance of some mylex raid cards
jump up when we did a memory upgrade from 64mb -> 128mb I was wondering 
if the same would occur in linux.

If this is even something doable (tweakable) Im wondering what the perf 
gain from allocating say 2 or 4gb just to raid cache would be.

Comments ?

