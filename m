From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: Accesses to not yet running array
Date: Sat, 24 Aug 2013 14:42:56 +0200
Message-ID: <CAC9WiBi=fDYmtLv6DPfskyMGfSHVk-J_=5fFsQkdWuigNcHGBw@mail.gmail.com>
References: <CAC9WiBgjEQxe_uymD6WW3Oj5Bm6aYD-RBD-8m3G40c1y3HUb0Q@mail.gmail.com>
	<20130821090634.413491d8@notabene.brown>
	<CAC9WiBiYYOjCVaa5tKVC7Lnkz7fcB2wHM0v2wdQUi=1Ufku5gA@mail.gmail.com>
	<CAC9WiBjBGD0J5vSe+q7y+UVGp2+++Ac++zeQ_=LUz9eQ-kCffA@mail.gmail.com>
	<5217B364.1070704@arcor.de>
	<CAC9WiBg7iRDAj40TFUJVq-TXcktNarhT=3_mCJhOkXnitF8HDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9WiBg7iRDAj40TFUJVq-TXcktNarhT=3_mCJhOkXnitF8HDQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Aug 24, 2013 at 2:40 PM, Francis Moreau <francis.moro@gmail.com> wrote:
> Hello Martin,
>
> On Fri, Aug 23, 2013 at 9:09 PM, Martin Wilck <mwilck@arcor.de> wrote:
>> On 08/23/2013 12:00 PM, Francis Moreau wrote:
>>
>>> [ adding Martin in CC since it seems related to DDF... ]
>>
>> I reproduced it here. The problem is that mdmon isn't running. Simply
>> try running "mdmon /dev/md127", and the mount should proceed.
>>
>
> oh, ok, I should have noticed.
>
>> You'd avoid the problem by running "mdadm -IR /dev/sda" in the first place.
>
> Actually this is how arrays are assembled during boot on some
> distributions (Fedora for example).

I meant the sequence:

mdadm -I /dev/sda
mdadm -I /dev/sdb
mdadm -R /dev/mdxxx

is used by distribution.

-- 
Francis
