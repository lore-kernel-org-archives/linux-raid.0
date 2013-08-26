From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: Accesses to not yet running array
Date: Mon, 26 Aug 2013 09:30:04 +0200
Message-ID: <CAC9WiBiJ5vwZ7ngxv3CXZhbDTT7X_mtocVAtixRny427XwfFag@mail.gmail.com>
References: <CAC9WiBgjEQxe_uymD6WW3Oj5Bm6aYD-RBD-8m3G40c1y3HUb0Q@mail.gmail.com>
	<20130821090634.413491d8@notabene.brown>
	<CAC9WiBiYYOjCVaa5tKVC7Lnkz7fcB2wHM0v2wdQUi=1Ufku5gA@mail.gmail.com>
	<CAC9WiBjBGD0J5vSe+q7y+UVGp2+++Ac++zeQ_=LUz9eQ-kCffA@mail.gmail.com>
	<5217B364.1070704@arcor.de>
	<20130826153021.6075fb8b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130826153021.6075fb8b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Martin Wilck <mwilck@arcor.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Neil,

On Mon, Aug 26, 2013 at 7:30 AM, NeilBrown <neilb@suse.de> wrote:
> On Fri, 23 Aug 2013 21:09:24 +0200 Martin Wilck <mwilck@arcor.de> wrote:
>
>> On 08/23/2013 12:00 PM, Francis Moreau wrote:
>>
>> > [ adding Martin in CC since it seems related to DDF... ]
>>
>> I reproduced it here. The problem is that mdmon isn't running. Simply
>> try running "mdmon /dev/md127", and the mount should proceed.
>>
>> You'd avoid the problem by running "mdadm -IR /dev/sda" in the first place.
>>
>> @Neil: This is unexpected, I think we need some code to start mdmon if
>> necessary in Manage_run. I considered coming up with a patch, but you
>> can do it much quicker, I think.
>>
>
> I've changed Manage_run() to call the same code that "mdadm -IRs" call, but
> asking to just run the one array, not all arrays.
> This should  do what is expected (I hope).


Any chance to get the same fix for 3.2.x release ?

Thanks
-- 
Francis
