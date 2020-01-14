From: Nix <nix@esperi.org.uk>
Subject: Re: RAID10, 3 copies, 3 disks
Date: Tue, 14 Jan 2020 12:28:27 +0000
Message-ID: <87sgki2pec.fsf@esperi.org.uk>
References: <CAJH6TXhWd-AGi0_KnbnepxZXsOvpMQGwkisFuuX14dMe157jWw@mail.gmail.com>
        <82a7d9ec-f991-ad25-bf1f-eee74be90b1b@youngman.org.uk>
        <CAJH6TXji3e1Tp8xDDiqfqy36fpMC4kZTLaYj0Le9A6Cyg8EnGg@mail.gmail.com>
        <5E1A3D4F.30205@youngman.org.uk>
        <CAJH6TXjQ+vLSOJGH_7-mAeRREBSSTS5DTxXFtz2SU06wfhc4gA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJH6TXjQ+vLSOJGH_7-mAeRREBSSTS5DTxXFtz2SU06wfhc4gA@mail.gmail.com>
        (Gandalf Corvotempesta's message of "Sat, 11 Jan 2020 22:36:21 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Cc: Wols Lists <antlists@youngman.org.uk>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11 Jan 2020, Gandalf Corvotempesta said:

> Il giorno sab 11 gen 2020 alle ore 22:25 Wols Lists
> <antlists@youngman.org.uk> ha scritto:
>> Multiple 3-way mirrors (1+0) requires disks in multiples of 3. Raid10
>> simply requires "4 or more" disks. If you expect/want to expand your
>> storage in small increments, then 10 is clearly better. BUT.
>
> I'll start with 8TB usable (more than enough for me atm) and would be ok
> for at least 1 year, thus saving space is not a problem. Next year, if needed,
> i'll add 3 disks more (or i'll grow the existing ones)
>
>> Depending on your filesystem - for example XFS - changing the disk
>> layout underneath it can severely impact performance - when the
>> filesystem is created it queries the layout and optimises for it. When I
>> discussed it with one of the XFS guys he said "use 1+0 and add a fresh
>> *set* of disks (or completely recreate the filesystem), because XFS
>> optimises layout based on what disks it thinks its got."
>
> No XFS, i'll use ext4.

ext4 does the same thing. In both cases you can specify the layout by
hand, and sometimes you have to because not all block device layers pass
the layout up: e.g. my layering of md->lvm->bcache->cryptsetup->fs loses
the layout at (at least) the bcache level.

What I did when I knew I had a reshape coming up (because I was buying
another disk a few months after buying a machine, and reshaping onto it)
was to create the original array with the filesystem told about the
*intended final* shape, and verify after reshaping that everything was
fine (as with alignment, you can check this with blktrace's btrace tool,
doing stuff and seeing if most changes come a whole stripe at a time or
if all are misaligned and cross stripes). That way the fs starts off
less than optimal and improves after the reshape -- if you got
everything right, which sometimes feels like tightrope-walking.

For ext4, the mkfs options to look for are -E stride=and -E
stripe-width=, usually used together. For XFS, the options to look for
are sunit and swidth (and often agcount is useful too).

-- 
NULL && (void)
