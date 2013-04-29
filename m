From: Harald Hoyer <harald@redhat.com>
Subject: Re: [PATCH 1/1] prevent double open(O_RDWR) on raid creation
Date: Mon, 29 Apr 2013 10:45:43 +0200
Message-ID: <517E3337.1080808@redhat.com>
References: <1365686313-30833-1-git-send-email-Jes.Sorensen@redhat.com> <1365686313-30833-2-git-send-email-Jes.Sorensen@redhat.com> <20130429105720.593fe99b@notabene.brown> <517E0621.5030700@redhat.com> <20130429161124.454e2fc9@notabene.brown> <517E13FF.6050308@redhat.com> <20130429165350.32329f90@notabene.brown> <517E31EB.8010703@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <517E31EB.8010703@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Jes.Sorensen@redhat.com, linux-raid@vger.kernel.org, Kay Sievers <kay@vrfy.org>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 04/29/2013 10:40 AM, Harald Hoyer wrote:
> On 04/29/2013 08:53 AM, NeilBrown wrote:
>> On Mon, 29 Apr 2013 08:32:31 +0200 Harald Hoyer <harald@redhat.com>
>> wrote:
>>> We cannot open with O_EXCL, because the device can be mounted, and 
>>> O_EXCL would fail there.
> 
> 
>> If the device is mounted, why would you want udev to be doing anything
>> to it?
> 
>> I assumed this was for things like "mkfs" so that as soon as you mkfs a 
>> filesystem udev could tell udisks to immediately mount it...  though I'm 
>> not sure this is a good idea.
> 
>> I'm probably missing something important: what is the particular use
>> case for udev mapping a close-after-write to a change event?
> 
>> Thanks, NeilBrown
> 
> 
> 
> Anyway, if you don't want to play nicely with the inotify mechanism of
> udev, you have to inject the "change" uevent manually for every device
> mdadm changes.
> 
*rant mode on*

I think we should drop the inotify mechanism from udev and say "f*** you" to
the tools... If they change s.th. on the disk, they can also emit a "change"
uevent to the kernel themselves.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJRfjM3AAoJEANOs3ABTfJwRwoP/jtGvFdNonRF71txWxTzvsas
QErwTrojNdpRT850rCHIMNF9x/iYSMaVJcMGBx+H3zyZCDLiYwr7qvXUNWh9frC2
FQvJEqhpoH4ku17wT2eX4XYhIOC7/qudsS9EUfQ/NZw4her2uXbHosSJjfBjsp0f
voVaU1dXZ4jsyA5nybH2fN0L70HpMei4AU9/lhI5UtBZa6erOe3o/kc0rT+E9o9z
n4l+r6DI2zsgw/Cg0O59N6G9otd2zYuj2QLosPmG4Rx0yEcoC8Tn04ncJ8e5Qw4E
GW0sm7SvP2tSlQvZFltKpGjEMPuKMXkcmgonkmGpZGSzpxF2evH+6SyK0lN4E7IK
Guz6s5r+ecj6WWGneX7H+RD7EV4UIYHirr8txhS7QXmPiXR0+OJ4S5BPGdnxLBUf
D/ttJUwA9sSSGdVx4M5iH39o/cC3I6XdUXqa7A6gpEsNZHE44masIVfdUIOqkv9a
1Ok3sArMWFkE+RtsRltzmcnGGyj58W4wBwtMp5gzbqfSGqpONzSt4uETzs1cTJWt
qQdWMGFsb4WKjHmjoG0ohr70r5zNubpeXfQlWzAFcFSWcqPmKK4J/Wk9hrB2kBo/
TNdgAxyRJOzGh/uNF0XVbEuL2dfIxjc25AadYJs9eq3wUQrs5C3ppL3lHI4/vKFi
AAwQBFAqj/b3MBJ5FR95
=r9Au
-----END PGP SIGNATURE-----
