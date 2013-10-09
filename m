From: Hristo Chonov <hristochonov@gmail.com>
Subject: Re: mdadm >= 3.0 - udev test rule
Date: Wed, 9 Oct 2013 11:08:33 +0200
Message-ID: <CAHsdBYNZU485BKvm=UPO3QTLigMZ1Wr7qDpW4wfjeEBBPuFCew@mail.gmail.com>
References: <CAHsdBYNPTp1tB9RsLPHAsCaFbSxMA2OZ3cqbqyKsqrjcC7-jkA@mail.gmail.com>
 <525451A4.9070504@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <525451A4.9070504@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

yeah, you are right I had to check the man pages of new udev versions..

But PROGRAM=3D"/bin/test -f md/array_state" will be true if the file
exists and it will go to md_end.
So I guess the proper way to do it will be to introduce a new label
for example something like this:

# container devices have a metadata version of e.g. 'external:ddf' and
# never leave state 'inactive'
ATTR{md/metadata_version}=3D=3D"external:[A-Za-z]*",
ATTR{md/array_state}=3D=3D"inactive", GOTO=3D"md_ignore_state"
PROGRAM=3D"/bin/test -f md/array_state" , ENV{SYSTEMD_READY}=3D"0", GOT=
O=3D"md_test"
GOTO=3D"md_end"
LABEL=3D"md_test"
ATTR{md/array_state}=3D=3D"|clear|inactive", ENV{SYSTEMD_READY}=3D"0", =
GOTO=3D"md_end"
LABEL=3D"md_ignore_state"

I am not sure it if will work with just a single action on line like
GOTO=3D"md_end" but my idea is if PROGRAM is false (the file doesn't
exists) then it will not jump to "md_test" and goes to the next line
which points a jump to "md_end".


Is this going to work?

On Tue, Oct 8, 2013 at 8:40 PM, Martin Wilck <mwilck@arcor.de> wrote:
> On 10/08/2013 02:12 PM, Hristo Chonov wrote:
>> Hello,
>>
>> I have just a simple question about the udev rule:
>> TEST!=3D"md/array_state", GOTO=3D"md_end" or in the last two release=
s with
>> the systemd support: TEST!=3D"md/array_state", ENV{SYSTEMD_READY}=3D=
"0",
>> GOTO=3D"md_end".
>>
>> We are running a XenSever 6.2 system which is based on CentOS 5.7 wi=
th
>> included an old version of udev: udev-095. This version doesn't
>> support the ATTR keyword so I am going to swap it with the old one
>> SYSFS, but it appears that udev doesn't recognize as well the TEST
>> keyword, so I am wondering what exactly this rule is there for? Is i=
t
>> checking if "md/array_state" appears somewhere in the attributes and
>> if not it jumps to "md_end"?
>
> from mdadm(8):
> TEST{octal mode mask}
>            Test the existence of a file. An octal mode mask can be
> specified if needed.
>
> So, this checks if the file "/sys/class/block/md$X/md/array_state"
> exists, and exits otherwise.
>
>> And do you have any idea how the rule should be rewritten for older
>> versions of udev?
>
> It could probably be done with PROGRAM=3D"/bin/test -f md/array_state=
" or
> the like (not tested).
>
> Martin



--=20
Hristo Chonov
kleine Hochstra=DFe 4
60313, Frankfurt am Main
Mobile: 0176 55 33 19 83
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
