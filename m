From: Chris Worley <worleys@gmail.com>
Subject: Re: Intel Updates SSDs, Supports TRIM, Faster Writes
Date: Mon, 9 Nov 2009 09:37:05 -0700
Message-ID: <f3177b9e0911090837y6f40ee6dy2a88c963465e8718@mail.gmail.com>
References: <4AF7066C.1040507@tmr.com>
	 <70ed7c3e0911081713m7184356buadd6b102fe4755e8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0911081713m7184356buadd6b102fe4755e8@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Nov 8, 2009 at 6:13 PM, Majed B. <majedb@gmail.com> wrote:
> The firmware which introduced the TRIM command was deemed buggy and
> has been pulled out.
>
> Are there any filesystems that are TRIM-aware?

Ext4 (at that level in the kernel, it's referred to as "discard", it's
not TRIM until it's issued as a SCSI command).

Chris
>
> On Sun, Nov 8, 2009 at 8:57 PM, Bill Davidsen <davidsen@tmr.com> wrot=
e:
>> For those of us playing with use of SSD for journals on ext[34], thi=
s does
>> have implications for RAID performance.
>>
>> http://hardware.slashdot.org/story/09/10/27/1427209/Intel-Updates-SS=
Ds-Supports-TRIM-Faster-Writes
>>
>> --
>> Bill Davidsen <davidsen@tmr.com>
>> =A0Unintended results are the well-earned reward for incompetence.
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --
> =A0 =A0 =A0 Majed B.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
