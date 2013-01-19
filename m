From: Can Jeuleers <can.jeuleers@gmail.com>
Subject: Re: Automatically adding spares on boot
Date: Sat, 19 Jan 2013 19:41:15 +0100
Message-ID: <50FAE8CB.50802@gmail.com>
References: <27416855.12.1358620078446.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <27416855.12.1358620078446.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/19/2013 07:27 PM, Roy Sigurd Karlsbakk wrote:
>> Over the years I've had various problems with the degree to which th=
e
>> adding of spares on boot is automatic. There have been times when th=
is
>> has just worked, and other times (such as now) where it only works
>> very
>> occasionally (or not at all). Google is full of stories like this.
>>
>> I have no clue why it's not working automatically, I just know that =
it
>> isn't.
>>
>> So I wrote a little script that automates this, and hooked it up to
>> mdmon as an event handler.
>>
>> It can probably do with an elegance upgrade, but it works for me.
>=20
> hm=E2=80=A6 I don't se the point, really. I have a RAID-6 with a spar=
e, and last time a drive died, the spare kicked in automatically. Why w=
ould you add something at boot?

=46or the spare to be automatically swung into action when a drive fail=
s,
the spare must first have been added to the array. In other words: it
can't just be an unused drive somewhere: mdadm must know that it has
permission to use this drive (or partition or whatever) as a hot spare.

Normally you would expect mdadm's auto-assembly code, or the udev
scripts that ship with the OS, to add all relevant devices to each
array: not only the active devices but also the spares. The problem I'm
facing is that (for reasons unknown) my arrays start up with only the
active members added, and the spare devices remaining unused.

Specifically, my /proc/mdstat looks like this upon boot:

Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5]
[raid4] [raid10]
md0 : active raid1 sdb1[1] sdd1[0]
      521984 blocks [2/2] [UU]
      bitmap: 0/1 pages [0KB], 65536KB chunk

md1 : active raid1 sdb2[1] sdd2[0]
      487861824 blocks [2/2] [UU]
      bitmap: 1/4 pages [4KB], 65536KB chunk

unused devices: <none>

Note that mdadm doesn't think that there are any unused devices, but
there are. Because when mdadm --monitor notices that each of the above
arrays should have a spare it throws a SparesMissing event, which
triggers the script that I sent to the list. Once both of these events
have been handled /proc/mdstat looks like this:

Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5]
[raid4] [raid10]
md0 : active raid1 sde2[2](S) sdb1[1] sdd1[0]
      521984 blocks [2/2] [UU]
      bitmap: 0/1 pages [0KB], 65536KB chunk

md1 : active raid1 sde3[2](S) sdb2[1] sdd2[0]
      487861824 blocks [2/2] [UU]
      bitmap: 1/4 pages [4KB], 65536KB chunk

unused devices: <none>

Hope this clarifies. You don't need this script if your OS always finds
your spares and adds them automatically to your arrays. Mine doesn't.

Cheers, Jan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
