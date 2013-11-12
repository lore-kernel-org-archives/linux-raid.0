From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 3.12: raid-1 mismatch_cnt question
Date: Tue, 12 Nov 2013 04:14:15 -0500
Message-ID: <CAO9zADwwhw9qQ7GMh45-4AXktp8UmsVOLDVVwSfc5gQS1QTENQ@mail.gmail.com>
References: <000f01ced948$2fbab140$8f3013c0$@lucidpixels.com>
	<CAO9zADxbiW_OBiewAY8JQQjxS51Ydrm8Rj1=MWXCA+Xo9K3=2Q@mail.gmail.com>
	<528178B8.4000704@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <528178B8.4000704@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: open list <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Nov 11, 2013 at 7:39 PM, Brad Campbell
<lists2009@fnarfbargle.com> wrote:
> On 11/07/2013 06:54 PM, Justin Piszcz wrote:
>>
>> On Mon, Nov 4, 2013 at 5:25 AM, Justin Piszcz <jpiszcz@lucidpixels.com>
>> wrote:
>>>
>>> Hi,
>>>
>>> I run two SSDs in a RAID-1 configuration and I have a swap partition on a
>>> third SSD.  Over time, the mismatch_cnt between the two devices grows
>>> higher
>>> and higher.
>>>
>
> Are both SSD's identical? Do you have discard enabled on the filesystem?
Yes (2 x Intel SSDSC2CW240A3) & yes )/dev/root on / type ext4
(rw,relatime,discard,data=ordered))

>
> The reason I ask is I have a RAID10 comprised of 3 Intel and 3 Samsung
> SSD's. The Intel return 0 after TRIM while the Samsung don't, so I _always_
> have a massive mismatch_cnt after I run fstrim. I never use a repair
> operation as it's just going to re-write the already trimmed sectors.
Very interesting and good to know!

Justin.
