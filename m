From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: AW: RAID1 and data safety?
Date: Tue, 29 Mar 2005 11:30:06 +0200
Message-ID: <62b0912f05032901305a8729e6@mail.gmail.com>
References: <76592C4D3DA1AC4FB8424084D10D31A80611527B@mchh2c4e.mchh.siemens.de>
Reply-To: Molle Bestefich <molle.bestefich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <76592C4D3DA1AC4FB8424084D10D31A80611527B@mchh2c4e.mchh.siemens.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Does this sound reasonable?

Does to me.  Great example!
Thanks for painting the pretty picture :-).

Seeing as you're clearly the superior thinker, I'll address your brain
instead of wasting wattage on my own.

Let's say that MD had the feature to read from both disks in a mirror
and perform a comparison on read.
Let's say that I had that feature turned on for 2 mirror arrays (4 disks).
I want to get a bit of performance back though, so I stripe the two
mirrored arrays.

Do you see any problem in this scenario?
Are we back to "corruption could happen then" or are we still OK?
