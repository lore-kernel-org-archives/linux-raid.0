From: "=?iso-8859-1?Q?Michael=20Sallaway?=" <michael@sallaway.com>
Subject: =?iso-8859-1?B?UmU6IDMtd2F5IG1pcnJvcnM=?=
Date: Wed, 08 Sep 2010 05:45:41 +0000
Message-ID: <20100908054541.3760.qmail@s217.sureserver.com>
Reply-To: "=?iso-8859-1?Q?Michael=20Sallaway?=" <michael@sallaway.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


>  -------Original Message-------
>  From: Neil Brown <neilb@suse.de>
>  To: Michael Sallaway <michael@sallaway.com>
>  Cc: linux-raid@vger.kernel.org
>  Subject: Re: 3-way mirrors
>  Sent: 08 Sep '10 04:16

>  > Interesting... will this also work for a rebuild/recovery? If so, how do I start a rebuild from a particular location? (do I just write the sync_min sector before adding the replacement drive to the array, and it will start from there when I add it?)
>  
>  Why would you want to?

(My apologies for hijacking the email thread, I only meant it as a side question!)

The reason relates to my question I posted yesterday -- I have a 12-drive raid 6 array, with 3 drives that have some bad sectors at varying locations. I planned to swap out one drive with a new one, and let it rebuild that one, then do the same for the other 2. However, when I replace and rebuild drive A, drive B gets read errors and falls out of the array (at about 50% through), but recovery continues. At the 60% mark, however, drive C gets read errors, and also falls out of the array, which now only has 9 working devices, so abandons recovery. (even though drive B has vaild data at that location, so it could be rebuilt).

One solution I thought of (and please, suggest others!) was to recover 55% of the array onto the new drive (A), and then stop recovery somehow. Then forcibly add drive B back into the array, and keep recovering, so that when it hits the 60% mark, even though drive C fails, it can still get parity data and recover using drive B.

It sounds crazy, I know, but can't think of a better solution. If you have one, please suggest it! :-)


> You can add a new device entirely by writing to sysfs files.  In this case
> you can set the 'recovery_start' for that device.  This tells md that it has
> already recovered some of the array.

Interesting, I think this is exactly what I'm after. Is this documented somewhere, or can you give me some pointers as to where to look to find more information/documentation on the sysfs files and what they do, etc.?

Thanks!
Michael
