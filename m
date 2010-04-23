From: MRK <mrk@shiftmail.org>
Subject: Re: RAID5
Date: Fri, 23 Apr 2010 16:57:35 +0200
Message-ID: <4BD1B55F.30702@shiftmail.org>
References: <s2q6b16fb4c1004182046x5464351m861ccaf9850f33df@mail.gmail.com>
 <j2k4877c76c1004182121w3edcf996x2ee8ee0eca398985@mail.gmail.com>
 <4BCEFE66.6010607@tmr.com>
 <l2g4877c76c1004211243n6dfa55pfee322db20ba6f08@mail.gmail.com>
 <4BD1AE0C.2040003@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <4BD1AE0C.2040003@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Michael Evans <mjevans1983@gmail.com>, Bill Davidsen <davidsen@tmr.com>, Kaushal Shriyan <kaushalshriyan@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/23/2010 04:26 PM, Michael Tokarev wrote:
>
> This is most likely due to read-modify-write cycle which is present on
> lvm-on-raid[456] if the number of data drives is not a power of two.
> LVM requires the block size to be a power of two, so if you can't fit
> some number of LVM blocks on whole raid stripe size your write speed
> is expected to be ~3 times worse...
>
> Even creating partitions on such raid array is difficult.
>
>
>
>    

Seriously?
a number of data drives power of 2 would be an immense limitation.
Why should that be? I understand that LVM blocks would not be aligned to 
raid stripes, and this can worsen the problem for random writes, but if 
the write is sequential, the raid stripe will still be filled at the 
next block-output by LVM.
Maybe the very first stripe you write will get an RMW but the next ones 
will be filled in the wait, and also consider you have the 
preread_bypass_threshold feature by MD which helps in this.

Also if you really need to put an integer number of LVM blocks in an MD 
stripe (which I doubt, as I wrote above), this still does not mean that 
the number of drives needs to be a power of 2: e.g. you could put 10 LVM 
blocks in 5 data disks, couldn't you?


I would think more to a barriers thing... I'd try to repeat the test 
with nobarrier upon ext4 mount and see.
But Bill says that he "knows" what's the problem so maybe he will tell 
us earlier or later :-)
