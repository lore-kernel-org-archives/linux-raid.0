From: Ramon Hofer <ramonhofer@bluewin.ch>
Subject: Re: "bitmap" line in /proc/mdstat
Date: Fri, 14 Oct 2016 18:29:46 +0200
Message-ID: <580107FA.40901@bluewin.ch>
References: <5800AE09.70608@bluewin.ch>
 <8922e2e1-b612-fa32-6932-9f4158f52fe6@turmel.org>
 <003401d22635$32b7bc70$98273550$@wnsdev.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <003401d22635$32b7bc70$98273550$@wnsdev.com>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Sangas <pete@wnsdev.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 14/10/16 18:08, Peter Sangas wrote:
> Can you quantify the performance decrease and if rebuild time is not as important as performance how does one remove the bitmap?

 From the Linux RAID wiki:
"Some limited measurements I have done suggest up to 10% slowdown, 
though usually less. Possibly some tuning can make it much better." [1]

[1] 
https://raid.wiki.kernel.org/index.php/Write-intent_bitmap#How_Bitmaps_Work_by_Q.26A

Regards,
Ramon
