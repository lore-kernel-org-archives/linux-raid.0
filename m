From: wilsonjonathan <piercing_male@hotmail.com>
Subject: Is it possible to change the wait time before a drive is
 concidered failed?
Date: Sun, 20 Nov 2011 18:41:44 +0000
Message-ID: <BLU0-SMTP264257376293BB9DBCEB7B798CA0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I realise that what I am attempting is not very standard in terms of
raid, however this is my logic and reasoning...

I am setting up a home server that while on 24/7 will only be in use
when either myself (linux) or my son (windows) are using it, so usage
will vary and power concerns (Electricity in the UK is extortionately
priced!) and longevity are important.

My set up in theory is the following using GPT partitioning.

>sda 6 partitions
>>free space     1MiB
>>sda1 bios_boot 1MiB
>>sda2 /boot     200MiB  raid1  md2
>>sda3 /         8GiB    raid1  md3
>>sda4 *swap     9GiB    (will be "raided" using pri=3D1)
>>sda5 /download 40GiB   raid10 md4
>>sda6 /thecube  ~950Gib raid6  md5
>>free space     ~20MiB
>
>sdb same as sda
>
>sdc 1 partition
>>free space     enough space to place sdc6 the same start as sda6
>>sdc6 /thecube  same as sda6
>>free space
>
>sd[df] same as sdc

The reason for partitioning this way is that all w.i.p. or downloads,
torrents, etc. will first go into /download and once complete will be
moved into /thecube for long term read only storage

As /thecube is going to be used less often than sd[ab] it would be
advantages to have sd[df] power down and when the system is not in use
at all have sd[ab] also power down.

This should increase the lifespan of the drives... and yes I do know
that drives are more likely to fail when powering up, but I also have
real life evidence when I used to work on AS/400s that they fail on
power up if they have hardly ever been turned off more often than if
they have regular power off/on cycles :-)

I may even look at suspend to ram and magic packets if the system is no=
t
accessed in say 1 hour, although this is less likely to be implemented!

Ok so that=E2=80=99s the reasoning behind the question.



I do have a couple of related questions...

I have already done some testing by setting up sd[ab] for md[2-4] but
with no file systems on top, and then pulling sdb and then putting it
back in.

q1, why does -add throw up the message : not performing --add, re-add
failed, zero superblock...

q2, I setup md4 as a raid10 far 2, and I may not be understanding raid1=
0
here; when I zero the superblock to add it as I did with the other raid=
s
which worked ok, for some reason it causes sda4 to drop out and kills
the whole md4 raid.

q3, Is it preferable to have a write intent bitmap, and if so should I
put it in the meta-data as opposed to a file.

Thanks in advance.

Jon.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
