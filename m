From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Spares and partitioning huge disks
Date: Sat, 8 Jan 2005 18:09:48 -0500
Message-ID: <200501082309.j08N9t911087@www.watkins-home.com>
References: <200501082025.20463.maarten@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501082025.20463.maarten@ultratux.net>
Sender: linux-raid-owner@vger.kernel.org
To: 'maarten' <maarten@ultratux.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Maarten said:
"Normally, the minute a drive fails, it gets kicked and the spare would kick
in and md syncs this spare.  We now have a non-degraded array again."

Guy says:
But, you make it seem instantaneously!  The array will be degraded until the
re-sync is done.  In my case, that takes about 60 minutes, so 1 extra minute
is insignificant.

Marrten said:
"Yes, but this would be impossible to do, since md cannot anticipate _which_

disk you're going to fail before it happens. ;)"

Guy says:
But, I could tell md which disk I want to spare.  After all, I know which
disk I am going to fail.  Maybe even an option to mark a disk as "to be
failed", which would cause it to be spared before it goes off-line.  Then md
could fail the disk after it has been spared.  Neil, add this to the wish
list!  :)

EMC does this on their big iron.  If the system determines a disk is having
too many issues (bad blocks or whatever), the system predicts a failure, the
system copies the disk to a spare.  That way a second failure during the
re-sync would not be fatal.  And a direct disk to disk copy is much faster
(or easier) than a re-build from parity.  This is how it was explained to me
about 5 years ago.  No idea if it was marketing lies or truth.  But I liked
the fact that my data stayed redundant while the spare was being re-built.
This would not work if a drive failed, only if a drive failure was
predicted.  Another cool feature... the disk array then makes a support
call.  The disk is replaced quickly, normally before any redundancy was
lost.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of maarten
Sent: Saturday, January 08, 2005 2:25 PM
To: linux-raid@vger.kernel.org
Subject: Re: Spares and partitioning huge disks

On Saturday 08 January 2005 19:55, you wrote:
> My warning about user error was not targeted at you!  :)
> Sorry if it seemed so.

:-)

> And the order does not matter!

Hm... yes you're right. But adding the disk is more prudent (or is it?)

Grr. Now you've got ME thinking !  ;-)

Normally, the minute a drive fails, it gets kicked and the spare would kick
in 
and md syncs this spare.  We now have a non-degraded array again.
If I then fail the spare first, the array goes into degraded mode. Whereas
if 
I hotadd the disk, it becomes a spare. Presumably if I now fail the original

spare, the real disk will get synced again, to get the same setup as before.
But yes, you're right; during this step it is degraded again. Oh well...

> It would be cool if the rebuild to the repaired disk could be done before
> the spare was failed or removed.  Then the array would not be degraded at
> all.

Yes, but this would be impossible to do, since md cannot anticipate _which_ 
disk you're going to fail before it happens. ;)

> If I ever re-build my system, or build a new system, I hope to use RAID6.

I tried this in last fall, but it didn't work out then. See the list
archives.

> The Seagate test is on-line.  Before I started using the Seagate tool, I
> used dd.

I'm not as cautious as you are. I just pray the hot spare does what its 
supposed to do.

> My disks claim to be able to re-locate bad blocks on read error.  But I am
> not sure if this is correctable errors or not.  If not correctable errors
> are re-located, what data does the drive return?  Since I don't know, I
> don't use this option.  I did use this option for awhile, but after
> re-reading about it, I got concerned and turned it off.

Afaik, if a drive senses it gets more 'difficult' than usual to read a
sector, 
it will automatically copy it to a spare sector and reassign it. However, I 
doubt the OS gets any wiser this happens, so neither would md.
In which cases the error gets noticed by md I don't precisely know, but I 
reckon that may well be when the error is uncorrectible.
Not _undetectable_, to quote from another thread... 8-)  

> This is from the readme file:
> Automatic Read Reallocation Enable (ARRE)
>         -Marreon/off  enable/disable ARRE bit
>            On, drive automatically relocates bad blocks detected
>            during read operations.  Off, drive creates Check condition
>            status with sense key of Medium Error if bad blocks are
>            detected during read operations.

Hm. I would definitely ENable that option.  But what do I know.

It also depends I guess on how fatal reading bad data undetected is for you.

For me, if one of my mpegs or mp3s develops a bad sector I can probably live

with that. :-)

Maarten

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

