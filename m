From: berk walker <berk@panix.com>
Subject: Re: 4 disks: RAID-6 or RAID-10 ..
Date: Fri, 17 Feb 2006 06:44:07 -0500
Message-ID: <43F5B707.3030005@panix.com>
References: <Pine.LNX.4.56.0602171100420.22063@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0602171100420.22063@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Gordon Henderson <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Gordon Henderson wrote:

>I'm building a little test server and I wanted ~500GB of storage with
>2-drive redundancy, so the best price vs. num. drives vs. the need for 2
>drive redundancy came to 4 x 250GB drives. (And I have a mobo with 5 SATA
>ports, and taking into account case power requirements, etc. 4 drives has
>worked out quiet well, and cheaper than 2 x 500GB drives!)
>
>So RAID-6, which I have have been using for a year or so now with good
>results, or RAID-10, which I've never used.
>
>I suspect RAID-10 might give me more performance, not having the parity
>calculations to do, but is it stable and reliable? I've not been paying
>much attention to it recently ... (Servers intended use is what I
>understand is termed 'LAMP' these days - Linux, Apache, MySQL, PHP,
>although it's going to be handling up to 10,000 emails a day too with spam
>and virus checking)
>
>Cheers,
>
>Gordon
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>  
>
RAID-6 *will* give you your required 2-drive redundancy.
b-

