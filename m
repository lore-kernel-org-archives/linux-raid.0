From: Berkey B Walker <berk@panix.com>
Subject: Re: Is It Hopeless?
Date: Mon, 27 Dec 2010 20:36:33 -0500
Message-ID: <4D193F21.3020907@panix.com>
References: <201012261019.56481.CACook@quantum-sci.com> <201012261606.29281.CACook@quantum-sci.com> <4D182587.4040801@turmel.org> <201012270510.51520.CACook@quantum-sci.com> <4D18C0C5.4010606@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D18C0C5.4010606@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Whereas a tape and drive does not offer an "Everything is the single 
point of failure" as does a permanently _sealed_  storage disc/drive, 
tape is definately NOT "fool proof", nor even the lazy, everyday 
operator.  The operator and system requirements for use and maintenance 
are still, basically, as they were a half century ago.  Imagine if the 
operator were required to retension his/her RAID disks and replace them 
after so many uses.  Money drives it all, creating street level, IT 
techs, SysAdmins aproaching the commodity level.  This not intended to 
be pointing at the Original Poster but market and marketing of today.
berk

Stan Hoeppner wrote:
> Carl Cook put forth on 12/27/2010 7:10 AM:
>    
>>> Every time I read/hear this I cringe.  If that is the case your data is worthless to begin with so just delete it all right now.  You are literally saying the same thing with your statement.
>>>        
>> No, I'm saying that the MTBF of disk drives is astronomical,
>>      
> Interesting statement.  You're arguing the reliability of these modern
> giant driver, yet use RAID 10 instead of simple spanning or striping.  I
> wonder why that is...
>
>    
>> and the likelihood of a fail during backup is miniscule.
>>      
> Failure during backup is of less concern.  Failure of the source
> media/system during _restore_ is.  Read this thread and the previous
> thread from Eli a few months prior.  It will open your eyes to the peril
> of using a D2D backup system with 2TB WD Green drives.  His choice of
> such, along with other poor choices based on acquisition cost, almost
> cost him his job.  Everything is cheap until it costs you dearly.
>
> http://comments.gmane.org/gmane.comp.file-systems.xfs.general/35555
>
> Too many (especially younger) IT people _only_ consider up front
> acquisition cost of systems and not long term support of such systems.
> Total system cost _must_ include a reliable DRS (Disaster Recover
> System).  If you can't afford the DRS to go with a new system, then you
> can't afford that system, and must downsize it or reduce its costs in
> some way to allow inclusion of DRS.
>
>   There is no free lunch.  Eli nearly lost his job over poor acquisition
> and architecture choices.  In that thread he makes the same excuses you
> do regarding his total storage size needs and his "budget for backup".
> There is no such thing as "budget for backup".  DRS _must_ be included
> in all acquisition costs.  If not, someone will pay dear consequences at
> some point in time if the lost data has real value.  In Eli's case the
> lost data was Ph.D. student research data.  If one student lost all his
> data, he may likely have to redo an entire year of school.  Who pays for
> that?  Who pays for his year of lost earnings sine he can't (re)enter
> the workforce at Ph.D. pay scale?  This snafu may cost a single Ph.D.
> student, the university, or both, $200K or more depending on career field.
>
> If they'd had a decent tape silo he'd have lost no data.
>
>    
>> MTBF of tape is hundreds of times sooner.
>>      
> Really?  Eli had those WD20EARS online in his D2D backup system for less
> than 5 months.  LTO tape reliability is less than 5 months?  Show data
> to back that argument up please.
>
> Tape isn't perfect either, but based on my experience and reading that
> of many many others, it's still better than D2D is many cases.  Also
> note that tapes don't wholesale fail as disks do.  Bad spots on tape
> cause some lost files, not _all_ the files, as is the case when a D2D
> system fails during restore.
>
> If a tape drive fails during restore, you don't lose all the backup
> data.  You simply replace the drive and run the tapes through the new
> drive.  If you have a multi-drive silo or library, you simply get a log
> message of the drive failure, and your restore may simply be slower.
> This depends on how you've setup parallelism in your silo.  Outside of
> the supercomputing centers where large files are backed up in parallel
> streams to multiple tapes/drives simultaneously ("tape RAID" or tape
> striping) most organizations don't stripe this way.  They simply
> schedule simultaneous backups of various servers each hitting a
> different drive in the silo.  In this case if all other silo drives are
> busy, then your restore will have to wait.  But, you'll get your system
> restored.
>
>    
>> Not to mention that tape would take forever, and require constant tending.
>>      
> Eli made similar statements as well, and they're bogus.  Modern high cap
> drives/tapes are quite speedy, especially if striped using the proper
> library/silo management software and planning/architecure.  Some silos
> can absorb streaming backups at rates much higher than midrange SAN
> arrays, in the multiple GB/s range.  They're not cheap, but then, good
> DRS solutions aren't. :)
>
> The D2D vendors use this scare tactic often also.  Would you care to
> explain this "constant tending"?
>
>    
>> This is why it's not used anymore.
>>      
> Would you care to back this up with actual evidence?  Tape unit shipment
> numbers are down and declining as more folks (making informed decisions,
> or otherwise) move to D2D and cloud services, but tape isn't dead by any
> stretch of the imagination.  The D2D vendors sure want you to think so.
>   Helps them sell more units.  This is simply FUD spreading.
>
>    
>> My storage is 2TB now, but my library is growing all the time.  Backing to off-line disk storage is the only practical way now, given the extremely low cost and high capacity and speed.  Each WD 2TB drive is $99 from Newegg!  Astounding.  Thanks for the input though.
>>      
> No, it's not the only practical methodology.  Are you not familiar with
> "differential copying"?  It's the feature that makes rsync so useful, as
> well as tape.  Once you have your first complete backup of that 2TB of
> media files, you're only writing to tape anything that's changed.
>
> At $99 you'll have $396 of drives in your backup server.  Add the cost
> of a case ($50), PSU ($30), mobo ($80), CPU ($100), DIMMs ($30), optical
> drive ($20), did I omit anything?  You're now at around $700.
>
> You now have a second system requiring "constant tending".  You also
> have 9 components that could fail during restore.  With a tape drive you
> have one.  Calculate the total MTBF of those 9 components using the
> inverse probability rule and compare that to the MTBF of a single HP
> LTO-2 drive?
>
> Again, you're like a deer in the headlights mesmerized by initial
> acquisition cost.  The tape solution I mentioned has a ~$200 greater
> acquisition cost, yet its reliability is greater, and it is purpose
> built for the task at hand.   Your DIY D2D server is not.
>
> Please keep in mind Carl I'm not necessarily speaking directly to you,
> or singling you out on this issue.  This list has a wider audience.
> Many sites archive this list, and those Googling the subject need good
> information on this subject.  The prevailing wind is D2D, but that
> doesn't make it God's gift to DRS.  As I' noted earlier, many folks are
> being bitten badly by the mindset you've demonstrated in this thread.
>
> D2D and tape both have their place, and both can do some jobs equally
> well at the same or varying costs.  D2D is better for some scenarios in
> some environments.  Tape is the _ONLY_ solution for others, and
> especially do for some government and business scenarios that require
> WORM capability for legal compliance.  There are few, if any, disk based
> solutions that can guarantee WORM archiving.
>
>    
