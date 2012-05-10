From: Daniel Pocock <daniel@pocock.com.au>
Subject: Re: md RAID with enterprise-class SATA or SAS drives
Date: Thu, 10 May 2012 18:42:13 +0000
Message-ID: <4FAC0C05.1090007@pocock.com.au>
References: <4FAAE8F1.8000600@pocock.com.au> <CALFpzo5ObdwFATdT4e20znnxzU5hX9SVSfqJcdqOXM1FEYJQuw@mail.gmail.com> <4FABC7C6.4030107@turmel.org> <CALFpzo6BECrv2eTbSRKwUzpTopx_0EmD+UipqUf-XE=vzz2OnQ@mail.gmail.com> <4FABE724.40103@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FABE724.40103@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Marcus Sorensen <shadowsor@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 10/05/12 16:04, Phil Turmel wrote:
> On 05/10/2012 11:26 AM, Marcus Sorensen wrote:
>> On Thu, May 10, 2012 at 7:51 AM, Phil Turmel <philip@turmel.org> wrote:
> 
> [trim /]
> 
>>> Here is where Marcus and I part ways.  A very common report I see on
>>> this mailing list is people who have lost arrays where the drives all
>>> appear to be healthy.  Given the large size of today's hard drives,
>>> even healthy drives will occasionally have an unrecoverable read error.
>>>
>>> When this happens in a raid array with a desktop drive without SCTERC,
>>> the driver times out and reports an error to MD.  MD proceeds to
>>> reconstruct the missing data and tries to write it back to the bad
>>> sector.  However, that drive is still trying to read the bad sector and
>>> ignores the controller.  The write is immediately rejected.  BOOM!  The
>>> *write* error ejects that member from the array.  And you are now
>>> degraded.
>>>
>>> If you don't notice the degraded array right away, you probably won't
>>> notice until a URE on another drive pops up.  Once that happens, you
>>> can't complete a resync to revive the array.
>>>
>>> Running a "check" or "repair" on an array without TLER will have the
>>> opposite of the intended effect: any URE will kick a drive out instead
>>> of fixing it.
>>>
>>> In the same scenario with an enterprise drive, or a drive with SCTERC
>>> turned on, the drive read times out before the controller driver, the
>>> controller never resets the link to the drive, and the followup write
>>> succeeds.  (The sector is either successfully corrected in place, or
>>> it is relocated by the drive.)  No BOOM.
>>>
>>
>> Agreed. In the past there has been some debate about this. I think it
>> comes down to your use case, the data involved and what you expect.
>> TLER/ERC can generally make your array more durable to minor hiccups,
>> and is likely preferred if you can stomach the cost, at the potential
>> risk that I described.  If the failure is a simple one-off read
>> failure, then Phil's scenario is very likely. If the drive is really
>> going bad (say hitting max_read_errors), then the disk won't try very
>> hard to recover your data, at which point you have to hope the other
>> drive doesn't have even a minor read error when rebuilding, because it
>> also will not try very hard. In the end it's up to you what behavior
>> you want.
> 
> Well, I approach this from the assumption that the normal condition
> of a production RAID array is *non-degraded*.  You don't want isolated
> read errors to hold up your application when the data can be quickly
> reconstructed from the redundancy.  And you certainly don't want
> transient errors to kick drives out of the array.

I think you have to look at the average user's perspective: even most IT
people don't want to know everything about what goes on in their drives.
 They just expect stuff to work in a manner they consider `sensible'.
There is an expectation that if you have RAID you have more safety than
without RAID.  The idea that a whole array can go down because of
different sectors failing in each drive seems to violate that expectation.

> Coordinating the drive and the controller timeouts is the *only* way
> to avoid the URE kickout scenario.

I really think that is something that needs consideration, as a minimum,
should md log a warning message if SCTERC is not supported and
configured in a satisfactory way?

> Changing TLER/ERC when an array becomes degraded for a real hardware
> failure is a useful idea. I think I'll look at scripting that.

Ok, so I bought an enterprise grade drive, the WD RE4 (2TB) and I'm
about to add it in place of the drive that failed.

I did a quick check with smartctl:

# smartctl -a /dev/sdb -l scterc
....
SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

so the TLER feature appears to be there.  I haven't tried changing it.

For my old Barracuda 7200.12 that is still working, I see this:

SCT Error Recovery Control:
           Read: Disabled
          Write: Disabled

and a diff between the full output for both drives reveals the following:

-SCT capabilities:             (0x103f) SCT Status supported.
+SCT capabilities:             (0x303f) SCT Status supported.
                                        SCT Error Recovery Control
supported.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.




>> Here are a few odd things to consider, if you're worried about this topic:
>>
>> * Using smartctl to increase the ERC timeout on enterprise SATA
>> drives, say to 25 seconds, for use with md. I have no idea if this
>> will cause the drive to actually try different methods of recovery,
>> but it could be a good middle ground.
> 

What are the consequences if I don't do that?  I currently have 7
seconds on my new drive.  If md can't read a sector from the drive, will
it fail the whole drive?  Will it automatically read the sector from the
other drive so the application won't know something bad happened?  Will
it automatically try to re-write the sector on the drive that couldn't
read it?

Would you know how btrfs behaves in that same scenario - does it try to
write out the sector to the drive that failed the read?  Does it also
try to write out the sector when a read came in with a bad checksum and
it got a good copy from the other drive?

> For a healthy array, I think this is counter-productive, as you are
> holding up your applications.  Any sector that is marginal and needs
> that much time to recover really ought to be re-written anyways.
> 
>> * increasing max_read_errors in an attempt to keep a TLER/ERC disk in
>> the loop longer. The only reason to do this would be if you were
>> proactive in monitoring said errors and could add in more redundancy
>> before pulling the failing drive, thus increasing your chances that
>> the rebuild succeeds, having more *mostly* good copies.
>>
>> * Increasing the SCSI timeout on your desktop drives to 60 seconds or
>> more, giving the drive a chance to succeed in deep recovery. This may
>> cause IO to block for awhile, so again it depends on your usage
>> scenario.
> 
> I can understand using all available means to resync/rebuild a
> degraded array, but I can't see leaving those settings on a healthy
> array.
> 
>> * frequent array checks - perhaps in combination with the above, can
>> increase the likelihood that you find errors in a timely manner and
>> increase the chances that the rebuild will succeed if you've only got
>> one good copy left.
> 
> Frequent array checks are not optional, if you want flush out any UREs
> in the making, and maximize your odds of successfully rebuilding after
> a drive replacement.  If you are running RAID6 or a triple mirror, with
> frequent checks, you are very safe.
> 
> [...]
> 
>>> Neither Seagate nor Western Digital offer any desktop drive with any
>>> form of time-limited error recovery.  Seagate and WD were my "go to"
>>> brands for RAID.  I am now buying Hitachi, as they haven't (yet)
>>> followed their peers.  The "I" in RAID stands for "inexpensive",
>>> after all.
>>
>> I keep hearing that, and I was always under the impression that the
>> "I" stood for "Independent", as you can do RAID with any independent
>> disk, cheap or expensive. Seems it was changed mid-90's. I suppose
>> both are accepted, but perhaps the one we use says something about our
>> level of seniority :-)
> 
> Hmmm.  I hadn't noticed the change to "independent".  Can't allow any
> premium technology to be inexpensive, can we?
> 
> And yes, there's grey in my beard.
> 
> Phil
