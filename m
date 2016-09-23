From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Linux raid wiki - force assembling an array where one drive has a
 different event count - advice needed
Date: Sat, 24 Sep 2016 09:46:35 +1000
Message-ID: <f9e2b742-1a26-c6f1-2b35-1c3cbd3099e4@websitemanagers.com.au>
References: <57E5B77D.5080608@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57E5B77D.5080608@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On 24/09/2016 09:15, Wols Lists wrote:
> As I understand it, the event count on all devices in an array should be
> the same. If they're a little bit different it doesn't matter too much.
> My question is how much does it matter?
>
> Let's say I've got a raid-5 and suddenly realise that one of the drives
> has failed and been kicked from the array. What happens if I force a
> reassemble? Or do a --re-add?
>
> I don't actually have a clue, and if I'm updating the wiki I need to
> know. What I would HOPE happens, is that the raid code fires off an
> integrity scan, reading each stripe, and updating the re-added drive if
> it's out-of-date. Is this what the bitmap enables? So the raid code can
> work out what changes have been made since the drive has been booted?
If you have a bitmap, and you re-add a drive to the array, then it will 
check the bitmap to find out what is out of date, and then re-sync those 
parts of the drive.
If there is no bitmap, and you re-add a drive, then the entire drive 
will be re-written/synced.
> Or does forced re-adding risk damaging the data because the raid code
> can't tell what is out-of-date and what is current on the re-added drive?
There is no need to "force" re-adding a drive if there is still all the 
data in the array. The only reason you would force an array to assemble 
is in the case one drive has failed (totally dead/unusable, or failed a 
long time ago) and a second drive has failed with only a few bad 
sectors, or a timeout mismatch. Then you forget the oldest drive, force 
assemble with the good drives plus the recently failed drive, and then 
recover as much data as possible.
The other useful scenario is a small number of bad sectors on two 
drives, but not in the same location. You won't survive a full re-sync 
on either drive, but forcing assembly might allow you to read all the data.
> Basically, what I'm trying to get at, is that if there's one disk
> missing in a raid5, is a user better off just adding a new drive and
> rebuilding the array (risking a failure in another drive), or are they
> better off trying to add the failed drive back in, and then doing a
> --replace.
It will depend on why the drive failed in the first place. If it failed 
due to a timeout mismatch, or user error (pulled the drive by accident, 
etc and you have a bitmap enabled, then re-adding is the best option 
(because you will only re-sync a small portion of the drive. If you do 
not have a bitmap, and you suspect one or more of your drives are having 
problems / likely to have read failures during the re-sync (this is 
usually when people come to the list/wiki) then it could be helpful to 
force the assemble (ie, ignore the event count). This will allow you to 
get your data off the array, or at least get to a point of full 
redundancy, you could then either add a drive to move to RAID6, or 
replace each drive (one by one) to get rid of the unreliable drives.
> And I guess the same logic applies with raid6.
Again, usually you would only do this if you lost 3 drives on the RAID6, 
2 on RAID5.... Otherwise, you should re-build the drive in full (or 
suffer random data corruption). The bitmap is only useful after you 
temporarily lose one or more drives <= to the number of redundant drives 
(ie, this applies to RAID1 and RAID10 as well).

So, IMHO, in the general scenario, you should not force assemble if you 
want to be sure you recover all your data. It is something that is done 
to reduce data loss from 100% to some unknown value depending on the 
event count difference, but usually it is very small.

Generally, you should do a verify/repair on the array afterwards (even 
if the data is lost, at least they will be consistent about what it 
returns), and a fsck.

Don't consider the above as gospel, but it matches the various scenarios 
I've seen on this list....

Regards,
Adam
