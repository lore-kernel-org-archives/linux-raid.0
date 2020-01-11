From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: RAID10, 3 copies, 3 disks
Date: Sat, 11 Jan 2020 21:25:35 +0000
Message-ID: <5E1A3D4F.30205@youngman.org.uk>
References: <CAJH6TXhWd-AGi0_KnbnepxZXsOvpMQGwkisFuuX14dMe157jWw@mail.gmail.com>
 <82a7d9ec-f991-ad25-bf1f-eee74be90b1b@youngman.org.uk>
 <CAJH6TXji3e1Tp8xDDiqfqy36fpMC4kZTLaYj0Le9A6Cyg8EnGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJH6TXji3e1Tp8xDDiqfqy36fpMC4kZTLaYj0Le9A6Cyg8EnGg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/01/20 20:55, Gandalf Corvotempesta wrote:
> Il giorno sab 11 gen 2020 alle ore 20:11 Wol
> <antlists@youngman.org.uk> ha scritto:
>> The "standard" as you call it is actually RAID1+0. This is *not* "linux
>> raid10", which is as you describe it - the number of disks can be any
>> number greater than the number of mirrors.
> 
> Actually, what I need to do is simple: a scalable array with at least
> 3way-mirrors.
> 
> I've thought in using multiple 3way mirrors (RAID1) merged together with LVM or
> just a single RAID10 (with 3 disks mirrors) and LVM on top of it as
> volume manager.
> 
> Don't know which one is better, the result is similar.
> 
Multiple 3-way mirrors (1+0) requires disks in multiples of 3. Raid10
simply requires "4 or more" disks. If you expect/want to expand your
storage in small increments, then 10 is clearly better. BUT.

Depending on your filesystem - for example XFS - changing the disk
layout underneath it can severely impact performance - when the
filesystem is created it queries the layout and optimises for it. When I
discussed it with one of the XFS guys he said "use 1+0 and add a fresh
*set* of disks (or completely recreate the filesystem), because XFS
optimises layout based on what disks it thinks its got."

Cheers,
Wol
