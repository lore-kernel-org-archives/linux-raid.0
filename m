From: Clinton Lee Taylor <clintonlee.taylor@gmail.com>
Subject: Re: Use of WD20EARS with MDADM
Date: Wed, 21 Apr 2010 21:31:27 +0200
Message-ID: <z2wb7b14cbb1004211231vf34acbf1sf34ccba3160c1688@mail.gmail.com>
References: <4BAB8D41.4010801@gmail.com> <4BABA12D.6040605@shiftmail.org>
	 <4BAF8185.9040307@gmx.net> <4BC61D47.6090403@tmr.com>
	 <4BCC65EB.3080803@cfl.rr.com> <4BCEFB99.9080806@tmr.com>
	 <4BCF163C.6040604@cfl.rr.com>
	 <y2x5bdc1c8b1004211036ra8e10a43kc1a13c2b374a5f7b@mail.gmail.com>
	 <4BCF4693.3020101@buttersideup.com>
	 <m2x5bdc1c8b1004211201ob1ea0c67k67b03eb4627a1375@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <m2x5bdc1c8b1004211201ob1ea0c67k67b03eb4627a1375@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Tim Small <tim@buttersideup.com>, Phillip Susi <psusi@cfl.rr.com>, Bill Davidsen <davidsen@tmr.com>, st0ff@npl.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greetings ...

On 21 April 2010 21:01, Mark Knecht <markknecht@gmail.com> wrote:
> On Wed, Apr 21, 2010 at 11:40 AM, Tim Small <tim@buttersideup.com> wr=
ote:
>> Mark Knecht wrote:
>>> This machine only gets a few hours of use a day but is generally
>>> powered up all the time. I don't know why Linux wakes this drive up
>>> roughly every two minutes, assuming it's Linux and not the drive
>>> itself or something on the motherboard, but it does.
>>>
>>
>>
>> This is documented here:
>>
>> https://ata.wiki.kernel.org/index.php/Known_issues#Drives_which_perf=
orm_frequent_head_unloads_under_Linux
>>
>> If you want to fix it, then wdidle3.exe worked for me. =A0Search for=
:
>>
>> wdidle3_1_00.zip
>>
>>
>> Tim.
>>
>
> Yeah, that's been reported here before, but how does someone run this
> Windows program on a remote machine that boots only Linux? Even if it
> was a DOS executable the machine has no floppy. I presume you are
> dual-boot with Windows? If so maybe I'll install Windows the next tim=
e
> I visit.
 Why don't you download FreeDOS boot floppy image.  Add the DOS
program to the image. Copy image to your boot partition, add an entry
in your Boot Manager to boot the image using some line syslinux image
booter.

On CentOS, install syslinux package using "yum install syslinux"
Copy memdisk to your boot partition

=46rom the www.freedos.org web site, download floppy image in
http://www.freedos.org/freedos/files/ ...

wget -vb http://www.ibiblio.org/pub/micro/pc-stuff/freedos/files/distri=
butions/1.0/fdboot.img

Mount the downloaded image file with "mount fdboot.img /mnt/floppy/ -o =
rw,loop"

Copy DOS program into the floppy image.

Add to your grub.conf file ...

title FreeDOS - Boot Image
    kernel memdisk
    initrd fdboot.img

Now reboot your system that does not have a floppy drive off the
=46reeDOS image and run the DOS program to make changes.  The only thin=
g
I can think of that might be a problem, is that you might have the
drive attached to a SATA port that is not supported by the DOS program
or something like that.

This is what I use to do BIOS and other firmware updates, that Linux
does not have a tool for.

Mailed
LeeT

P.S. Sorry for the Off Topic post, but I hope it helps.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
