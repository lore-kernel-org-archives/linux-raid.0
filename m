From: "harry" <hfranklin97@excite.com>
Subject: Re: disk testing
Date: Thu, 16 Sep 2004 22:50:05 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040917025005.DC7F1395B@xprdmailfe9.nwk.excite.com>
Reply-To: hfranklin97@excite.com
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Tim and Neil have suggested (apparently correctly) that the disk had a bad sector and the firmware remapped it when I wrote to it. My question is, how many spare sectors does the typical disk have? More importantly, since the sector has been remapped, recreating the raid5 array worked fine, but is a failure right out of the box normal? I was going to return it but since its working now I'm not sure if I should or not.

Thanks




 --- On Tue 09/14, Tim Small < tim@buttersideup.com > wrote:
From: Tim Small [mailto: tim@buttersideup.com]
To: linux-raid@vger.kernel.org
Date: Tue, 14 Sep 2004 10:15:43 +0100
Subject: Re: disk testing

<br>If there is an unreadable sector on the disk, then reading it will fail,<br>but if you write to it, the drive firmware will reallocate the sector,<br>and then allow reading (actually the sector it is reading is now<br>somewhere else on the disk, but the firmware hides this).  If the raid5<br>sync was trying to read such a sector, but your other tests have written<br>it, then it will now appear to be fine (and the raid5 should now work).<br><br>If I were you I would use smartmontools to check out the drive (you can<br>then see if it has reallocated any sectors, and read errors should show<br>up in the SMART error log).<br><br>Tim.<br><br><br>p.s. Prelim SMART support for libata:<br><br>http://www.ussg.iu.edu/hypermail/linux/kernel/0408.3/2304.html<br><br><br><br><br>harry wrote:<br><br>>I just bought 3 sata drives and set them up in a raid5 array. About 45% into syncing them, the firs
 t disk gets an error and goes offline. I figure I did something wrong, so I retrace my ste
 ps and try again, and again, I get an error about 45% of the way through, the first disk errors and goes offline. <br>><br>>So, I think I have a bad disk. But wait! I created a raid 1 array on the remaining two to see if there are any other errors later on those two (there weren't), and I create a normal partition/fs on the failing disk. I begin writing various bitpatterns across the entire disk and reading them back, trying to find the problem. So far, I've done about 5 passes over the entire disk without error! <br>><br>>So, any idea why raid would be getting errors from the disk, but I don't seem to be able to? (or, what I should tell the store I bought it from when I try to get it replaced?)<br>><br>>  <br>><br><br>-<br>To unsubscribe from this list: send the line "unsubscribe linux-raid" in<br>the body of a message to majordomo@vger.kernel.org<br>More majordomo info at  http://vger
 .kernel.org/majordomo-info.html<br>

_______________________________________________
Join Excite! - http://www.excite.com
The most personalized portal on the Web!
