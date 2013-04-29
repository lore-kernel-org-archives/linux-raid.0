From: Harald Hoyer <harald@redhat.com>
Subject: Re: [PATCH 1/1] prevent double open(O_RDWR) on raid creation
Date: Mon, 29 Apr 2013 10:54:05 +0200
Message-ID: <517E352D.9010609@redhat.com>
References: <1365686313-30833-1-git-send-email-Jes.Sorensen@redhat.com> <1365686313-30833-2-git-send-email-Jes.Sorensen@redhat.com> <20130429105720.593fe99b@notabene.brown> <517E0621.5030700@redhat.com> <20130429161124.454e2fc9@notabene.brown> <517E13FF.6050308@redhat.com> <20130429165350.32329f90@notabene.brown> <517E31EB.8010703@redhat.com> <517E3337.1080808@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <517E3337.1080808@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Jes.Sorensen@redhat.com, linux-raid@vger.kernel.org, Kay Sievers <kay@vrfy.org>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 04/29/2013 10:45 AM, Harald Hoyer wrote:
> On 04/29/2013 10:40 AM, Harald Hoyer wrote:
>> On 04/29/2013 08:53 AM, NeilBrown wrote:
>>> On Mon, 29 Apr 2013 08:32:31 +0200 Harald Hoyer <harald@redhat.com> 
>>> wrote:
>>>> We cannot open with O_EXCL, because the device can be mounted, and 
>>>> O_EXCL would fail there.
> 
> 
>>> If the device is mounted, why would you want udev to be doing anything 
>>> to it?
> 
>>> I assumed this was for things like "mkfs" so that as soon as you mkfs a
>>>  filesystem udev could tell udisks to immediately mount it...  though
>>> I'm not sure this is a good idea.
> 
>>> I'm probably missing something important: what is the particular use 
>>> case for udev mapping a close-after-write to a change event?
> 
>>> Thanks, NeilBrown
> 
> 
> 
>> Anyway, if you don't want to play nicely with the inotify mechanism of 
>> udev, you have to inject the "change" uevent manually for every device 
>> mdadm changes.
> 
> *rant mode on*
> 
> I think we should drop the inotify mechanism from udev and say "f*** you"
> to the tools... If they change s.th. on the disk, they can also emit a
> "change" uevent to the kernel themselves.
> 

Oh, and the tools then also have wait for udev to settle..

Imagine a script doing:

# mdadm -A --uuid=<my-UUID> ....
# mkfs  -L mylabel /dev/disk/by-uuid/<my-MD-UUID>
# mount /dev/disk/by-label/mylabel /mnt

This is all broken by design today:
- - there is no guaranteed change event
- - there is no automatic udev settle
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJRfjUtAAoJEANOs3ABTfJw/8IP/jX1RUgSQQwqM5QG1JUVXOZT
Q/Uzuf4bDSdlHMrM0FjH6KNNDgh80fqwKBnb/sCsSNVRYgHdlLJXTdFYfzzWPk4t
2q7Rw/M8xQS9OnqzFy8BhkdvChyW8t9Pl2Owt4+6B++GJ+2ZZksb66ggsGca4bUE
XjLDUVJ8zk+VjVyg0yFMtUMwbJ88q14I2b+eAnCenXt/RoIGqMIX5ds8PEiowQeo
zVMjo0nXHyaDZPV6DkDIGtQ2vsnLGTc2V+SWzTH8vZJwbHERQNQczkcSiVFmt1JA
kgOkcSiq80FSrNAkD/gYdmZ9Qy4Txo5y1/gnaoWubehkVctQpezdjWslnCY0HTKL
ledREAUq562m9I5etIUINWjUyWJFLyBDD3a9TI3psg1dV4nNr7MmTf1OsCBaIhZt
EvqXTyo03K0tgpQHUJCj/ZgNejgvoMJGVYIxMdIC64+gZcM3iHqMkkJjKHTvwc+7
Hh0Mn8L/XwYX5PoBrOJrg3XAAt4S97gA/Opv90q7VrEz47+04KHzI5T4PQ2B8MzA
S+CZyDGMAazwSXTmaaEenXOaQKnYepiMQ/kFMM5teyaRKOPg3HqMPHWQnJq+/+bC
ktA3X7wFQ5QLa8v5G2TpVPxvwTY+8gpmYWzXx+qhFZAMQne3RLd7zQiclNzUFkLK
Nhnvkqel+fvi/0rFVx/X
=SYBt
-----END PGP SIGNATURE-----
