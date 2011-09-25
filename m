From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Recovery of failed RAID 6 and LVM
Date: Sun, 25 Sep 2011 03:39:25 -0500
Message-ID: <4E7EE8BD.2090301@hardwarefreak.com>
References: <4E7EDE58.3000804@yazzy.org>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E7EDE58.3000804@yazzy.org>
Sender: linux-raid-owner@vger.kernel.org
To: lists@yazzy.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9/25/2011 2:55 AM, Marcin M. Jessa wrote:
> Hi guys.
>
>
> I have a RAID 6 setup with 5 2TB drives on Debian Wheezy [1] & [2].
> Yesterday 3 of the drives failed working leaving the RAID setup broken.

What was the hardware event that caused this situation?  Did you lose 
power to, or kick the data cable out of a 3-bay eSATA enclosure?  Do you 
have a bad 3 in 1 hot swap cage?  A flaky HBA/driver?

You need to identify the cause and fix it permanently or this will 
likely happen again and again.

-- 
Stan
