From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Raid 5 - not clean and then a failure.
Date: Wed, 26 Aug 2009 13:47:13 +0100
Message-ID: <4A952ED1.8040305@anonymous.org.uk>
References: <73066.92033.qm@web51304.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <73066.92033.qm@web51304.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 26/08/2009 12:29, Jon Hardcastle wrote:
[...]
> I did look into bitmaps *abit* i could easily have the imagine for my 6 drive raid 5 stored on the raid1 I have in the same system.. The googling I did tho did not paint a pretty picture it talked about huge performance hits?

There is a performance hit but it can be minimised by picking a bitmap 
chunk size to suit; I ended up getting about 80% of bitmap-less write 
performance using a 16MB bitmap chunk size instead of about 40% with the 
default size, on my 3-drive RAID-5 array.

Cheers,

John.

