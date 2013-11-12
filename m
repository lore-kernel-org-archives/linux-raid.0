From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: 3.12: raid-1 mismatch_cnt question
Date: Tue, 12 Nov 2013 08:39:20 +0800
Message-ID: <528178B8.4000704@fnarfbargle.com>
References: <000f01ced948$2fbab140$8f3013c0$@lucidpixels.com> <CAO9zADxbiW_OBiewAY8JQQjxS51Ydrm8Rj1=MWXCA+Xo9K3=2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAO9zADxbiW_OBiewAY8JQQjxS51Ydrm8Rj1=MWXCA+Xo9K3=2Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>, open list <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/07/2013 06:54 PM, Justin Piszcz wrote:
> On Mon, Nov 4, 2013 at 5:25 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>> Hi,
>>
>> I run two SSDs in a RAID-1 configuration and I have a swap partition on a
>> third SSD.  Over time, the mismatch_cnt between the two devices grows higher
>> and higher.
>>

Are both SSD's identical? Do you have discard enabled on the filesystem?

The reason I ask is I have a RAID10 comprised of 3 Intel and 3 Samsung 
SSD's. The Intel return 0 after TRIM while the Samsung don't, so I 
_always_ have a massive mismatch_cnt after I run fstrim. I never use a 
repair operation as it's just going to re-write the already trimmed sectors.


Just a thought.


