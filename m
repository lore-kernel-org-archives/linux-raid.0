From: Maurice Hilarius <maurice@harddata.com>
Subject: Re: Reinstall OS Without Disturbing Software Raid Array
Date: Sat, 09 Jul 2011 15:09:54 -0600
Message-ID: <4E18C3A2.1040202@harddata.com>
References: <1310234009.6441.3.camel@babel>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1310234009.6441.3.camel@babel>
Sender: linux-raid-owner@vger.kernel.org
To: Noah Swint <noah.swint@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 7/9/2011 11:53 AM, Noah Swint wrote:
> Can I reinstall fedora 14 without destroying the software raid array?
Yes.

In the Fedora installer, when you get to the disk partitioning options 
selection,
choose "Custom" which is, I believe the last option on the pull down menu.

That assumes, of course, that you are using the GUI installer version.
If you are installing in text mode, the choice is the same, however the 
menu is different.

One may if you like, also  selectively save existing partitions and 
their data, but choosing
whether or not you want them to be formatted.

Often one may want to preserve /home, assuming that it is a separate 
partition or md device.




-- 
-- 
Cheers,
Maurice Hilarius
eMail: /mhilarius@gmail.com/
