From: David Rees <drees76@gmail.com>
Subject: Re: RAID1 write-behind not working?
Date: Thu, 26 Mar 2009 22:48:56 -0700
Message-ID: <72dbd3150903262248l407f3fddr1933d2662041a915@mail.gmail.com>
References: <72dbd3150903251739q21de8a2ew835860f9e3b11d14@mail.gmail.com>
	<18892.22029.923043.59931@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18892.22029.923043.59931@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Mar 26, 2009 at 9:29 PM, Neil Brown <neilb@suse.de> wrote:
> On Wednesday March 25, drees76@gmail.com wrote:
>> I picked up a SSD (30GB OCZ Vertex if you're curious) and am plannin=
g
>> to set up a RAID1 with it and a SATA disk with the SATA disk in
>> write-mostly mode along with write-behind enabled.
>>
>> So I went to test it to make sure I had all the details correct on
>> aligning the partition to a 128kB offset and the correct mdadm
>> commands to create the array in write-mostly and write-behind, but I
>> found that I couldn't get writes to "write-behind". =A0Essentially a=
ll
>> writes would complete at the speed of the rotating disk. =A0Reads
>> however worked great - they all appeared to be coming from the SSD.
>>
>> I created the array with the following command:
>>
>> mdadm --create /dev/md0 --raid-devices=3D2 --level=3D1 \
>> =A0 --bitmap=3Dinternal --write-behind /dev/sdb1 --write-mostly /dev=
/sda1
>
> Hmmm... try with an external bitmap stored elsewhere on the SSD.
> When you have bitmap=3Dinternal, bitmap updates are synchronous to al=
l
> devices. =A0Maybe that is causing the loss of speed that you see.

Darn, I gave that a brief thought when I was setting it up but later
forgot about it.  I'll have to give it another test.  If so, we should
probably include some docs alongside the write-behind information
noting that you need to put the bitmap externally to see any benefit.

Hopefully I'll have time to get this set up and tested over the next
couple days.

-Dave
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
