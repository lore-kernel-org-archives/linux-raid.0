From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Subject: Re: RAID10, 3 copies, 3 disks
Date: Sat, 11 Jan 2020 22:36:21 +0100
Message-ID: <CAJH6TXjQ+vLSOJGH_7-mAeRREBSSTS5DTxXFtz2SU06wfhc4gA@mail.gmail.com>
References: <CAJH6TXhWd-AGi0_KnbnepxZXsOvpMQGwkisFuuX14dMe157jWw@mail.gmail.com>
 <82a7d9ec-f991-ad25-bf1f-eee74be90b1b@youngman.org.uk> <CAJH6TXji3e1Tp8xDDiqfqy36fpMC4kZTLaYj0Le9A6Cyg8EnGg@mail.gmail.com>
 <5E1A3D4F.30205@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5E1A3D4F.30205@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Il giorno sab 11 gen 2020 alle ore 22:25 Wols Lists
<antlists@youngman.org.uk> ha scritto:
> Multiple 3-way mirrors (1+0) requires disks in multiples of 3. Raid10
> simply requires "4 or more" disks. If you expect/want to expand your
> storage in small increments, then 10 is clearly better. BUT.

I'll start with 8TB usable (more than enough for me atm) and would be ok
for at least 1 year, thus saving space is not a problem. Next year, if needed,
i'll add 3 disks more (or i'll grow the existing ones)

> Depending on your filesystem - for example XFS - changing the disk
> layout underneath it can severely impact performance - when the
> filesystem is created it queries the layout and optimises for it. When I
> discussed it with one of the XFS guys he said "use 1+0 and add a fresh
> *set* of disks (or completely recreate the filesystem), because XFS
> optimises layout based on what disks it thinks its got."

No XFS, i'll use ext4.
I had *TONS* of issues with XFS
