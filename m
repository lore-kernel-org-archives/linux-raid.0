From: Phil Turmel <philip@turmel.org>
Subject: Re: Wierd: Degrading while recovering raid5
Date: Tue, 10 Feb 2015 08:51:22 -0500
Message-ID: <54DA0CDA.2010800@turmel.org>
References: <CAP7a4UQCB=jdf7=sz8MoYL+WGbMbT_09_xL460DLX-epLAS0Sw@mail.gmail.com> <54D9B4AD.8010204@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54D9B4AD.8010204@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>, Kyle Logue <teque5@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Kyle,

Your symptoms look like classic timeout mismatch.  Details interleaved.

On 02/10/2015 02:35 AM, Adam Goryachev wrote:

> There are other people who will jump in and help you with your problem,
> but I'll add a couple of pointers while you are waiting. See below.

> On 10/02/15 15:20, Kyle Logue wrote:
>> Hey all:
>>
>> I have a 5 disk software raid5 that was working fine until I decided
>> to swap out an old disk with a new one.
>>
>> mdadm /dev/md0 --add /dev/sda1
>> mdadm /dev/md0 --fail /dev/sde1

As Adam pointed out, you should have used --replace, but you probably
wouldn't have made it through the replace function anyways.

>> At this point it started automatically rebuilding the array.
>> About 60%? of the way in it stops and I see a lot of this repeated in
>> my dmesg:
>>
>> [Mon Feb  9 18:06:48 2015] ata5.00: exception Emask 0x0 SAct 0x0 SErr
>> 0x0 action 0x6 frozen
>> [Mon Feb  9 18:06:48 2015] ata5.00: failed command: SMART
>> [Mon Feb  9 18:06:48 2015] ata5.00: cmd
>> b0/da:00:00:4f:c2/00:00:00:00:00/00 tag 7
>> [Mon Feb  9 18:06:48 2015]          res
>> 40/00:ff:00:00:00/00:00:00:00:00/40 Emask 0x4 (timeout)
                                                 ^^^^^^^^^
Smoking gun.

>> [Mon Feb  9 18:06:48 2015] ata5.00: status: { DRDY }
>> [Mon Feb  9 18:06:48 2015] ata5: hard resetting link
>> [Mon Feb  9 18:06:58 2015] ata5: softreset failed (1st FIS failed)
>> [Mon Feb  9 18:06:58 2015] ata5: hard resetting link
>> [Mon Feb  9 18:07:08 2015] ata5: softreset failed (1st FIS failed)
>> [Mon Feb  9 18:07:08 2015] ata5: hard resetting link
>> [Mon Feb  9 18:07:12 2015] ata5: SATA link up 1.5 Gbps (SStatus 113
>> SControl 310)
>> [Mon Feb  9 18:07:12 2015] ata5.00: configured for UDMA/33
>> [Mon Feb  9 18:07:12 2015] ata5: EH complete

Notice that after a timeout error, the drive is unresponsive for several
more seconds -- about 24 in your case.

> ....  read about timing mismatches
> between the kernel and the hard drive, and how to solve that. There was
> another post earlier today with some links to specific posts that will
> be helpful (check the online archive).

That would have been me.  Start with this link for a description of what
you are experiencing:

http://marc.info/?l=linux-raid&m=135811522817345&w=1

First, you need to protect yourself from timeout mismatch due to the use
of desktop-grade drives.  (Enterprise and raid-rated drives don't have
this problem.)

{ If you were stuck in the middle of a replace a you had just
worked-around your timeout problem, it would likely continue and
complete.  You've lost that opportunity. }

Show us the output of "smartctl -x" for all of your drives if you'd like
advice on your particular drives.  (Pasted inline is preferred.)

Second, you need to find and overwrite (with zeros) the bad sectors on
your drives.  Or ddrescue to a complete set of replacement drives and
assemble those.

Third, you need to set up a cron job to scrub your array regularly to
clean out UREs before they accumulate beyond MD's ability to handle it
(20 read errors in an hour, 10 per hour sustained).

Phil
