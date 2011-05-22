From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: HBA Adaptor advice
Date: Sun, 22 May 2011 14:25:50 -0500
Message-ID: <4DD9633E.5000101@hardwarefreak.com>
References: <4DD50C89.8060006@wildgooses.com> <20110520020853.GC4759@bitfolk.com> <4DD61948.8050302@wildgooses.com> <4DD6409F.9070904@hardwarefreak.com> <4DD79F4E.7000509@wildgooses.com> <4DD8D1A7.1090803@hardwarefreak.com> <4DD8E0D3.1030905@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD8E0D3.1030905@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/22/2011 5:09 AM, Brad Campbell wrote:
> On 22/05/11 17:04, Stan Hoeppner wrote:
> 
>> WD's Green drives have a 5400 rpm 'variable' spindle speed.  The Seagate
>> 2.5" SAS drive has a 7.2k spindle speed.
> 
> Actually, I'm pretty sure the WD drives have a 5400 rpm spindle speed
> period. I've got 15 of them here and I have no evidence of any form of
> spindle speed variation. They say the drives have spindle speed :
> "intellipower" which is marketspeak for slow enough to save a few watts,
> but fast enough to do the job.

From:  http://www.anandtech.com/show/2385/2

The Western Digital drive's IntelliPower algorithm, which varies the
rotational speed between 5400RPM and 7200RPM, dictates the Western
Digital's rotational speed.

>> It's difficult to align partitions properly on the Green drives due to
>> native 4K sectors translated by drive firmware to 512B sectors.  The
>> Seagate SAS drive has native 512B sectors.
> 
> Actually it's not difficult at all. You just make sure all your
> partitions start on an even multiple of 8 sectors. No magic in it. Just
> the same as all my SSD partitions start on 512k boundaries.

IIRC from discussions here, mdadm has alignment issues with hybrid
sector size drives when assembling raw disks.  Not everyone assembles
their md devices from partitions.  Many assemble raw devices.

>> The Green drives have aggressive power saving firmware not suitable for
>> business use as the heads are auto parked every 8 seconds or so.  IIRC
>> the drive goes into sleep mode after a short period of inactivity on the
>> host interface.  In short, these drives are designed optimally for the
>> "is not running" case rather than the "running" case.  Hence the name
>> "Green".  How do you save power?  Turn off the drive.  And that's
>> exactly what these drives are designed to do.
> 
> You can turn off the aggressive head parking with a little DOS utility,
> and they don't go to sleep at all unless you tell them to. They will
> happily keep spinning just the same as any other disk.

You must boot your server with MD-DOS or FreeDOS and run wdidle3 once
for each Green drive in the system.  But, IIRC, if the drives are
connected via SAS expander or SATA PMP, this will not work.  A direct
connection to the HBA is required.

Once one accounts for all the necessary labor and configuration
contortions one must put himself through to make a Green drive into a
'regular' drive, it is often far more cost effective to buy 'regular'
drives to begin with.  This saves on labor $$ which is usually greater,
from a total life cycle perspective, than the drive acquisition savings.
 The drives you end up with are already designed and tuned for the
application.  Reiterating Rudy's earlier point, using the Green drives
in arrays is "penny wise, pound foolish".

Google WD20EARS and you'll find a 100:1 or more post ratio of problems
vs praise for this drive.  This is the original 2TB model which has
shipped in much greater numbers into the marketplace than all other
Green drives.  Heck, simply search the archives of this list.

> I'm running them in a couple of large(ish) RAID arrays. I'm not saying
> it's a good idea, it's just been my experience with ultra-cheap drives
> that if you burn in the drives to weed out the early failures, and you
> keep them running 24/7 in a nice environment they tend to last long
> enough to do the job. I tend to replace my drives at around ~30,000
> hours, so these have a long way to go yet.

You're one out of 100.  Congratulations. :)

> On the other hand, I have my company data on Seagate Cheetah SAS drives
> in RAID-10, but I back up to the large WD Green arrays.

And that backup array may fail you when you need it most:  during a
restore.  Search the XFS archives for the horrific tale at University of
California Santa Cruz.  The SA lost ~7TB of doctoral student research
data due to multiple WD20EARS drives in his primary storage arrays *and*
his D2D backup array dying in quick succession.  IIRC multiple grad
students were forced to attend another semester to redo their
experiments and field work to recreate the lost data, so they could then
submit their theses.

How much did this incident cost the university and the Ph. D. students
in real money and lost time?  I'm sure some actuaries might be able to
tell you, and the real cost is likely hundreds of thousands of times the
cost savings of using these crap drives, especially when you figure in
the lost salaries for 6 months of these Ph. D. students.  Depending on
their field this could be over $100k per student.  If such 10 students
were affected that's potentially $1 million in lost earnings alone.

Spending an additional $10-20K on proper disk drives would have saved an
enormous amount in this case, and not just purely money.  If you were
one of the students who was told you had to repeat a semester because a
computer lost all of your research data, how would you digest and cope
with that?  I'd bet at least one, if not more, lawsuits/settlements will
results from this.

Give that things like this can, and DO happen when banking on cheap
consumer drives in a production environment, why would anyone ever take
such a chance?

-- 
Stan
