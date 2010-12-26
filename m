From: CoolCold <coolthecold@gmail.com>
Subject: Re: Is It Hopeless?
Date: Sun, 26 Dec 2010 23:19:49 +0300
Message-ID: <AANLkTikPLt3xeuBDRe4R6nXJ32Bw5derMrkMn2GexgSM@mail.gmail.com>
References: <201012261019.56481.CACook@quantum-sci.com>
	<20101227071156.2371d7d8@notabene.brown>
	<201012261219.41912.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201012261219.41912.CACook@quantum-sci.com>
Sender: linux-raid-owner@vger.kernel.org
To: Carl Cook <CACook@quantum-sci.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Dec 26, 2010 at 11:19 PM, Carl Cook <CACook@quantum-sci.com> wr=
ote:
>
> My God, it didn't have the command fsck.jfs, so I reinstalled jfsutil=
s. =A0Now the array mounts.
>
> I don't understand it. =A0I thought the JFS driver is in the kernel?
Driver is, but userland tools ( fsck.jfs ) are not.
>
>
> On Sun 26 December 2010 12:11:56 Neil Brown wrote:
>> On Sun, 26 Dec 2010 10:19:55 -0800 Carl Cook <CACook@quantum-sci.com=
> wrote:
>>
>> > I went in to turn on my home theater system today, and found a bla=
nk screen. =A0I rebooted and it would not mount /home, which is a 4TB R=
AID10 array with every movie and show I've recorded over the past two y=
ears. =A0I try to mount it manually, and "wrong fs or bad superblock". =
=A0The array is getting set up fine, but the filesystem seems to be des=
troyed.
>> >
>> > Unbelievable. =A0This isn't supposed to happen. =A0It happened onc=
e before when I wasn't using RAID, but that was the BTRFS filesystem an=
d I blamed it for being pre-release. =A0But now it's RAID10 with JFS.
>>
>> None of your logs show anything about jfs....
>>
>> What does
>> =A0 fsck.jfs /dev/md2
>> report?
>> What about
>> =A0 mount -t jfs /dev/md2 /home
>>
>> ??
>>
>> NeilBrown
>>
>>
>> >
>> > The only sign of trouble:
>> > Dec 25 16:14:56 cygnus shutdown[2180]: shutting down for system re=
boot
>> > Dec 25 16:14:58 cygnus kernel: [16607.840197] md: md2 stopped.
>> > Dec 25 16:14:58 cygnus kernel: [16607.840210] md: unbind<sdb3>
>> > Dec 25 16:14:58 cygnus kernel: [16607.852029] md: export_rdev(sdb3=
)
>> > Dec 25 16:14:58 cygnus kernel: [16607.852083] md: unbind<sdc3>
>> > Dec 25 16:14:58 cygnus kernel: [16607.864031] md: export_rdev(sdc3=
)
>> > Dec 25 16:14:58 cygnus kernel: [16607.864092] md2: detected capaci=
ty change from 1913403736064 to 0
>> > Dec 25 16:15:00 cygnus kernel: Kernel logging (proc) stopped.
>> >
>> > Reboot:
>> > Dec 25 16:15:48 cygnus kernel: [ =A0 =A01.156657] Uniform CD-ROM d=
river Revision: 3.20
>> > Dec 25 16:15:48 cygnus kernel: [ =A0 =A01.464298] md: raid10 perso=
nality registered for level 10
>> > Dec 25 16:15:48 cygnus kernel: [ =A0 =A01.469307] md: md2 stopped.
>> > Dec 25 16:15:48 cygnus kernel: [ =A0 =A01.470540] md: bind<sdc3>
>> > Dec 25 16:15:48 cygnus kernel: [ =A0 =A01.470642] md: bind<sdb3>
>> > Dec 25 16:15:48 cygnus kernel: [ =A0 =A01.471381] raid10: raid set=
 md2 active with 2 out of 2 devices
>> > Dec 25 16:15:48 cygnus kernel: [ =A0 =A01.476048] md2: bitmap init=
ialized from disk: read 14/14 pags, set 0 bits
>> > Dec 25 16:15:48 cygnus kernel: [ =A0 =A01.476050] created bitmap (=
223 pages) for device md2
>> > Dec 25 16:15:48 cygnus kernel: [ =A0 =A01.488465] md2: detected ca=
pacity change from 0 to 1913403736064
>> > Dec 25 16:15:48 cygnus kernel: [ =A0 =A01.488942] =A0md2: unknown =
partition table
>> > Dec 25 16:15:48 cygnus kernel: [ =A0 =A01.597375] PM: Starting man=
ual resume from disk
>> > Dec 25 16:15:48 cygnus kernel: [ =A0 =A01.650832] kjournald starti=
ng. =A0Commit interval 5 seconds
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-ra=
id" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
