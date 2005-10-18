From: Brad Campbell <brad@wasp.net.au>
Subject: Re: RAID-5 or RAID-6 with mdadm 1.9.0-4 and 2.6.11.9
Date: Tue, 18 Oct 2005 08:48:39 +0400
Message-ID: <43547EA7.8000508@wasp.net.au>
References: <6d5bedd80510171720x16b962fcjd6dc878450b642d8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6d5bedd80510171720x16b962fcjd6dc878450b642d8@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ewan Grantham <ewan.grantham@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Ewan Grantham wrote:
> A rather specific question, I know. But I'm intrigued by some of the
> things I've read about what RAID-6 offers. On the other hand, given
> the version of mdadm and the Linux kernel I'm running, I'm wondering
> which would be more stable and/or give better performance.

I'm running both RAID-5 and RAID-6 on 2.6.11.7 and they work a treat.

RAID-6 saved me from a dual drive failure a little while back, where a 2nd drive developed (or 
noticed) grown defects during the rebuild of the first failed drive (it takes about 15 hours to 
rebuild this RAID-6)

brad@storage1:~$ uname -a
Linux storage1 2.6.11.7 #4 Fri Oct 7 20:00:25 GST 2005 i686 GNU/Linux
brad@storage1:~$ /sbin/mdadm --version
mdadm - v1.9.0 - 04 February 2005

Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
