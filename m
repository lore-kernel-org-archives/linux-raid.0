From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: getting I/O errors in super_written()...any ideas what would
 cause this?
Date: Mon, 03 Dec 2012 15:52:55 -0500
Message-ID: <50BD1127.6090304@redhat.com>
References: <8134827.27.1354128708501.JavaMail.root@zimbra>	<50B67230.4080602@genband.com> <CADNH=7Hv2RgBv=0Xia=yMyzKmgAOgvxJSAKn2arcE7k1x_T4FQ@mail.gmail.com> <50B67417.2020606@genband.com> <50BD09EC.5060705@redhat.com> <50BD0F44.7010808@genband.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <50BD0F44.7010808@genband.com>
Sender: linux-ide-owner@vger.kernel.org
To: Chris Friesen <chris.friesen@genband.com>
Cc: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, Roy Sigurd Karlsbakk <roy@karlsbakk.net>, Neil Brown <neilb@suse.de>, Linux-RAID <linux-raid@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, IDE/ATA development list <linux-ide@vger.kernel.org>
List-Id: linux-raid.ids

On 12/03/2012 03:44 PM, Chris Friesen wrote:
> On 12/03/2012 02:22 PM, Ric Wheeler wrote:
>> On 11/28/2012 03:29 PM, Chris Friesen wrote:
>>> On 11/28/2012 02:27 PM, Mathias Bur=E9n wrote:
>>>
>>>> The drives look healthy, but am I reading that right? More than 10
>>>> self tests per hour?
>>>
>>> Yeah....we cranked it up to try and increase how frequently we see =
the
>>> problem.
>>>
>>> From what I understand normally it runs once a day.
>>>
>>> Chris
>>
>> Did the vendor suggest to you that running a self test on an active
>> drive would be OK? I would expect errors in this case - specifically
>> time outs....
>
> I'm not the main developer in that area, but from what I understand t=
he code=20
> has been like this for ages.  (It's entirely possible we've been luck=
y up till=20
> now since we support limited hardware types.)
>
> The fact that you'd expect time outs is interesting--is that from the=
 delay=20
> switching from doing the self-test to doing the actual request?
>
> Is the expectation that the OS should not be sending any other comman=
ds to the=20
> disk while doing the self-test?
>
> I was recently looking at the SCSI spec trying to learn a bit about t=
his issue=20
> and the section on background self-test (spc-4, section 5.15.4.3) see=
ms to=20
> indicate that a READ or WRITE command should cause the background sel=
f-test to=20
> be aborted and the command to be processed within 2 seconds.  In our =
case it=20
> doesn't seem to be aborting (at least it shows as "Completed" in smar=
tctl)--is=20
> this expected?
>
> Thanks,
> Chris

I jumped into this thread late - can you repost detail on the specific =
drive and=20
HBA used here? In any case, it sounds like this is a better topic for t=
he=20
linux-scsi or linux-ide list where most of the low level storage people=
 lurk :)

Ric

