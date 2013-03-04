From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID performance - new kernel results - 5x SSD RAID5
Date: Mon, 04 Mar 2013 06:42:21 -0600
Message-ID: <513496AD.4070507@hardwarefreak.com>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <CAKHEz2YgiQiknBXju9a=PR3zV1Hb7ux8yBZWywiTi=BXFm20GA@mail.gmail.com> <51150475.2020803@websitemanagers.com.au> <5120A84E.4020702@websitemanagers.com.au> <51222A81.9080600@hardwarefreak.com> <51250377.509@websitemanagers.com.au> <5125B8E5.5000502@hardwarefreak.com> <5125C154.3090603@websitemanagers.com.au> <51272808.7070302@hardwarefreak.com> <512A79D3.9020502@hardwarefreak.com> <5130D206.4090302@websitemanagers.com.au> <5131C338.8010402@hardwarefreak.com> <513231BB.4070903@turmel.org> <ac5cdf66-ba01-4d7b-bd7b-60fb67517ad
 4@email.android.com> <5133F95A.5040508@turmel.org> <51346BB5.2010403@websitemanagers.com.au>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51346BB5.2010403@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Phil Turmel <philip@turmel.org>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 3/4/2013 3:39 AM, Adam Goryachev wrote:

> On 04/03/13 16:25, Stan Hoeppner wrote:
>> If you have no gaps between this one and your other LVs, and each of 
>> them is evenly divisible by 512 sectors, then they should all be
>> aligned.
> 
> Given the 4MB size of the LVM blocks, does that automatically make this
> true? I thought it did, but given your above comment, I'm unsure.

512 sectors is the size of your md/RAID stripe.

512 bytes/sector * 512 sectors = 262,144 bytes = 256 KB

4 MB = 4 * 1,048,576 = 4,194,304 bytes

4,194,304 bytes / 262,144 bytes = 16

So there are exactly 16 md/RAID stripes sitting 'under' each 4MB LVM block.


WRT to your question of changing the stripe width, due to drive
expansion, to a value not evenly divisible into 4MB, I'd say you'd need
to change your chunk size during the expansion reshape so that your new
stripe width is evenly divisible into 4MB.  You'll need to plan this, as
with some drive counts it may not be possible.  Is it possible to change
the LVM block size to fit the new stripe width?

-- 
Stan

