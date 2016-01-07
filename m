From: Adam Goryachev <adam@websitemanagers.com.au>
Subject: stripe_cache_active always 0
Date: Thu, 7 Jan 2016 14:09:26 +1100
Message-ID: <568DD6E6.6070107@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I remember some years ago when I was building my storage servers I spent 
a lot of time optimising performance, and eventually got some really 
good stats and more importantly, good enough performance that users 
stopped complaining, and things "just work".

However, when comparing config with another server, I noticed one of the 
values I configured was stripe_cache_size, and I was setting this to 
4096 (which was the peak performance compared to higher/lower numbers at 
the time).

In any case, I'm looking at a "in use" system, and looking at 
stripe_cache_active and it is always 0. I'm trying to find some docs on 
what this value means?
Is the stripe cache disabled?
Are there just no stripes in the cache?

If it is always 0, then does it mean I don't need to adjust the 
stripe_cache_size (I presume worst case is I am wasting RAM which is not 
really important anyway).

Thanks,
Adam

-- 
Adam Goryachev
Website Managers
P: +61 2 8304 0000                    adam@websitemanagers.com.au
F: +61 2 8304 0001                     www.websitemanagers.com.au

