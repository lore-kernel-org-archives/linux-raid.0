From: Simon Mcnair <simonmcnair@gmail.com>
Subject: Re: Linux software RAID assistance
Date: Thu, 17 Feb 2011 13:56:15 +0000
Message-ID: <6037962689649361915@unknownmsgid>
References: <4D540F6C.6050904@gmail.com> <20110215155315.55d35b8e@notabene.brown>
 <4D5A92F3.1090004@turmel.org> <4D5BD678.2050200@gmail.com>
 <4D5BE119.7000804@turmel.org> <4D5C0E17.3060306@gmail.com>
 <4D5C140F.9010301@turmel.org> <4D5C1508.3040308@gmail.com>
 <4D5C15D3.1070608@turmel.org> <4D5C167C.7000101@turmel.org>
 <4D5C1CF8.1020507@gmail.com> <4D5C1E0B.9060300@turmel.org>
 <4D5C2061.4060106@gmail.com> <4D5C2143.3000907@turmel.org>
 <4D5C2260.3020800@gmail.com> <4D5C273E.7020609@turmel.org>
 <4D5C4176.80604@gmail.com> <4D5C4204.5020106@turmel.org> <1377706586882297883@unknownmsgid>
 <4D5C6016.6060809@turmel.org> <AANLkTi=P5vPKa0JwqcjM3D6u2v9AaK9D35SbJv8Yn+0E@mail.gmail.com>
 <4D5D2723.1010101@turmel.org>
Mime-Version: 1.0 (iPhone Mail 8A306)
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5D2723.1010101@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: NeilBrown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Phil, I think I need to connect them to the crippled machine directly,
I was just trying to leave it alone, I know that doesn't make much
sense but I'm more familiar with windows than Linux. The cards that I
have are all connected at gigabit and bonded. That machine has two
ports, so does the other. I'm running two asus p6ts (1 deluxe and 1
se) with i7 920's

I cant understand why it's so slow though I have seen some reports
that the supermicro card is quite slow.
Simon
Ps thanks for the bugfixes and updates
Simon

On 17 Feb 2011, at 13:48, Phil Turmel <philip@turmel.org> wrote:

> On 02/17/2011 08:26 AM, Simon Mcnair wrote:
>> Phil,
>> After a couple of attempts I realised that all I needed to do was
>> ./backup.sh sdi rather than specifying ./backup.sh /dev/sdi  schoolboy
>> error huh, rtfm.
>>
>> I tried modifying the code, so I could kick them all off at once, but
>> I wanted to check that this would work from a multithreaded/sane
>> perspective (yes I know it's a bit of IO, but iotop seems to infer I'm
>> only getting 10M/s throughput from the disk anyway).
>
> That sounds suspiciously like a 100 meg ethernet bottleneck, so parallel operation won't help.  If so, this'll take a very long time.
>
>> is this code kosha ?
>
> Looks pretty good.  I've attached a slight update with your changes and a bugfix.
>
>> #! /bin/bash
>> #
>> function usage() {
>>       printf "Usage:\n\t%s devname\n\n" "`basename \"$0\"`"
>>       printf "'devname' must be a relative path in /dev/ to the
>> desired block device.\n"
>>       exit 1
>> }
>>
>> # Verify the supplied name is a device
>> test -b "/dev/$1" || usage
>>
>> # Convert path separators and spaces into dashes
>> outfile="`echo \"$1\" |sed -r -e 's:[ /]+:-:g'`"
>>
>> # Create a side-stream for computing the MD5 of the data read
>> fifo=`mktemp -u`
>> mkfifo $fifo || exit
>> md5sum -b <$fifo >$2/$outfile.md5 &
>>
>> # Read the device and compress it
>> dd if="/dev/$1" bs=1M | tee 2>$fifo | gzip >$2/$outfile.gz
>>
>> # Wait for the background task to close
>> wait
>>
>> I was a little concerned as I didn't see the hdd drive LED light up
>> for my attempt even though the file was growing nicely on my CIFS
>> share.  I'm dumping it on the 5x2TB disks (JBOD) in my windows 7 box
>> as my Thecus is not a happy chappy and I need time to mount the DOM
>> module in another machine to find out why.
>
> If you're willing to dismantle the thecus, directly connecting its drives to your crippled system will make things go much faster.  You've got four empty motherboard SATA ports.  You just have to watch out for the power load.
>
> Phil
> <block2gz.sh>
