From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: Intel Updates SSDs, Supports TRIM, Faster Writes
Date: Mon, 9 Nov 2009 13:42:42 -0500
Message-ID: <87f94c370911091042p16901956wdb2e0f9561b5eb30@mail.gmail.com>
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

On Sun, Nov 8, 2009 at 8:13 PM, Majed B. <majedb@gmail.com> wrote:
> The firmware which introduced the TRIM command was deemed buggy and
> has been pulled out.
>
> Are there any filesystems that are TRIM-aware?
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
> --
> =A0 =A0 =A0 Majed B.

Majed,

There are various ways to address the TRIM issue.

My favorite is to have a once a day (or whatever) process invoked by
cron that scans a filesystem for unused space, then calls trim on all
of the unused chunks.

Mark Lord had this working via fallocate calls from user space a
couple months ago.

See <http://markmail.org/message/rytr4jqx52h2wftm>

fyi: Mark Lord is the hdparm maintainer and I think you can get his
userspace stuff from sourceforge.  I think the kernel code is already
in vanilla.

fyi2: I have not had my hands on a trim capable SSD so I have not
tried Mark's code yet.

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
