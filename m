From: Phil Turmel <philip@turmel.org>
Subject: Re: SMART detects pending sectors; take offline?
Date: Fri, 5 Jan 2018 08:50:20 -0500
Message-ID: <6b7ed6c2-497a-2b8d-4cd4-d7a8620bba75@turmel.org>
References: <629d29b4-a3ae-533f-bdba-f115e99d8ce4@shenkin.org>
 <a5487193-24e6-879b-bd09-caf5f75c8fcc@turmel.org>
 <05e4489d-98ea-4d12-02d6-f13a98e3d5d4@shenkin.org>
 <201ea04e-1a03-fc83-c31c-146b50bb8624@thelounge.net>
 <47ec07c3-25ae-9595-78a2-8420c106f2a0@fnarfbargle.com>
 <20497c70-140d-c4dd-0201-816477bd467f@shenkin.org>
 <14f1fce1-2959-e051-f7c8-1d98951d744a@fnarfbargle.com>
 <07170cf8-d951-013b-7e67-eee54aa60c65@shenkin.org>
 <61e91b55-5b96-143e-15c8-4a320f89eeb2@turmel.org>
 <ae183814-248b-2d45-8074-85787fcd0d61@shenkin.org>
 <6572ed42-8559-84eb-0468-7823786c3001@turmel.org>
 <7bce6228-0695-ff30-7cc0-60486be128ff@shenkin.org>
 <c24ffbc6-6ba6-ef04-76f3-2217fe5f4926@shenkin.org>
 <97c75be5-1988-0e66-0d50-f06188418b3b@fnarfbargle.com>
 <cd34964a-e269-6dd7-3c36-73a9c8dbb61d@shenkin.org>
 <bc2e597b-1585-f9b6-ef1a-f1aa3e1f39a0@fnarfbargle.com>
 <85891f3d-eaf6-9127-b55a-dea9d21d180b@fnarfbargle.com>
 <35f51be7-7dbd-88f8-e743-3976bef51de2@shenkin.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <35f51be7-7dbd-88f8-e743-3976bef51de2@shenkin.org>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Shenkin <al@shenkin.org>, Brad Campbell <brad@fnarfbargle.com>, Reindl Harald <h.reindl@thelounge.net>, Edward Kuns <eddie.kuns@gmail.com>, Mark Knecht <markknecht@gmail.com>
Cc: Wols Lists <antlists@youngman.org.uk>, Carsten Aulbert <carsten.aulbert@aei.mpg.de>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Alex,

On 01/05/2018 05:10 AM, Alexander Shenkin wrote:
> On 1/5/2018 5:25 AM, Brad Campbell wrote:

>> I'm going to go and write a letter of apology to my primary school
>> maths teacher now.

> Thanks much, Brad.  fdisk & parted output are below.  I have swap space
> mounted on /dev/sda4, 15,984,640 sectors long, after the partitions used
> for raid.  I'm not sure where exactly the parity data sits... Looks to
> me like this happened in swap space, no?  Currently, swapon reports
> 552,272 kb (= 1,104,544 sectors) in use (i think).  If that's
> contiguous, then the write should have happened after the used space
> (13,297,904 > 1,104,544). But I'm not sure swap is contiguous.  In this
> case, regardless, I suspect I should just reboot, and then run
> checkarray to be safe?

The output of fdisk is invalid on your system, see the warning it
printed.  Use gdisk or parted instead.  Don't use '*'.

> One followup: is parity info stored in a separate area than data info on
> the disk?  If the write *had* fallen within the raid partition area,
> would you indeed be able to tell if it overwrote data vs parity vs both?
>  Google wouldn't tell me...

No. Parity is interleaved with data on all devices, chunk by chunk, on
all default raid5/6 layouts.  In raid4, the last device is all of the
parity.  There are optional layouts for raid5 that do the same, and
variants for raid6 that place various combinations of parity and
syndrome at either end.  See the --layout option in the mdadm man page.

The non-data area of member devices contains at least the superblock,
and optionally a write-intent bitmap and/or a bad-block list.  Most of
the non-data space is reserved for optimizing future --grow operations.

> user@machinename:~$ sudo fdisk -l /dev/sda*
> 
> WARNING: GPT (GUID Partition Table) detected on '/dev/sda'! The util
> fdisk doesn't support GPT. Use GNU Parted.

All of the partition data following this warning is bogus -- it is the
"protective" MBR record.

Phil
