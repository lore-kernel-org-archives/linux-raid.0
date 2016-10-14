From: "Peter Sangas" <pete@wnsdev.com>
Subject: RE: "bitmap" line in /proc/mdstat
Date: Fri, 14 Oct 2016 10:32:47 -0700
Message-ID: <005501d22640$fc4d6a20$f4e83e60$@wnsdev.com>
References: <5800AE09.70608@bluewin.ch> <8922e2e1-b612-fa32-6932-9f4158f52fe6@turmel.org> <003401d22635$32b7bc70$98273550$@wnsdev.com> <580107FA.40901@bluewin.ch>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <580107FA.40901@bluewin.ch>
Content-Language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: 'Ramon Hofer' <ramonhofer@bluewin.ch>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks Ramon.

Do you know why some of your mds were created with bitmaps and others were not?  When I installed Ubuntu 16.04 and used the installer to create a RAID1 some of the mds had bitmaps and some did not.

Thanks,
Pete

-----Original Message-----
From: Ramon Hofer [mailto:ramonhofer@bluewin.ch] 
Sent: Friday, October 14, 2016 9:30 AM
To: Peter Sangas; linux-raid@vger.kernel.org
Subject: Re: "bitmap" line in /proc/mdstat

On 14/10/16 18:08, Peter Sangas wrote:
> Can you quantify the performance decrease and if rebuild time is not as important as performance how does one remove the bitmap?

 From the Linux RAID wiki:
"Some limited measurements I have done suggest up to 10% slowdown, though usually less. Possibly some tuning can make it much better." [1]

[1]
https://raid.wiki.kernel.org/index.php/Write-intent_bitmap#How_Bitmaps_Work_by_Q.26A

Regards,
Ramon
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html

