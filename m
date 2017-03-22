From: David Brown <david.brown@hesbynett.no>
Subject: Re: proactive disk replacement
Date: Wed, 22 Mar 2017 15:12:16 +0100
Message-ID: <58D28640.60703@hesbynett.no>
References: <3FA2E00F-B107-4F3C-A9D3-A10CA5F81EC0@allygray.2y.net> <11c21a22-4bbf-7b16-5e64-8932be768c68@websitemanagers.com.au> <CAPrpM6wtQe=h1AE-PbFr0-DyZ_wRN7gvibjfn86W0mQz77xnLg@mail.gmail.com> <f0916e66-8ea7-3363-3600-1d2cd68e85af@thelounge.net> <02316742-3887-b811-3c77-aad29cda4077@websitemanagers.com.au> <583576ca-a76c-3901-c196-6083791533ee@thelounge.net> <58D126EB.7060707@hesbynett.no> <09f4c794-8b17-05f5-10b7-6a3fa515bfa9@thelounge.net> <58D13598.50403@hesbynett.no> <58D145F9.1080405@youngman.org.uk> <58D14998.1060601@hesbynett.no> <f90b9218-85ef-6af1-fa78-e3641a307566@turmel.org> <CAJH6TXjXR1BM6UojbbgTNpCdyyMhfO4VOG0dxYUAV59PEY+O2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJH6TXjXR1BM6UojbbgTNpCdyyMhfO4VOG0dxYUAV59PEY+O2g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>, Phil Turmel <philip@turmel.org>
Cc: Wols Lists <antlists@youngman.org.uk>, Reindl Harald <h.reindl@thelounge.net>, Adam Goryachev <mailinglists@websitemanagers.com.au>, Jeff Allison <jeff.allison@allygray.2y.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 22/03/17 14:53, Gandalf Corvotempesta wrote:
> 2017-03-21 17:49 GMT+01:00 Phil Turmel <philip@turmel.org>:
>> The correlation is effectively immaterial in a non-degraded raid5 and
>> singly-degraded raid6 because recovery will succeed as long as any two
>> errors are in different 4k block/sector locations.  And for non-degraded
>> raid6, all three UREs must occur in the same block/sector to lose
>> data. Some participants in this discussion need to read the statistical
>> description of this stuff here:
>>
>> http://marc.info/?l=linux-raid&m=139050322510249&w=2
>>
>> As long as you are 'check' scrubbing every so often (I scrub weekly),
>> the odds of catastrophe on raid6 are the odds of something *else* taking
>> out the machine or controller, not the odds of simultaneous drive
>> failures.
> 
> This is true but disk failures happens much more than multiple UREs on
> the same stripe.
> I think that in a RAID6 is much easier to loose data due to multiple
> disk failures.

Certainly multiple disk failures is an easy way to loose data in /any/
storage system (or at least, loose data since the last backup).

The issue here is whether it is more or less likely to be a problem in
RAID6 than other raid arrangements.  And the answer is that complete
disk failures are not more likely during a RAID6 rebuild than during
other raid rebuilds, and a RAID6 will tolerate more failures than RAID1
or RAID5.

Of course, multiple disk failures /do/ occur.  There can be a common
cause of failure.  I have had a few raid systems die completely over the
years.  The causes I can remember include:

1. The SAS controller card died - and I didn't have a replacement.  The
data on the disks is probably still fine.

2. The whole computer died in some unknown way.  The data on the disks
was fine - I put them in another cabinet and re-assembled the md array.

3. A hardware raid card died.  The data may have been on the disks, but
the hardware raid was in a proprietary format.

4. I knocked a disk cabinet off its shelf.  This let to multiple
simultaneous drive failures.

Based on these, my policy is:

1. Stick to SATA drives that are easily available, easily replaced, and
easily read from any system.

2. Avoid hardware raid - use md raid and/or btrfs raid.

3. Do a lot of backups - on independent systems, and with off-site
copies.  Raid does not prevent loss from fire or theft, or a UPS going
bananas, or a user deleting the wrong file.

4. Mount your equipment securely, and turn round slowly!

> 
> Last years i've lose a server due to 4 (of 6) disks failures in less
> than an hours during a rebuild.
> 
> The first failure was detected in the middle of the night. It was a
> disconnection/reconnaction of a single disks.
> The riconnection triggered a resync. During the resync another disk
> failed. RAID6 recovered even from this double failure
> but at about 60% of rebuild, the third disk failed bringing the whole raid down.
> 
> I was waked up by our monitoring system and looking at the server,
> there was also a fourth disk down :)
> 
> 4 disks down in less than a hour. All disk was enterprise: SAS 15K,
> not desktop drives.
> 

