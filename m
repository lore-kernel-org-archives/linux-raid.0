From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: HBA Adaptor advice
Date: Mon, 23 May 2011 01:54:54 -0500
Message-ID: <4DDA04BE.9000300@hardwarefreak.com>
References: <4DD50C89.8060006@wildgooses.com> <20110520020853.GC4759@bitfolk.com> <4DD61948.8050302@wildgooses.com> <4DD6409F.9070904@hardwarefreak.com> <4DD79F4E.7000509@wildgooses.com> <4DD8D1A7.1090803@hardwarefreak.com> <4DD8E0D3.1030905@fnarfbargle.com> <4DD9633E.5000101@hardwarefreak.com> <4DD99A16.5010108@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD99A16.5010108@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/22/2011 6:19 PM, Brad Campbell wrote:

> They're not variable. Or to put it another way, if they _can_ vary the
> spindle speed none of mine ever do.

There's too little official info from WD on what exactly the variable
speed IntelliPower actually means.

> Can you imagine the potential vibration nightmare as 10 drives vary
> their spindle speed up and down? Not to mention the extra load on the
> +12V rail and the delays while waiting for the platters to reach servo
> lock?

WD sells this drive for *consumer* use, meaning 1 to a few drives, where
multi-drive oscillation isn't going to be an issue.  Given that fact,
it's not hard for a WD or Seagate et al in 2011 to build such a drive
with a variable spindle speed.  Apparently WD has done just that.

And btw, HDDs pull the bulk of their power from the 5 volt rail, not the
12 volt rail.  This is the main differentiating factor between a server
PSU and a PC PSU--much more current available on the 5v rail.  Hop on
NewEgg and compare the 12v and 5v rail current of an PC SLI PSU and a
server PSU.

>> IIRC from discussions here, mdadm has alignment issues with hybrid
>> sector size drives when assembling raw disks.  Not everyone assembles
>> their md devices from partitions.  Many assemble raw devices.
> 
> Which means the data starts at sector 0. That's an even multiple of 8.
> Job done. (Mine are all assembled raw also).

I had it slightly backwards.  Thanks for the correction.  The problem
case is building arrays from partitions created using defaults of
many/most partitioning tools.

>> You must boot your server with MD-DOS or FreeDOS and run wdidle3 once
>> for each Green drive in the system.  But, IIRC, if the drives are
>> connected via SAS expander or SATA PMP, this will not work.  A direct
>> connection to the HBA is required.
> 
> Indeed. In my workshop I have an old machine with 3 SATA hotswap bays
> that allowed me to do 3 at once, booting off a USB key into DOS.
> 
>> Once one accounts for all the necessary labor and configuration
>> contortions one must put himself through to make a Green drive into a
>> 'regular' drive, it is often far more cost effective to buy 'regular'
>> drives to begin with.  This saves on labor $$ which is usually greater,
>> from a total life cycle perspective, than the drive acquisition savings.
>>  The drives you end up with are already designed and tuned for the
>> application.  Reiterating Rudy's earlier point, using the Green drives
>> in arrays is "penny wise, pound foolish".
> 
> I agree with you. If I were doing it again I'd spend some extra $$$ on
> better drives, but I've already outlaid the cash and have a working array.

I think a lot of people fell into this 'trap' due the super low price/GB
of the Green drives, and simply not realizing we now have boutique hard
drives and a variety of application tailored drives, just as we have 31
flavors of ice cream.

>> Google WD20EARS and you'll find a 100:1 or more post ratio of problems
>> vs praise for this drive.  This is the original 2TB model which has
>> shipped in much greater numbers into the marketplace than all other
>> Green drives.  Heck, simply search the archives of this list.
> 
> Indeed, but the same follows for almost any drive. People are quick to
> voice their discontent but not so quick to praise something that does
> what it says on the tin.

The WD20EARS was far worse than the typical scenario you describe.
Interestingly, though, the drive itself is not at fault.  The two
problems associated with the drive are:

1.  Deploying it in the wrong application--primary RAID arrays
2.  The Linux partitioning tools lack(ed) support for 512B/4KB hybrids

Desktop MS Windows users seem to love these drives.  They're using them
as intended, go figure...

>> And that backup array may fail you when you need it most:  during a
>> restore.  Search the XFS archives for the horrific tale at University of
>> California Santa Cruz.  The SA lost ~7TB of doctoral student research
>> data due to multiple WD20EARS drives in his primary storage arrays *and*
>> his D2D backup array dying in quick succession.  IIRC multiple grad
>> students were forced to attend another semester to redo their
>> experiments and field work to recreate the lost data, so they could then
>> submit their theses.
> 
> Perhaps. Mine get a SMART short test every morning, a LONG every Sunday
> and a complete array scrub every other Sunday. My critical backups are
> also replicated to a WD World Edition Mybook that lives in another
> building.

I don't like disparaging other SAs, so I didn't go into that aspect of
the tale.  In summary, the SA tasked with managing that system had zero
monitoring in place, no proactive testing, nothing.  He was flying
blind.  When XFS "dropped" 12TB of the 60TB filesystem it took this SA
over a day to realize an entire RAID chassis had gone offline due to
multiple drives failures.  It took him almost a week, with lots of XFS
mailing list expertise, to save the intact 4/5ths of filesystem.  If
he'd have used LVM or md striping instead of concatenation he'd have
lost the entire 60TB filesystem.  He had a backup on a D2D server which
was also built of the 2TB green drives.  Turns out that system already
had 2 of its RAID6 drives down, and a 3 failed while he was
troubleshooting the file server problem.  He discovered this fact when I
decided to attempt a restore of the lost 12TB.

> I've had quite a few large arrays over the years, all comprised of the
> cheapest available storage at the time. I've had drives fail, but aside
> from a Sil3124 controller induced array failure I've never lost data
> because of a cheap hard disk and I've saved many, many, many $$$ on drives.

The problem I see most often, and have experienced first hand, isn't
losing data due to drive failure once in production.  The problem is
usually getting arrays stable when 'pounding them on the test bench'.
I've used hardware RAID far more often than md RAID over the years, and
some/many hardware RAID cards are just really damn picky about which
drives they'll work reliably with.  md RAID is more forgiving in this
regard, ones of its many benefits.

> I'm not arguing the penny wise, pound foolish sentiment. I'm just
> stating my personal experience has been otherwise with drives.

One shoe won't fit every foot.  Going the cheap route is typically more
labor intensive.  If proper procedures are used to monitor and replace
before the sky falls, this solution can work in many environments.  In
other environments, drive failure notification must be automatic,
management software and light path diagnostics must clearly show which
drive has failed, all so a $15/hour low skilled datacenter technician
can walk down the rack isle, find the dead drive, pull and replace it,
without system administrator intervention.  The SA will simply launch
his management console and make sure the array is auto-rebuilding.

-- 
Stan
