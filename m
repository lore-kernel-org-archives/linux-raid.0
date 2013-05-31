From: Dominic Raferd <dominic@timedicer.co.uk>
Subject: Re: SSD + Rust as raid1
Date: Fri, 31 May 2013 08:02:50 +0100
Message-ID: <51A84B1A.3090704@timedicer.co.uk>
References: <51A7C36F.4030605@timedicer.co.uk> <CADNH=7En7mtBPYh0i9ySqNYkPuJumY=VU-rEnsrMZphowA9WYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7En7mtBPYh0i9ySqNYkPuJumY=VU-rEnsrMZphowA9WYw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 31/05/13 01:22, Mathias Bur=C3=A9n wrote:
> On 30 May 2013 22:23, Dominic Raferd <dominic@timedicer.co.uk> wrote:
>> I am wanting to (re)set up my raid1 array with 1 SSD partition (/dev=
/sda2)
>> and 1 'rust' drive partition (/dev/sdb1) , both 240GB. SSD will also=
 have a
>> very small ext2 partition mounted as /mnt/sda1 (to hold the write-in=
tent
>> bitmap file).
>>
>> To get the full speed of the SSD for reads and to maximise speed for=
 writes
>> I plan to use these settings:
>>
>> mdadm -C /dev/md0 --level=3Draid1 -n 2 /dev/sda2 --write-mostly
>> --write-behind=3D16384 --bitmap=3D/mnt/sda1/write-intent-bitmap.file
>> --bitmap-chunk=3D256M dev/sdb1
>>
>> Will this work and be optimal? I am not too bothered about the write=
-intent
>> bitmap file but it is not optional I think, hence I set a large chun=
k size,
>> could or should it be even larger (or smaller)? Similarly I have tri=
ed to
>> set a high write-behind to speed up writes as much as possible - is =
16384
>> the maximum allowed?
>>
>> My system has mdadm 3.2.3 and kernel 3.2.26.
>>
>> Any suggestions gratefully received.
>>
>> Dominic
>>
>>
>> Quick question: Why not a 2 drive "RAID10"?
>>

Thanks for your reply Mathias. I am not familiar enough with RAID10 to=20
know if or how this would work, nor am I sure if it would work OK with=20
my OS (Devil-Linux), whereas I have used mdadm with RAID1 for many year=
s=20
with conventional drives. My idea is to upgrade one of my existing=20
drives to SSD and to get all the read-speed advantages of SSD and as=20
much write-speed improvement as possible. If RAID10 can do this better=20
than RAID1 then please tell me more!
--
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
