From: Bill Davidsen <davidsen@tmr.com>
Subject: FC7 install still lacks a feature
Date: Sat, 14 Jul 2007 19:47:41 -0400
Message-ID: <4699609D.7020705@tmr.com>
Reply-To: For users of Fedora <fedora-list@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <fedora-list-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/fedora-list>,
	<mailto:fedora-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/fedora-list>
List-Post: <mailto:fedora-list@redhat.com>
List-Help: <mailto:fedora-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/fedora-list>,
	<mailto:fedora-list-request@redhat.com?subject=subscribe>
Sender: fedora-list-bounces@redhat.com
Errors-To: fedora-list-bounces@redhat.com
To: For users of Fedora <fedora-list@redhat.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

When configuring RAID arrays, advanced users should be offered the 
option to set the chunk size. And using ext3 or any other f/s which 
knows a little about RAID, the stride= option check be set to the size 
of a stripe, the number of data drives times the chunk size.

Booting a rescue or "Live-CD" and doing the partitioning will solve the 
first, not the 2nd.

And finally, support for encrypted f/s would be nice, I guess using 
dm-crypt to be portable, to allow vital things to be kept safe (/home, 
databases, etc). More laptops would use crypto if the users could figure 
out how!

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

-- 
fedora-list mailing list
fedora-list@redhat.com
To unsubscribe: https://www.redhat.com/mailman/listinfo/fedora-list
