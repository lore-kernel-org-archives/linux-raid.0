From: Tim Small <tim@buttersideup.com>
Subject: Re: disk testing
Date: Tue, 14 Sep 2004 10:15:43 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4146B6BF.1050408@buttersideup.com>
References: <20040914085007.486103E2F@xprdmailfe12.nwk.excite.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040914085007.486103E2F@xprdmailfe12.nwk.excite.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


If there is an unreadable sector on the disk, then reading it will fail,
but if you write to it, the drive firmware will reallocate the sector,
and then allow reading (actually the sector it is reading is now
somewhere else on the disk, but the firmware hides this).  If the raid5
sync was trying to read such a sector, but your other tests have written
it, then it will now appear to be fine (and the raid5 should now work).

If I were you I would use smartmontools to check out the drive (you can
then see if it has reallocated any sectors, and read errors should show
up in the SMART error log).

Tim.


p.s. Prelim SMART support for libata:

http://www.ussg.iu.edu/hypermail/linux/kernel/0408.3/2304.html




harry wrote:

>I just bought 3 sata drives and set them up in a raid5 array. About 45% into syncing them, the first disk gets an error and goes offline. I figure I did something wrong, so I retrace my steps and try again, and again, I get an error about 45% of the way through, the first disk errors and goes offline. 
>
>So, I think I have a bad disk. But wait! I created a raid 1 array on the remaining two to see if there are any other errors later on those two (there weren't), and I create a normal partition/fs on the failing disk. I begin writing various bitpatterns across the entire disk and reading them back, trying to find the problem. So far, I've done about 5 passes over the entire disk without error! 
>
>So, any idea why raid would be getting errors from the disk, but I don't seem to be able to? (or, what I should tell the store I bought it from when I try to get it replaced?)
>
>  
>

