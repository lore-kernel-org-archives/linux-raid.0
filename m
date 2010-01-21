From: Steven Haigh <netwiz@crc.id.au>
Subject: Re: Why does one get =?UTF-8?Q?mismatches=3F?=
Date: Thu, 21 Jan 2010 21:52:44 +1100
Message-ID: <9cb28690ac0d4d79dde44b0f7c43d7d0@localhost>
References: <387070.15704.qm@web51305.mail.re2.yahoo.com> <hj77p7$rsr$1@ger.gmane.org> <70ed7c3e1001201244k3c734336y8e145bb50f88de26@mail.gmail.com> <hj7vta$nvq$1@ger.gmane.org> <70ed7c3e1001201430i72023a9fq1341b671073ac53c@mail.gmail.com> <hj80v1$rap$1@ger.gmane.org> <968ea7bde37a4085f4588f2ef4447d94@localhost> <4B580B8A.5080806@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B580B8A.5080806@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 21 Jan 2010 09:08:42 +0100, Asdo <asdo@shiftmail.org> wrote:
> Steven Haigh wrote:
>> On Wed, 20 Jan 2010 17:43:45 -0500, Brett Russ <bruss@netezza.com>
wrote:
>>
>> CUT!
> Might that be a problem of the disks/controllers?
> Jon and Steven, what hardware do you have?

I'm running some fairly old hardware on this particular server. It's a
dual P3 1Ghz.

After running a repair on /dev/md2, I now see:
# cat /sys/block/md2/md/mismatch_cnt
1536

Again, no smart errors, nothing to indicate a disk problem at all :(

As this really keeps killing the machine and it is a live system - the
only thing I can really think of doing is to break the RAID and just rsync
the drives twice daily :\

-- 
Steven Haigh
 
Email: netwiz@crc.id.au
Web: http://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897
Fax: (03) 8338 0299
