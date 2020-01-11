From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Subject: Re: RAID10, 3 copies, 3 disks
Date: Sat, 11 Jan 2020 21:55:16 +0100
Message-ID: <CAJH6TXji3e1Tp8xDDiqfqy36fpMC4kZTLaYj0Le9A6Cyg8EnGg@mail.gmail.com>
References: <CAJH6TXhWd-AGi0_KnbnepxZXsOvpMQGwkisFuuX14dMe157jWw@mail.gmail.com>
 <82a7d9ec-f991-ad25-bf1f-eee74be90b1b@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <82a7d9ec-f991-ad25-bf1f-eee74be90b1b@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wol <antlists@youngman.org.uk>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Il giorno sab 11 gen 2020 alle ore 20:11 Wol
<antlists@youngman.org.uk> ha scritto:
> The "standard" as you call it is actually RAID1+0. This is *not* "linux
> raid10", which is as you describe it - the number of disks can be any
> number greater than the number of mirrors.

Actually, what I need to do is simple: a scalable array with at least
3way-mirrors.

I've thought in using multiple 3way mirrors (RAID1) merged together with LVM or
just a single RAID10 (with 3 disks mirrors) and LVM on top of it as
volume manager.

Don't know which one is better, the result is similar.
