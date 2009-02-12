From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 00/18] Assorted md patches headed for 2.6.30
Date: Thu, 12 Feb 2009 15:57:12 -0700
Message-ID: <e9c3a7c20902121457qe279b54y10ead241766f1fa4@mail.gmail.com>
References: <20090212031009.23983.14496.stgit@notabene.brown>
	 <20090212081148.GD9439@rap.rap.dk>
	 <4993E82D.1020309@fairbairn-family.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4993E82D.1020309@fairbairn-family.com>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Fairbairn <steve@fairbairn-family.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Feb 12, 2009 at 2:13 AM, Steve Fairbairn
<steve@fairbairn-family.com> wrote:
> Keld J=F8rn Simonsen wrote:
>>
>> I would rather have functionality to convert raid10 to raid5.
>> raid1 should be depreciated, as raid10,n2 for all purposes is the sa=
me
>> but better implementation and performance, and raid10,f2 and raid10,=
o2
>> are even better.  Nobody should use raid1 anymore.
>>
> Complete ignorance of raid10 here, but is raid10,<anything> bootable,=
 like
> raid1 is?  I use raid1 on my root and boot partitions.
>

I would point out that raid1 is not, strictly speaking, bootable.
Yes, it happens to work because the bootloader can treat each disk as
a standalone device, but the bootloader has no idea if a given disk is
failed, rebuilding, or in-sync.  To reliably boot from raid you need
an option-rom that understands the on disk metadata format and exposes
the array as a single device to the bootloader.

Regards,
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
