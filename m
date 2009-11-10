From: Chris Worley <worleys@gmail.com>
Subject: Re: Intel Updates SSDs, Supports TRIM, Faster Writes
Date: Tue, 10 Nov 2009 08:39:43 -0700
Message-ID: <f3177b9e0911100739p56a98992p26f9a42e8b689dcf@mail.gmail.com>
References: <4AF7066C.1040507@tmr.com>
	 <70ed7c3e0911081713m7184356buadd6b102fe4755e8@mail.gmail.com>
	 <f3177b9e0911090837y6f40ee6dy2a88c963465e8718@mail.gmail.com>
	 <70ed7c3e0911090842i167175a0q44fc5ad50a2f1759@mail.gmail.com>
	 <f3177b9e0911090859j40a87433r342d2c49b46d015c@mail.gmail.com>
	 <1257846132.22155.155.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1257846132.22155.155.camel@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: Kasper Sandberg <postmaster@metanurb.dk>
Cc: "Majed B." <majedb@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Nov 10, 2009 at 2:42 AM, Kasper Sandberg <postmaster@metanurb.d=
k> wrote:
> On Mon, 2009-11-09 at 09:59 -0700, Chris Worley wrote:
>> On Mon, Nov 9, 2009 at 9:42 AM, Majed B. <majedb@gmail.com> wrote:
>> > Well, SATA uses SCSI emulation so I guess that's no problem, right=
?
>>
>> The only problem is SSD's put Solid State Storage (SSS) behind
>> SATA/SAS controllers... while compatible w/ old disk technology, it
>> severely limits performance (i.e. none of these SSD drives do even
>> 300MB/s... while SSS drives do 800MB/s). =A0While the initial 2.6.27
> No, around 280MB/s... and obviously they dont do more, because of the
> simple limitation of the sata controllers.. this also means they dont
> need to do as many channels as other devices..

I'm not sure if you're agreeing or disagreeing here...
280MB/s<300MB/s, due to the "compatibility" based design of SSD's,
while SSS, w/o a legacy controller, can do 800MB/s out of a single
drive.

>> drivers and ext4 "discard" worked very well with forward-thinking SS=
S
>> not encumbered by old controller technology... but, SSD's were not
>> able to handle it well:
>>
>> http://lwn.net/Articles/347511/
>>
>> So it looks like "design by committee" Linux is well behind Windows =
7,
> And how exactly does windows 7 handle this so much better?

TRIM is in W7; NTFS support.  No Linux distro does.  And by the time
"design by committee" gets through with it,we shouldn't have bothered.

>> while Linux contemplates slowing new technology down to optimize for
>> ill-designed SSD's.
> It does?

Those that speak loudest in the kernel development (and contribute the
most) work for companies like Intel that promote the slower,
controller-based, SSD's.

Chris
>>
>> Be glad "thumb drives" didn't try to be floppy-drive-compatible!!!
>>
>> Chris
>> >
>> > On Mon, Nov 9, 2009 at 7:37 PM, Chris Worley <worleys@gmail.com> w=
rote:
>> >> On Sun, Nov 8, 2009 at 6:13 PM, Majed B. <majedb@gmail.com> wrote=
:
>> >>> The firmware which introduced the TRIM command was deemed buggy =
and
>> >>> has been pulled out.
>> >>>
>> >>> Are there any filesystems that are TRIM-aware?
>> >>
>> >> Ext4 (at that level in the kernel, it's referred to as "discard",=
 it's
>> >> not TRIM until it's issued as a SCSI command).
>> >>
>> >> Chris
>> >>>
>> >>> On Sun, Nov 8, 2009 at 8:57 PM, Bill Davidsen <davidsen@tmr.com>=
 wrote:
>> >>>> For those of us playing with use of SSD for journals on ext[34]=
, this does
>> >>>> have implications for RAID performance.
>> >>>>
>> >>>> http://hardware.slashdot.org/story/09/10/27/1427209/Intel-Updat=
es-SSDs-Supports-TRIM-Faster-Writes
>> >>>>
>> >>>> --
>> >>>> Bill Davidsen <davidsen@tmr.com>
>> >>>> =A0Unintended results are the well-earned reward for incompeten=
ce.
>> >>>>
>> >>>>
>> >>>> --
>> >>>> To unsubscribe from this list: send the line "unsubscribe linux=
-raid" in
>> >>>> the body of a message to majordomo@vger.kernel.org
>> >>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info=
=2Ehtml
>> >>>>
>> >>>
>> >>>
>> >>>
>> >>> --
>> >>> =A0 =A0 =A0 Majed B.
>> >>> --
>> >>> To unsubscribe from this list: send the line "unsubscribe linux-=
raid" in
>> >>> the body of a message to majordomo@vger.kernel.org
>> >>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.=
html
>> >>>
>> >>
>> >
>> >
>> >
>> > --
>> > =A0 =A0 =A0 Majed B.
>> >
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
