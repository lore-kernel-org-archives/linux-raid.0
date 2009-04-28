From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: md extension to support booting from raid whole disks.
Date: Tue, 28 Apr 2009 15:26:31 -0700
Message-ID: <e9c3a7c20904281526i59983678mb6fbc10e1761d9f1@mail.gmail.com>
References: <1240574900.4507.2076.camel@ezra>
	 <87hc0axhg9.fsf@frosties.localdomain> <49F68CE0.2010906@zytor.com>
	 <e9c3a7c20904281124g4682d70cp22760176e7a8cfbc@mail.gmail.com>
	 <1240957153.18303.689.camel@ezra>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1240957153.18303.689.camel@ezra>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Reurich <daniel@centurion.net.nz>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Goswin von Brederlow <goswin-v-b@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Apr 28, 2009 at 3:19 PM, Daniel Reurich <daniel@centurion.net.n=
z> wrote:
> On Tue, 2009-04-28 at 11:24 -0700, Dan Williams wrote:
>
>>
>> ...or use a metadata format that your platform bios understands and
>> provides an int 13h vector. =A0See the new external metadata formats
>> supported by the mdadm devel-3.0 branch.
>
> I don't think a metadata format is the right way either.

Huh? The bootloader does not need to know anything about raid.  It
just uses int13 calls to read sectors off a "disk".  The fact that the
disk is a software raid5 array is completely hidden from grub.  This
is functionality that has been available via dmraid for some time and
is now being made available with the MD infrastructure and mdadm.

Regards,
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
