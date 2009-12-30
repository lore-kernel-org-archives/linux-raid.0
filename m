From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: imsm woes (and a small bug in mdadm)
Date: Wed, 30 Dec 2009 12:56:42 -0700
Message-ID: <e9c3a7c20912301156r7bda4055pf58b2589e9d7d53@mail.gmail.com>
References: <20091222175128.GA18191@maude.comedia.it>
	 <e9c3a7c20912221557p18bb5675ofb148af3164d7c9c@mail.gmail.com>
	 <20091223134823.GA18870@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091223134823.GA18870@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Dec 23, 2009 at 6:48 AM, Luca Berra <bluca@comedia.it> wrote:
> first thing, thanks for your attention.
>

Thanks for testing and reporting back, very much appreciated.  In the
future please leave me on the Cc: I'll notice the message much faster
that way.

> On Tue, Dec 22, 2009 at 04:57:49PM -0700, Dan Williams wrote:
>>
>> On Tue, Dec 22, 2009 at 10:51 AM, Luca Berra <bluca@comedia.it> wrot=
e:
>> Everything looks back in order now, let me know if the bios/Windows
>> has any problems with it.
>
> after rebuild and reboot Volume0 was ok,
> Volume 1 was in state "Initializing" and windows rebuilt it again,
> this leads me to believe even mdadm-3.1.1 is not perfect yet.

The Windows driver has the concept of running the array in
uninitialized mode, but by default the imsm support in mdadm will
always initialize arrays (it is not strictly needed for raid1/raid10
but it matches the Linux default of always initializing).  It looks
like the current code will try to start an initialization after a
rebuild if the initial array state was 'uninitialized', I'll fix this
up.

>
>>> attached, besides the patch are
>>> mdadm -Dsvv and mdadm -Esvv before and after the hot-remove-add, in=
 case
>>> someone has an idea about what might had happened.
>>>
>>
>> Thanks for the report. =A0I hit that segfault recently as well, and =
your
>> fix is correct.
>>
>> Is sdb the drive you replaced, or the original drive? =A0The 'before=
'
>
> sdb was the 'original' drive.
>>
>> record on sdb shows that it is a single disk array with only sda's
>> serial number in the disk list(?), it also shows that sda has a high=
er
>> generation number. =A0It looks like things are back on track with th=
e
>> latest code because we selected sda (highest generation number),
>> omitted sdb because it was not part of sda's disk list, and modified
>> the family number to mark the rebuild as the bios expects.
>
> so 3.0.2 does something which is not correct???

3.0.2 was missing commit a2b97981 "imsm: disambiguate family_num" [1]

> which is the suggested mdadm version for imsm then, 3.1.1 or your git=
?

The suggested version is always Neil's latest stable release [2].  You
can track my git, but it may rebase from time to time as Neil reviews
the incoming patch stream.

> my data wasn't important, but i'd like to avoid someone else loosing
> data.

Understood, I'm running an imsm raid5 and raid1 at home, so I have a
personal interest in this code doing the right thing as well.

>> The bios marked both disks as offline because they both wanted to be
>> the same family number, but they had no information about each other
>> in their records, so it needed user intervention to clear the
>
> this is strange, since one of the test i did was powering on the pc w=
ith
> only one disk connected (tried with both of them)
>>
>> conflict. =A0It would have been nice to see the state of the metadat=
a
>> after the crash, but before the old mdadm [1] touched it as I believ=
e
>> that is where the confusion started.
>
> unfortunately i did not forsee any problem so i did not take a snapsh=
ot.
> btw besides mdadm -D (-E) is there any other way to collect binary
> metadata (dd if=3D/dev/sd? bs=3D? skip=3D? count=3D?) ?

The anchor for imsm metadata lives at the second to last sector of the
disk (n-1).  If it grows beyond the size of 1 sector it will consume
the preceding sectors.  So, a metadata record that is 4 sectors in
size will be organized like:

sector[0]: n-1
sector[1]: n-4
sector[2]: n-3
sector[3]: n-2

The details are in load_imsm_mpb() [3]

--
Dan

[1]: http://git.kernel.org/?p=3Dlinux/kernel/git/djbw/mdadm.git;a=3Dcom=
mitdiff;h=3Da2b97981
[2]: git://neil.brown.name/mdadm master
[3]: http://neil.brown.name/git?p=3Dmdadm;a=3Dblob;f=3Dsuper-intel.c;h=3D=
d6951cc2ff7c72a578e7de2c733fde387eed0f08;hb=3Dmaster#l2110
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
