From: David Lethe <david@santools.com>
Subject: Re: NEWBIE Q: expanding hardware RAID
Date: Mon, 31 Aug 2009 23:33:15 -0500
Message-ID: <C6C20E3B.CB5A%david@santools.com>
References: <714cf35c0908311753q1b7b26d8r2c148d566ea6fdeb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <714cf35c0908311753q1b7b26d8r2c148d566ea6fdeb@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Anil Raj <anil.calvin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The answer to #2 is a function of the make/model of hardware RAID, and the
configuration.   Sorry.  While there are standards for what RAID-5 means,
there is no built-in universal program that will configure all RAID
subsystems.

Dell supports several RAID controllers.

The answer to #1 is also, unfortunately a function of the make/model of
RAID.  You can enter cat /proc/scsi/scsi and see if PERC, or DELL or LSI
shows up in the vendor field.  If so, highly probable it is RAID, but that
won't tell you if it is RAID0, 1, 10, 5, etc...   If there are entries in
/dev/mpt, then it is a LSI-based RAID controller. (But not necessarily in a
hardware protected RAID mode)

If it says PERC or LSI, it is definitely a RAID config, but the config could
be set up so you see individual disk drives, or it could be a n-DISK RAID5
that is partitioned into individual disks.

If it is hardware RAID, then I suggest, based solely on the newbie questions
that you find the documentation and read a bit, and run whatever software
that comes with it to assess the situation.    Expanding a hardware RAIDset,
can be dangerous, especially if you are unfamiliar with it.

For example, maybe the firmware is ancient, or you have a lot of bad blocks
because you never fixed them, or even knew about running consistency/repairs
. If you don't know what you are doing, then you can easily lose everything.

So FIRST thing I would do before so much as powering off is a full backup.
If you don't know what you have, then obviously you can't properly maintain
it.  (Not trying to put you down, but if you aren't willing or able to
examine the configuration while it is powered on, and you don't want to do a
reboot indicates the system may be unstable, or is mission critical and has
no maintenance window, or you just don't know how to bring it back up
properly.  If any of those are the case, back up before something fails.

Remember disk drives have a 100% probability of failure ... Eventually.  You
just don't want it to happen while you are responsible for the system.
 

P.S. Did you just try the simple thing of logging onto Dell's support site
and entering the service tag and get the configuration that they originally
shipped?



On 8/31/09 7:53 PM, "Anil Raj" <anil.calvin@gmail.com> wrote:

> current RAID setup to include
> the new drives. Is there any documentation on expanding hardware RAID?
> ( I found doc on growing software RAID on the mailing list's wiki but
> none on hardware RAID.)
> 
> I really really hope someone can help me with these questions, please.
> Also, if this is not the right forum (and there is a more relevant
> forum) for these questions, please do let

