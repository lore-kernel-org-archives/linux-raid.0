From: Simon Mcnair <simonmcnair@gmail.com>
Subject: Re: Linux software RAID assistance
Date: Thu, 17 Feb 2011 13:26:34 +0000
Message-ID: <AANLkTi=P5vPKa0JwqcjM3D6u2v9AaK9D35SbJv8Yn+0E@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5C6016.6060809@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: NeilBrown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Phil,
After a couple of attempts I realised that all I needed to do was
=2E/backup.sh sdi rather than specifying ./backup.sh /dev/sdi  schoolbo=
y
error huh, rtfm.

I tried modifying the code, so I could kick them all off at once, but
I wanted to check that this would work from a multithreaded/sane
perspective (yes I know it's a bit of IO, but iotop seems to infer I'm
only getting 10M/s throughput from the disk anyway).

is this code kosha ?

#! /bin/bash
#
function usage() {
       printf "Usage:\n\t%s devname\n\n" "`basename \"$0\"`"
       printf "'devname' must be a relative path in /dev/ to the
desired block device.\n"
       exit 1
}

# Verify the supplied name is a device
test -b "/dev/$1" || usage

# Convert path separators and spaces into dashes
outfile=3D"`echo \"$1\" |sed -r -e 's:[ /]+:-:g'`"

# Create a side-stream for computing the MD5 of the data read
fifo=3D`mktemp -u`
mkfifo $fifo || exit
md5sum -b <$fifo >$2/$outfile.md5 &

# Read the device and compress it
dd if=3D"/dev/$1" bs=3D1M | tee 2>$fifo | gzip >$2/$outfile.gz

# Wait for the background task to close
wait

I was a little concerned as I didn't see the hdd drive LED light up
for my attempt even though the file was growing nicely on my CIFS
share.  I'm dumping it on the 5x2TB disks (JBOD) in my windows 7 box
as my Thecus is not a happy chappy and I need time to mount the DOM
module in another machine to find out why.

cheers
Simon


On 16 February 2011 23:39, Phil Turmel <philip@turmel.org> wrote:
> On 02/16/2011 05:44 PM, Simon Mcnair wrote:
>> I just went to bed and one last question popped in to my mind. Since
>> there is a fair timezone gap I thought I'd be presumptuous and ask i=
t
>> in the hope I can turn it around a bit quicker in the morning.
>>
>> My suspicion is that once I have 5 formatted 2tb drives I may be luc=
ky
>> to get 10x 1tb dd images on to it. Can I feed the dd process in to
>> tar, bzip2, zip or something else which will give me enough space to
>> fit the images on ?
>>
>> Will I get more usable space from 5x2tb partitions or from 1xspanned
>> volume ? (the thecus pretty much only allows you to create raid
>> volumes so a jbod needs to be 5x1tb arrays or 1 spanned volume or
>> stripe).
>
> I'd use one spanned volume, and gzip. =A0I'd simultaneously generate =
an md5sum while streaming to your thecus. =A0A script like so:
>
> #! /bin/bash
> #
> function usage() {
> =A0 =A0 =A0 =A0printf "Usage:\n\t%s devname\n\n" "`basename \"$0\"`"
> =A0 =A0 =A0 =A0printf "'devname' must be a relative path in /dev/ to =
the desired block device.\n"
> =A0 =A0 =A0 =A0exit 1
> }
>
> # Verify the supplied name is a device
> test -b "/dev/$1" || usage
>
> # Convert path separators and spaces into dashes
> outfile=3D"`echo \"$1\" |sed -r -e 's:[ /]+:-:g'`"
>
> # Create a side-stream for computing the MD5 of the data read
> fifo=3D`mktemp -u`
> mkfifo $fifo || exit
> md5sum -b <$fifo >/mnt/thecus/$outfile.md5 &
>
> # Read the device and compress it
> dd if=3D"/dev/$1" bs=3D1M | tee 2>$fifo | gzip >/mnt/thecus/$outfile.=
gz
>
> # Wait for the background task to close
> wait
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
