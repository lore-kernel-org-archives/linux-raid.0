From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: md extension to support booting from raid whole disks.
Date: Fri, 01 May 2009 23:04:49 +0200
Message-ID: <87ljpgleku.fsf@frosties.localdomain>
References: <1240574900.4507.2076.camel@ezra>
	<87hc0axhg9.fsf@frosties.localdomain> <49F68CE0.2010906@zytor.com>
	<e9c3a7c20904281124g4682d70cp22760176e7a8cfbc@mail.gmail.com>
	<1240957153.18303.689.camel@ezra>
	<e9c3a7c20904281526i59983678mb6fbc10e1761d9f1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20904281526i59983678mb6fbc10e1761d9f1@mail.gmail.com>
	(Dan Williams's message of "Tue, 28 Apr 2009 15:26:31 -0700")
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Daniel Reurich <daniel@centurion.net.nz>, "H. Peter Anvin" <hpa@zytor.com>, Goswin von Brederlow <goswin-v-b@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dan Williams <dan.j.williams@intel.com> writes:

> On Tue, Apr 28, 2009 at 3:19 PM, Daniel Reurich <daniel@centurion.net=
=2Enz> wrote:
>> On Tue, 2009-04-28 at 11:24 -0700, Dan Williams wrote:
>>
>>>
>>> ...or use a metadata format that your platform bios understands and
>>> provides an int 13h vector. =A0See the new external metadata format=
s
>>> supported by the mdadm devel-3.0 branch.
>>
>> I don't think a metadata format is the right way either.
>
> Huh? The bootloader does not need to know anything about raid.  It
> just uses int13 calls to read sectors off a "disk".  The fact that th=
e
> disk is a software raid5 array is completely hidden from grub.  This
> is functionality that has been available via dmraid for some time and
> is now being made available with the MD infrastructure and mdadm.
>
> Regards,
> Dan

And is horribly ugly when you have to switch hardware. And try doing
it with disks from different controlers? What bios supports that?
What bios even supports raid5?

MfG
        Goswin
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
