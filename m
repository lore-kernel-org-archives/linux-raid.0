From: Simon Mcnair <simonmcnair@gmail.com>
Subject: Re: Linux software RAID assistance
Date: Thu, 17 Feb 2011 14:34:48 +0000
Message-ID: <AANLkTik6k7kG1CEj=ESsjUcDJVp58cG_bV4Jx3zrd7LM@mail.gmail.com>
References: <4D540F6C.6050904@gmail.com>
	<20110215155315.55d35b8e@notabene.brown>
	<4D5A92F3.1090004@turmel.org>
	<4D5BD678.2050200@gmail.com>
	<4D5BE119.7000804@turmel.org>
	<4D5C0E17.3060306@gmail.com>
	<4D5C140F.9010301@turmel.org>
	<4D5C1508.3040308@gmail.com>
	<4D5C15D3.1070608@turmel.org>
	<4D5C167C.7000101@turmel.org>
	<4D5C1CF8.1020507@gmail.com>
	<4D5C1E0B.9060300@turmel.org>
	<4D5C2061.4060106@gmail.com>
	<4D5C2143.3000907@turmel.org>
	<4D5C2260.3020800@gmail.com>
	<4D5C273E.7020609@turmel.org>
	<4D5C4176.80604@gmail.com>
	<4D5C4204.5020106@turmel.org>
	<1377706586882297883@unknownmsgid>
	<4D5C6016.6060809@turmel.org>
	<AANLkTi=P5vPKa0JwqcjM3D6u2v9AaK9D35SbJv8Yn+0E@mail.gmail.com>
	<4D5D2723.1010101@turmel.org>
	<6037962689649361915@unknownmsgid>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6037962689649361915@unknownmsgid>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: NeilBrown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

19390 root       17.49 M/s       0 B/s  0.00 % 21.36 % dd if /dev/sde b=
s 1M
19333 root       16.52 M/s       0 B/s  0.00 % 17.07 % dd if /dev/sdd b=
s 1M
19503 root       15.79 M/s       0 B/s  0.00 % 13.91 % dd if /dev/sdf b=
s 1M
18896 root           0 B/s   16.10 M/s  0.00 %  0.00 % ntfs-3g
/dev/sdb1 /media/ntfs3g/sdb
18909 root           0 B/s   13.49 M/s  0.00 %  0.00 % ntfs-3g
/dev/sdc1 /media/ntfs3g/sdc
18920 root           0 B/s   15.73 M/s  0.00 %  0.00 % ntfs-3g
/dev/sdn1 /media/ntfs3g/sdn

this will certainly be quicker :-)

On 17 February 2011 13:56, Simon Mcnair <simonmcnair@gmail.com> wrote:
> Phil, I think I need to connect them to the crippled machine directly=
,
> I was just trying to leave it alone, I know that doesn't make much
> sense but I'm more familiar with windows than Linux. The cards that I
> have are all connected at gigabit and bonded. That machine has two
> ports, so does the other. I'm running two asus p6ts (1 deluxe and 1
> se) with i7 920's
>
> I cant understand why it's so slow though I have seen some reports
> that the supermicro card is quite slow.
> Simon
> Ps thanks for the bugfixes and updates
> Simon
>
> On 17 Feb 2011, at 13:48, Phil Turmel <philip@turmel.org> wrote:
>
>> On 02/17/2011 08:26 AM, Simon Mcnair wrote:
>>> Phil,
>>> After a couple of attempts I realised that all I needed to do was
>>> ./backup.sh sdi rather than specifying ./backup.sh /dev/sdi =A0scho=
olboy
>>> error huh, rtfm.
>>>
>>> I tried modifying the code, so I could kick them all off at once, b=
ut
>>> I wanted to check that this would work from a multithreaded/sane
>>> perspective (yes I know it's a bit of IO, but iotop seems to infer =
I'm
>>> only getting 10M/s throughput from the disk anyway).
>>
>> That sounds suspiciously like a 100 meg ethernet bottleneck, so para=
llel operation won't help. =A0If so, this'll take a very long time.
>>
>>> is this code kosha ?
>>
>> Looks pretty good. =A0I've attached a slight update with your change=
s and a bugfix.
>>
>>> #! /bin/bash
>>> #
>>> function usage() {
>>> =A0 =A0 =A0 printf "Usage:\n\t%s devname\n\n" "`basename \"$0\"`"
>>> =A0 =A0 =A0 printf "'devname' must be a relative path in /dev/ to t=
he
>>> desired block device.\n"
>>> =A0 =A0 =A0 exit 1
>>> }
>>>
>>> # Verify the supplied name is a device
>>> test -b "/dev/$1" || usage
>>>
>>> # Convert path separators and spaces into dashes
>>> outfile=3D"`echo \"$1\" |sed -r -e 's:[ /]+:-:g'`"
>>>
>>> # Create a side-stream for computing the MD5 of the data read
>>> fifo=3D`mktemp -u`
>>> mkfifo $fifo || exit
>>> md5sum -b <$fifo >$2/$outfile.md5 &
>>>
>>> # Read the device and compress it
>>> dd if=3D"/dev/$1" bs=3D1M | tee 2>$fifo | gzip >$2/$outfile.gz
>>>
>>> # Wait for the background task to close
>>> wait
>>>
>>> I was a little concerned as I didn't see the hdd drive LED light up
>>> for my attempt even though the file was growing nicely on my CIFS
>>> share. =A0I'm dumping it on the 5x2TB disks (JBOD) in my windows 7 =
box
>>> as my Thecus is not a happy chappy and I need time to mount the DOM
>>> module in another machine to find out why.
>>
>> If you're willing to dismantle the thecus, directly connecting its d=
rives to your crippled system will make things go much faster. =A0You'v=
e got four empty motherboard SATA ports. =A0You just have to watch out =
for the power load.
>>
>> Phil
>> <block2gz.sh>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
