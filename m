From: Chris Worley <worleys@gmail.com>
Subject: Re: Intel Updates SSDs, Supports TRIM, Faster Writes
Date: Mon, 9 Nov 2009 09:59:38 -0700
Message-ID: <f3177b9e0911090859j40a87433r342d2c49b46d015c@mail.gmail.com>
References: <4AF7066C.1040507@tmr.com>
	 <70ed7c3e0911081713m7184356buadd6b102fe4755e8@mail.gmail.com>
	 <f3177b9e0911090837y6f40ee6dy2a88c963465e8718@mail.gmail.com>
	 <70ed7c3e0911090842i167175a0q44fc5ad50a2f1759@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0911090842i167175a0q44fc5ad50a2f1759@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Nov 9, 2009 at 9:42 AM, Majed B. <majedb@gmail.com> wrote:
> Well, SATA uses SCSI emulation so I guess that's no problem, right?

The only problem is SSD's put Solid State Storage (SSS) behind
SATA/SAS controllers... while compatible w/ old disk technology, it
severely limits performance (i.e. none of these SSD drives do even
300MB/s... while SSS drives do 800MB/s).  While the initial 2.6.27
drivers and ext4 "discard" worked very well with forward-thinking SSS
not encumbered by old controller technology... but, SSD's were not
able to handle it well:

http://lwn.net/Articles/347511/

So it looks like "design by committee" Linux is well behind Windows 7,
while Linux contemplates slowing new technology down to optimize for
ill-designed SSD's.

Be glad "thumb drives" didn't try to be floppy-drive-compatible!!!

Chris
>
> On Mon, Nov 9, 2009 at 7:37 PM, Chris Worley <worleys@gmail.com> wrot=
e:
>> On Sun, Nov 8, 2009 at 6:13 PM, Majed B. <majedb@gmail.com> wrote:
>>> The firmware which introduced the TRIM command was deemed buggy and
>>> has been pulled out.
>>>
>>> Are there any filesystems that are TRIM-aware?
>>
>> Ext4 (at that level in the kernel, it's referred to as "discard", it=
's
>> not TRIM until it's issued as a SCSI command).
>>
>> Chris
>>>
>>> On Sun, Nov 8, 2009 at 8:57 PM, Bill Davidsen <davidsen@tmr.com> wr=
ote:
>>>> For those of us playing with use of SSD for journals on ext[34], t=
his does
>>>> have implications for RAID performance.
>>>>
>>>> http://hardware.slashdot.org/story/09/10/27/1427209/Intel-Updates-=
SSDs-Supports-TRIM-Faster-Writes
>>>>
>>>> --
>>>> Bill Davidsen <davidsen@tmr.com>
>>>> =A0Unintended results are the well-earned reward for incompetence.
>>>>
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-ra=
id" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
>>>>
>>>
>>>
>>>
>>> --
>>> =A0 =A0 =A0 Majed B.
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>>>
>>
>
>
>
> --
> =A0 =A0 =A0 Majed B.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
