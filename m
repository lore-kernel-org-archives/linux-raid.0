From: Phil Turmel <philip@turmel.org>
Subject: Re: broken raid level 5 array caused by user error
Date: Tue, 10 Nov 2015 20:00:22 -0500
Message-ID: <56429326.5030405@turmel.org>
References: <3c05d813e42324cdf95989784f6d7b17@pingofdeath.de>
 <56426499.8000205@turmel.org>
 <ceee2de5aba3ca77efc1146e19896b90@pingofdeath.de>
 <564284F5.9080409@turmel.org>
 <b0cdddd4394bbc1356980bb61ac199c3@pingofdeath.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <b0cdddd4394bbc1356980bb61ac199c3@pingofdeath.de>
Sender: linux-raid-owner@vger.kernel.org
To: Mathias Mueller <raidfail@gmx.de>
Cc: Linux raid <linux-raid@vger.kernel.org>, linux-raid-owner@vger.kernel.org
List-Id: linux-raid.ids

On 11/10/2015 07:06 PM, Mathias Mueller wrote:
> Hi Phil
> 
>> Hmmm.  Very strange.  Let's see the dump of the start of the data area
>> of all four partitions:
>>
>> for x in /dev/sd[efgh]1 ; do echo -e "\n$x\n" ; dd if=$x skip=2048
>> count=16 2>/dev/null |hexdump -C ; done

Very good.

sdf1 is definitely first.  sdh1 is definitely last.  I don't see
anything obviously wrong with the superblock.  The handful of fields
I've looked at are appropriate, including the magic number, write
timestamp, and last mount point.  (/srv).

So, I fully expected one of those first four combinations to work.  I
don't know why they didn't.

The fsck version dates to 2013, so it might be something related to
that.  My next step would be to try all of this after booting into a
modern environment, like the rescue cd from sysrescuecd.org.  Recheck
serial numbers and device names again, if you do that.

If that fails the same way, I'm at a loss.  You might want to point the
ext4 mailing list at this thread's archive and ask for advice.  There's
some possibility of trying various backup superblocks if they can be
located -- I'm not confident enough to advise you on that.

Phil

