From: Harald Hoyer <harald@redhat.com>
Subject: Re: [PATCH 1/1] prevent double open(O_RDWR) on raid creation
Date: Mon, 29 Apr 2013 10:34:39 +0200
Message-ID: <517E309F.6040608@redhat.com>
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

Well, you would not recognize LABEL or UUID or MD UUID changes, if you don't
call blkid after a mkfs or mdadm or lvm action.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJRfjCeAAoJEANOs3ABTfJwLQIP/iaKQFUYyE5tsw8zVVxw+ag6
QPhs08y8JM1nPNyC4hd2BKLwx687eXVIR7Kyfx8i9L2dEHLn2ry+ROTAbfn1UEr2
GjpD48wuNiohJKUZ5l8Wn3q8slboUImgHUkiZgtWII0pCk3vGo+/01WIWzSzDRlN
PsI8TS4+wBIdZhfWMtzU65uXiZYoGpaURqIv+7xIgEN90mM45kE1FA/HJF8YZOBz
H8CMI2pr+GUI/XCUjUYJK5m3y1sJCm5US5IsR4AqpQGlkU2G9pFQYRWFS4uYKOsF
tjk7Fj8wFw51gz/dWGlKM9uK+iAFHVVorjFPdDJilSdswWP88JMrwlfAkivxbKSA
6JsKEOSLlkuW5gNRl6Flg2/hLBmlJYUx3nXzT4WZWgibD4mkKAmY1uB0gnzE2/lm
YP7dEs5WVo5Rl3lM+Mv6vqDl6dJCvg60AU3u5srWwfqUau81p5rYIuqXJ5Da4GcU
njz6NUwzMm2FI91INDDi/GJzwi1bVV6CeTNiz3LNjd2+yr2dt0AFBZWQ3k1c+/rO
WJ8NhN6dW8JZEL4VN5yfEht4x+kVnxqdTedAm5NtPooSD3we2w/e5u5im3FfUkJN
GX4+Et2sE5gk70Es/u2Ws1tLOdpxZsUiU/HBgS51+8KBIumj+Me3BLZpGkvqwNm/
vV2Fov6yJhM5E0/lYAhn
=xI4C
-----END PGP SIGNATURE-----
