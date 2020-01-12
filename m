From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Subject: Re: Raid 1 vs Raid 5 suggestion
Date: Sun, 12 Jan 2020 15:35:20 +0100
Message-ID: <CAJH6TXg_aJ2wa59HuEgNZdaAT_P+NSh_h41_jX3O5705H8Qdbw@mail.gmail.com>
References: <0155f98d-7ffc-a631-a7c5-259192c0df00@gmail.com>
 <5D25196A.9020606@youngman.org.uk> <9a71fbbd-8a41-5d59-dd89-5e98bb22a11a@gmail.com>
 <8033f679-84cc-78f9-064d-dc0a191f5a31@websitemanagers.com.au>
 <006fbf98-ec73-818d-f9d1-fbe315dc0f60@thelounge.net> <30c63d5e-34fb-47ce-71f7-272fb4ef3d17@websitemanagers.com.au>
 <0640dd81-a4fe-5847-ec26-3a7dedd5872f@thelounge.net> <cb440d7c-e7eb-1826-3f9d-e7b44ab359f6@websitemanagers.com.au>
 <5e40eefb-8158-8c2c-f28d-e9fb657fe6ce@thelounge.net> <4c4338ea-f5a2-21cf-1c54-2a3a5819d89f@websitemanagers.com.au>
 <72148027-089c-3f7f-1bf7-a7747e9f8f63@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <72148027-089c-3f7f-1bf7-a7747e9f8f63@thelounge.net>
Sender: linux-raid-owner@vger.kernel.org
To: Reindl Harald <h.reindl@thelounge.net>
Cc: Adam Goryachev <mailinglists@websitemanagers.com.au>, Luca Lazzarin <luca.lazzarin@gmail.com>, Wols Lists <antlists@youngman.org.uk>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Il giorno mer 10 lug 2019 alle ore 05:23 Reindl Harald
<h.reindl@thelounge.net> ha scritto:
> i yet need to see an array with 6 different disks where 2 are failing at
> the same time which in this case needs to be the two right ones making a
> stripe-mirror.... at least you have decent write performance while a
> RAID1 with 6 mirrors sucks

Happened to me. Two times in a row.
6 disks RAID10: 2 disks failed in a couple of hours, both disks were
part of the same mirror.

10 days later, another server with the same raid topology.

It's not unusual, if you buy 6 disks at once, you have a very hight chance that
these disks are coming from the same batch from the same factory (most of the
time, the serial number is sequential). In a RAID1 (even if not part
of a RAID1+0)
you are writing the same date at the same time to both disks, thus you have the
same write pattern on both disks.

When one disk fails, you have to read the other disk, putting an
additional stress
in addition to the same pattern used by both disks for years. The
probabily to hit a new failure
is high.

Also, you have to consider some hardware issue not directly related to
disks. I had multiple disks kicked out
during a rebuild. One disk failed, another disk was kicked out,
hopefully this time I had a RAID-6
The first 2 ports on the backplane was defective, but with a RAID10,
if this happens, you are fucked.

Disks are not the only thing that could fail on a server. A RAID10 is
based luck. You have to be luck that a second failure is not impacting
the same mirror.
