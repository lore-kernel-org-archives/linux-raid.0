From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: mdadm striped parity RAID with Advanced Format drives
Date: Sat, 23 Jul 2011 11:11:05 +0400
Message-ID: <4E2A7409.60508@msgid.tls.msk.ru>
References: <201107211011.40151.polhallen@fuckaround.org> <4E27FECE.8010201@hardwarefreak.com> <alpine.DEB.2.00.1107211226540.20159@uplift.swm.pp.se> <4E280AEF.4020801@hardwarefreak.com> <4E2A40AC.8080107@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E2A40AC.8080107@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: maurice <mhilarius@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

23.07.2011 07:31, maurice wrote:
> On 7/21/2011 5:18 AM, Stan Hoeppner wrote:
>> ..Ok. Pol, keep in mind that all drives must be identical size when
>> creating an array on raw disks. 
> That always makes me nervous.

And this is not really correct statement.

If you want to be sure, use --size=xxx argument when creating the
array, and specify a size smaller than size of your drives. This
way, you can avoid possible problems with drive size fluctuations
and different size of a replacement drives from another manufacturer.
Also, the "fluctuations" - i mean, several drives in the same batch
may have slightly different size - will be masked out by mdadm itself,
due to rounding to chunk size.

Just use a few gigs less than your drive size is.  Maybe the resulting
size will be a nice power-of-two value, as well.

> I have seen the case before where a drive has been "kicked out" and when
> you go to add it back, it is refused as "too small"
> Grown defects have shrunk the device.

This CAN NOT HAPPEN.  Drive never changes its size.  Newly
discovered defects gets remapped to _reserved_ space, not to
a space taken from other data.  If the drive runs out of
reserved space (but you should replace it WAY before that),
it will stop remapping sectors.

> I find it is safer to make one big partition on each device, and make
> this a bit smaller than the device.

That works too, ofcourse.  This way, it might be a bit easier to
identify your drives too - for example, you can use GPT partition
table there with proper labels for your partition.

/mjt
