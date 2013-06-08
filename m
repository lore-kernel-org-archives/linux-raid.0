From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: SSD + Rust as raid1
Date: Sat, 08 Jun 2013 13:11:38 -0400
Message-ID: <51B365CA.6090409@tmr.com>
References: <51A7C36F.4030605@timedicer.co.uk> <20130531133018.77cd9285@natsu> <51A85574.8080709@timedicer.co.uk> <20130531135434.5b6bdddb@natsu> <51A864E1.9070903@timedicer.co.uk> <51ADA1AF.6040405@timedicer.co.uk> <51B25D7C.4090403@tmr.com> <20130608162235.7ca32f4d@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130608162235.7ca32f4d@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Roman Mamedov wrote:
> On Fri, 07 Jun 2013 18:23:56 -0400
> Bill Davidsen <davidsen@tmr.com> wrote:
>
>>> If I have to have a bitmap file, it is
>>> presumably faster to have a larger chunk size
>> If you want performance I think a too big chunk size will hurt you.
> You are confusing the general array chunk sizes, and the bitmap chunk size. In
> the latter, a larger size will universally give better performance (up to some
> value, where it will perhaps start to flat out).
>
If that were the case, then a bitmap would not be used, you could just have a 
single bit, and make the chuck size the size of everything. Since that would 
pretty much make the bitmap worthless, it suggests to me that there is in fact a 
limit to the optimal chunk size, short of what the implementation max allows. I 
think the optimal size is determined by usage, but there is probably some way to 
measure it. I find that when it seems a "if some is good more is better" 
approach fits a problem, I like to check that taking it to the limit would make 
sense. The Latin IIRC is 'reducto ad absurbum' and has saved me from occasional 
wretched excess.

-- 
Bill Davidsen <davidsen@tmr.com>
   We are not out of the woods yet, but we know the direction and have
taken the first step. The steps are many, but finite in number, and if
we persevere we will reach our destination.  -me, 2010


