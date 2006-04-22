From: David Greaves <david@dgreaves.com>
Subject: Re: Problem with 5disk RAID5 array - two drives lost
Date: Sat, 22 Apr 2006 20:54:05 +0100
Message-ID: <444A89DD.2000803@dgreaves.com>
References: <A2F915E2-EC52-4EFE-86C2-547A71F8D788@writemem.com>	<62b0912f0604212054m40283fdbybdb6cd89e61dd153@mail.gmail.com> <17482.34615.908339.197028@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17482.34615.908339.197028@fisica.ufpr.br>
Sender: linux-raid-owner@vger.kernel.org
To: Carlos Carvalho <carlos@fisica.ufpr.br>
Cc: linux-raid@vger.kernel.org, tbostrom@writemem.com
List-Id: linux-raid.ids

Carlos Carvalho wrote:
> Molle Bestefich (molle.bestefich@gmail.com) wrote on 22 April 2006 05:54:
>  >Tim Bostrom wrote:
>  >> raid5: Disk failure on hdf1, disabling device.
>  >
>  >MD doesn't like to find errors when it's rebuilding.
>  >It will kick that disk off the array, which will cause MD to return
>  >crap (instead of stopping the array and removing the device - I
>  >wonder), again causing 'mount' etc. to fail.
>  >
>  >Quite unfortunate for you, since you have absolutely no redundancy
>  >with 4/5 drives, and you really can't afford to have the 4th disk
>  >kicked just because there's a bad block on it.
>
> Yes...
>
> As Molle says, you have a chance that it's a driver/cable problem.
> What you can also do is dd the disk to another one and try to rebuild
> the array with the new disk so that you won't get errors during the
> reconstruction. If you get errors during the copy you'll have to
> decide what to do with the bad blocks. Some people prefer to use
> ddrescue instead of dd; I've never tried it.
I've used ddrescue and would *highly* recommend it. Use the GNU version,
not the other one (dd_rescue?)

It handles errors very well indeed and has a good display to show what's
happening.

It seems faster than dd (possibly threaded so streams both drives rather
than read a drive, write a drive)

David
