From: Harald Hoyer <harald@redhat.com>
Subject: Re: [PATCH 1/1] prevent double open(O_RDWR) on raid creation
Date: Mon, 29 Apr 2013 10:40:11 +0200
Message-ID: <517E31EB.8010703@redhat.com>
References: <1365686313-30833-1-git-send-email-Jes.Sorensen@redhat.com> <1365686313-30833-2-git-send-email-Jes.Sorensen@redhat.com> <20130429105720.593fe99b@notabene.brown> <517E0621.5030700@redhat.com> <20130429161124.454e2fc9@notabene.brown> <517E13FF.6050308@redhat.com> <20130429165350.32329f90@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130429165350.32329f90@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Jes.Sorensen@redhat.com, linux-raid@vger.kernel.org, Kay Sievers <kay@vrfy.org>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 04/29/2013 08:53 AM, NeilBrown wrote:
> On Mon, 29 Apr 2013 08:32:31 +0200 Harald Hoyer <harald@redhat.com> wrote:
> 
>> -----BEGIN PGP SIGNED MESSAGE----- Hash: SHA1
> 
>> On 04/29/2013 08:11 AM, NeilBrown wrote:
>>> On Mon, 29 Apr 2013 07:33:21 +0200 Harald Hoyer <harald@redhat.com>
>>> wrote:
>>> 
>>>> -----BEGIN PGP SIGNED MESSAGE----- Hash: SHA1
>>> 
>>>> On 04/29/2013 02:57 AM, NeilBrown wrote:
>>>>> On Thu, 11 Apr 2013 15:18:33 +0200 Jes.Sorensen@redhat.com wrote:
>>>>> 
>>>>>> From: Harald Hoyer <harald@redhat.com>
>>>>>> 
>>>>>> This does not trigger the udev inotify twice and saves a lot of
>>>>>> blk I/O for the raid members.
>>>>>> 
>>>>>> Also fixes: https://bugzilla.redhat.com/show_bug.cgi?id=947815
>>>>>> 
>>>>>> Signed-off-by: Harald Hoyer <harald@redhat.com> Signed-off-by:
>>>>>> Jes Sorensen <Jes.Sorensen@redhat.com>
>>>>> 
>>>>> (Sorry for delays.  Thanks for reminders).
>>>>> 
>>>>> That patch seems to make sense, but the description above is
>>>>> awfully thin.
>>>>> 
>>>>> Why is double-open a problem exactly?  What does it make udev do?
>>>>> And how does that related to ID_FS_TYPE being wrong as mentioned in
>>>>> the bugzilla entry.
>>>>> 
>>>>> NeilBrown
>>>>> 
>>> 
>>>> udevd with watch enabled (inotify on /dev/sd*) gets triggered on
>>>> close(), when you opened it writeable. So, if you double open() and
>>>> udev wakes up from the first close(), not all information are written
>>>> to disk yet, it will not get the ID_FS_TYPE.
>>> 
>>>> Seems like the second close() does not trigger an inotify sometimes,
>>>> so it is missing afterwards all the time.
>>> 
>>>> Watch via inotify is just a lazy workaround, so we don't have to
>>>> modify every tool to emit a "change" uevent, after they changed the
>>>> disk.
>>> 
>>> So udev have a "lazy workaround" so that other programs don't need to 
>>> trigger a change, and as a result, I need to add some special code to 
>>> mdadm. Doesn't seem like I'm getting any advantage out of this
>>> laziness.
>>> 
>>> How about when udev gets an inotify for a block device, it first
>>> checks that it can open it O_EXCL.  If not, it doesn't generate the
>>> change event. That seems like the laziest option to me :-)
> 
>> We cannot open with O_EXCL, because the device can be mounted, and
>> O_EXCL would fail there.
> 
> 
> If the device is mounted, why would you want udev to be doing anything to
> it?
> 
> I assumed this was for things like "mkfs" so that as soon as you mkfs a 
> filesystem udev could tell udisks to immediately mount it...  though I'm
> not sure this is a good idea.
> 
> I'm probably missing something important: what is the particular use case
> for udev mapping a close-after-write to a change event?
> 
> Thanks, NeilBrown
> 


Anyway, if you don't want to play nicely with the inotify mechanism of udev,
you have to inject the "change" uevent manually for every device mdadm changes.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJRfjHrAAoJEANOs3ABTfJwgosP/i1btIR88rZ5z8eYB5P6sZqT
XU0nUP1F4yMS1K4MOWDggQbuzcuxFowcnizg4Jje26c4z3kQ7Pj75GvqWwI3qqYp
+TdG+idu7kGPeQtYa05I567pj20D6nWYxC78aGJPlBU6C0qPvA1yXb7ui4NPJcw4
2/oRH2BONpb62VCQKCB04rQhqOXnzp/9agaqAL7hJcUOsbJv8vceLW0rXD0RqTzO
uQXQjUV2bYR73ySRZQWo2evaxZ/YgWDWL91h7R1O1wYvTclMNYqv+SQB9hDyrrDi
mk4YFWxdRUmdIzyr6FkZUUTj1KSpmrW01PaaIi3ueHV27Pvmz+7+1jd5JVvw9GiM
hm8Ob3baiGPMIfFZ7mfLBLlizBu0N4QTK5mm7D2btFS9phHb9/QzNpBtdAB15CTQ
8UF4IZg9HnbkG8XAedW97D3QS40873kPp7UPtsScnFe7+VcOh05s3AzF9zznji/C
kEcpPIjthK50RLniWBEoKNEjbfdpyF1PLsvQ7GkQNIoUHSveCPJQmaG0GV8AIPht
tNteLCImjeaUf57bi/BfKk5L42dwe8wqfmBGw40nbzmavRrYHEvUK3CMMR3C7TRZ
lvGzXInwxJpR2hkN8A9nX13FOX3YtVLXUtl5R6CVvcrYM6ZK78D1z5liiZcfKv2Y
XiUwQtkeIlscVHeW1QdO
=fzOH
-----END PGP SIGNATURE-----
