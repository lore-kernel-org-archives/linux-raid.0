From: "Tirumala Reddy Marri" <tmarri@amcc.com>
Subject: RE: Why does one get mismatches?
Date: Thu, 28 Jan 2010 11:03:59 -0800
Message-ID: <AC5E1C3367E37D44970B81A6ADD1DA2C08AE18C4@SDCEXCHANGE01.ad.amcc.com>
References: <201001252043.o0PKhseR027690@wind.enjellic.com><27F5783C-96DC-4B04-A3EF-D5E7F5F1DD6B@crc.id.au><AC5E1C3367E37D44970B81A6ADD1DA2C08AE1690@SDCEXCHANGE01.ad.amcc.com><AC5E1C3367E37D44970B81A6ADD1DA2C08AE1842@SDCEXCHANGE01.ad.amcc.com> <87iqamxf4l.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <87iqamxf4l.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: goswin-v-b@web.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I just tried and miss-match count is zero. Interesting, is XOR engine
doing something wrong ? . Then I ran a test where I raw-write the file
to /dev/md0. Then did the raw-read for the same size. In this case XOR
matched as expected. Then I failed a drive using "mdadm -f /dev/md0
/dev/sda". Then I read the same size data again from /dev/md0. And
checksum matches too. 
What is this mean XOR engine is doing right thing. But "chec/repair"
test is not functioning properly with XOR-engine ?

Or is this something to do with  how the buffers are handled ? may they
are cached ?


-Marri



-----Original Message-----
From: goswin-v-b@web.de [mailto:goswin-v-b@web.de] 
Sent: Thursday, January 28, 2010 10:24 AM
To: Tirumala Reddy Marri
Cc: linux-raid@vger.kernel.org
Subject: Re: Why does one get mismatches?

"Tirumala Reddy Marri" <tmarri@amcc.com> writes:

> I have noticed that if I zero the /dev/md0 using "dd if=/dev/zero
> of=/dev/md0 bs=4k count=64k". Then I run the "echo check >
> /sys/block/md0/md/sync_action", no mismatch_cnt reported.  If I use
> "if=/some/file" then I see miss match count to set to huge number.
>
> I am testing with small RAID-5 size for quick testing.  How a reliable
> is this test ? I am using HW accelerated XOR engine for RAID-5.

Have you tried without?

Maybe the XOR engine creates garbage.

MfG
        Goswin
