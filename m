From: Robin Bowes <robin-lists@robinbowes.com>
Subject: Re: non-optimal RAID 5 performance with 8 drive array
Date: Tue, 01 Mar 2005 17:53:54 +0000
Message-ID: <d029u5$65p$1@sea.gmane.org>
References: <42246D1F.3070407@variant.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <42246D1F.3070407@variant.ch>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Nicola Fankhauser wrote:
> see [3] for a description of what I did and more details.

Hi Nicola,

I read your description with interest.

I thought I'd try some speed tests myself but dd doesn't seem to work 
the same for me (on FC3). Here's what I get:

[root@dude test]# dd if=/dev/zero of=/home/test/test.tmp bs=4096 
count=100000
100000+0 records in
100000+0 records out

Notice there is no timing information.

For the read test:

[root@dude test]# dd of=/dev/null if=/home/test/test.tmp bs=4096
100000+0 records in
100000+0 records out

Again, no timing information.

Anyone know if this is a quirk of the FC3 version of dd?

R.
-- 
http://robinbowes.com

