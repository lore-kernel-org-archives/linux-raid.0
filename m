From: John Obaterspok <john.obaterspok@gmail.com>
Subject: Re: Hints on reducing kickouts
Date: Sun, 11 Mar 2012 19:55:10 +0100
Message-ID: <CAOscVdL_gTLVVHvFAQzv0XocDVH6t8oBSrqMQUHL5nH3vLQxgA@mail.gmail.com>
References: <CAOscVd+CWwJoRknhGOvexC7w64o_5H-Q+USheTYZULJbJ8EOYA@mail.gmail.com>
	<20120301182218.GB9106@atlantis.cc.ndsu.nodak.edu>
	<CAOscVdKo6aU+H6xGfpMTdN_XCAVnF3V2XXuqN4V5rYBux3e3_Q@mail.gmail.com>
	<20120303222424.GA29339@atlantis.cc.ndsu.nodak.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120303222424.GA29339@atlantis.cc.ndsu.nodak.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Bryan Mesich <bryan.mesich@ndsu.edu>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

mdadm --grow /dev/md2 --bitmap=3Dinternal
mdadm: failed to set internal bitmap.

I then tried it on md1 and this crashed my machine. (bitmap_endwrite
<- handle_stripe)
hmm.

I don't know what to do.

-- John

2012/3/3 Bryan Mesich <bryan.mesich@ndsu.edu>:
> On Sat, Mar 03, 2012 at 10:28:20PM +0100, John Obaterspok wrote:
>> Please see below for errors I get when trying to add internal bitmap=
=2E
>
> [snip...]
>
>> okay, I'm trying to add an interal bitmap to see how much it slows d=
own things:
>>
>> [root@Emperor ~]# mdadm --version
>> mdadm - v3.2.3 - 23rd December 2011
>>
>>
>> [root@Emperor ~]# mdadm --grow --bitmap=3Dinternal /dev/md2
>> mdadm: failed to set internal bitmap.
>
> I think you are using the wrong cmd line syntax. =A0Try the
> following for adding an internal bitmap to /dev/md2
>
> mdadm --grow /dev/md2 --bitmap=3Dinternal
>
> If you want to use an external bitmap, use --bitmap=3D"path to
> file".
>
>> [root@Emperor ~]# mdadm --examine-bitmap /dev/md2
>> =A0 =A0 =A0 =A0 Filename : /dev/md2
>> =A0 =A0 =A0 =A0 =A0 =A0Magic : 00000000
>> mdadm: invalid bitmap magic 0x0, the bitmap file appears to be corru=
pted
>> =A0 =A0 =A0 =A0 =A0Version : 0
>> mdadm: unknown bitmap version 0, either the bitmap file is corrupted
>> or you need to upgrade your tools
>>
>
> [snip...]
>
> Bryan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
