From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: 4 partition raid 5 with 2 disks active and 2 spare, how to force?
Date: Sun, 28 Mar 2010 23:41:52 -0700
Message-ID: <4877c76c1003282341s15f181b0m6a0327bc947dc456@mail.gmail.com>
References: <S1753093Ab0CYHZE/20100325072504Z+37@vger.kernel.org>
	 <2E4545D6-8F4E-4779-9103-960C52983A72@brillgene.com>
	 <4877c76c1003250437r346e18en8da0f6f804bef634@mail.gmail.com>
	 <DFC0232A-8DCD-4815-AA08-DA7065F01221@brillgene.com>
	 <4877c76c1003252038o655b2a29p9d994df27b5d2afd@mail.gmail.com>
	 <6093BE49-EE3B-41B5-9519-C6D5D0496C64@brillgene.com>
	 <4877c76c1003261204h2777547dn67a8e692864ff26a@mail.gmail.com>
	 <D332CDBC-0D5D-4BF7-8876-7A4B1B3ED45E@brillgene.com>
	 <45872BBE-0957-43E4-8D31-54B28F5F5936@brillgene.com>
	 <20100329053227.GA21664@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100329053227.GA21664@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Mar 28, 2010 at 10:32 PM, Luca Berra <bluca@comedia.it> wrote:
> On Sun, Mar 28, 2010 at 10:05:58PM +0530, Anshuman Aggarwal wrote:
>>>
>>> Michael,
>>> I am running mdadm 3.1.2 (latest stable I think) compiled from sour=
ce
>>> (FYI on Ubuntu Karmic, 2.6.31-20-generic)
>>>
>>> Here is what happened....the device /dev/sda1 has failed once, but =
I was
>>> wondering if it was a freak accident so I tried adding it back..and=
 then it
>>> started resyncing ...somewhere in this process...the disk /dev/sda1=
 stalled
>>> and the server needed a reboot. After that boot, I got 2 spares (/d=
ev/sda1,
>>> /dev/sdd5) and 2 active devices (/dev/sdb1, /dev/sdc1)
>>>
>>> Maybe I need to do a build with a --assume-clean with the devices i=
n the
>>> right order (which I'm positive I can remember) ...be nice if you c=
ould plz
>>> double check:
>>> mdadm --build -n 4 -l 5 -e1.2 --assume-clean /dev/md127 /dev/sda1
>>> /dev/sdb5 /dev/sdc5 /dev/sdd5
>>>
>>> Again, thanks for your time...
>>>
>>> John,
>>> I did try what you said without any luck(--assemble --force but it
>>> refuses to accept the spare as a valid device and 2 active on a 4 m=
ember
>>> device isn't good enough)
>>>
>>>
>>>
>>
>> Some more info:
>>
>> I did try this command with the following result:
>>
>> mdadm --build -n 4 -l 5 -e1.2 --assume-clean /dev/md127 /dev/sda1
>> /dev/sdb5 /dev/sdc5 /dev/sdd5
>> mdadm: Raid level 5 not permitted with --build.
>>
>> Should I try this?
>> mdadm --create -n 4 -l 5 -e1.2 --assume-clean /dev/md127 /dev/sda1
>> /dev/sdb5 /dev/sdc5 /dev/sdd5
>
> From your description above /dev/sda was the failed one, so you shoul=
d
> not add it to the array. use the word "missing" in its place.
>
> L.
>
> --
> Luca Berra -- bluca@comedia.it
> =A0 =A0 =A0 =A0Communication Media & Services S.r.l.
> =A0/"\
> =A0\ / =A0 =A0 ASCII RIBBON CAMPAIGN
> =A0X =A0 =A0 =A0 =A0AGAINST HTML MAIL
> =A0/ \
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Additionally to using missing for the device you know to be a failed
one, VERY highly suggest running a check, or some read-only operation
on the resulting raid device to make sure you can read all of the
data.  Be sure to check the dmesg/system logs to make sure that there
were no noted storage errors.  If there were not, it is /probably/
safe to re-add the previously failed disk and resync it.

While checking that your array data can be read, you should probably
also run the SMART tests via smartctl (or a gui for it) on the
'failed' disk to see if it was a sign of something worse.

In any case, I do NOT recommend using anything within the raid
container other than in read-only mode until the resync is complete.
You may need to use portions of sda that are still good in more
elaborate ways to recover data that is readable there, but not
readable on sdd or other drives.  Read/write mode or even FSCK on the
array contents will only increase the chances of data being out of
sync.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
