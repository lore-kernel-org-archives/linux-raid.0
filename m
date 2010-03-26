From: Peter Kieser <peter@kieser.ca>
Subject: Re: Use of WD20EARS with MDADM
Date: Fri, 26 Mar 2010 13:27:17 -0700
Message-ID: <4BAD18A5.1080905@kieser.ca>
References: <4BAB8D41.4010801@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BAB8D41.4010801@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Dunn <andrew.g.dunn@gmail.com>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 3/25/2010 9:20 AM, Andrew Dunn wrote:
> Recently Dell is selling their WD20EARS (2TB) for 90$
>
> This being one of the best PPG (Price Per Gigabyte) snatches I have
> seen, I was considering buying 8 of them for an mdadm array.
>
> Has anyone had experience with these drives?
>
> Note, they have 4K sectors.
>
> Thank you for your kind responses.
>
>    
Hello,

The 4096-byte sector drives work fine with mdadm. The main problem you 
are going to run into with the WDC Green drives is their 8 second "idle" 
setting. After 8 seconds, by default, the drive parks its heads. This 
can lead to an amazingly high Load Cycle Count (LLC) after just a month 
of operation due to the fact that most disk access happens around that 
time causing the drive to park and unpark in repeated cycles.

To fix this, find a utility called wdidle3 (I have it, if you are unable 
to locate it) and set the idle timeout on the drives to 300 seconds. 
These drives do not support TLER, there is no ability to set it via 
firmware anymore - WDC removed this ability sometime last year.

-Peter
