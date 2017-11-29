From: Phil Turmel <philip@turmel.org>
Subject: Re: New setup: partitions or raw devices
Date: Wed, 29 Nov 2017 12:49:57 -0500
Message-ID: <5b9076c5-65fc-414d-504b-25396bed0efc@turmel.org>
References: <CAJH6TXj4wp-k2QQ0O8W2PDQEg9QHcWwPkOEOSzMgvtbV6b21Cw@mail.gmail.com>
 <7f6abcbc-7dfa-0252-e9df-984e7e637936@thelounge.net>
 <1cf640fc-c6ee-25e8-8aee-9cf8025f9f4d@turmel.org>
 <CAJH6TXirSV0X4jXa2de6wFFET+_gGUB9iod61kwHFvEWcoruVw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJH6TXirSV0X4jXa2de6wFFET+_gGUB9iod61kwHFvEWcoruVw@mail.gmail.com>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Cc: Reindl Harald <h.reindl@thelounge.net>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/29/2017 12:42 PM, Gandalf Corvotempesta wrote:
> 2017-11-29 17:52 GMT+01:00 Phil Turmel <philip@turmel.org>:
>> These are good reasons.  I have also seen reports of NAS devices/distros
>> unconditionally partitioning devices that don't have one.  Although I
>> have in the past used raw devices with mdadm, I don't plan to do so with
>> any future systems.
> 
> I always used partitioning.
> But last time i've tried to configure mdadm to automatically replace a
> disk when replaced:
> https://linux.die.net/man/5/mdadm.conf
> "POLICY" section, tried all but the best candidate seems to be "spare-same-slot"
> 
> I was never able to make that working. I've tried everything: insert a
> brand new disk, insert an already partitioned disks and so on.
> I always though that the main issue was due to disk partitioning,
> mdadm won't be able to re-add a brand new disks if raid is made
> with paritions (the new disks doesn't have any partition)
> 
> Any idea ?

I don't let mdadm do any such automatic allocation of new devices.  If
you have to manually put the device in the server, its only a few
seconds more to note which device it is in dmesg, and add it to the
array.  (And partition it, if not already.)

Phil
