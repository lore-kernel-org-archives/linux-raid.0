From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: recovering failed raid5
Date: Mon, 31 Oct 2016 16:28:55 +0000
Message-ID: <58177147.7020602@youngman.org.uk>
References: <CAM97BgQLPUN=t7VKHaVG-=SrJmS_tvaxGDbo3yqMwHm8B-do_Q@mail.gmail.com>
 <20161027160400.GA21042@metamorpher.de>
 <715b259f-1e56-9606-edc4-3e5c4d57744b@shenkin.org>
 <20161028133626.GA27462@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161028133626.GA27462@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Shenkin <al@shenkin.org>, linux-raid@vger.kernel.org, Andreas Klauer <Andreas.Klauer@metamorpher.de>, rm@romanrm.net, robin@robinhill.me.uk
List-Id: linux-raid.ids

On 28/10/16 14:36, Robin Hill wrote:
> Unfortunately, reconstruction of the array depends on this data being
> readable, so the fact the drive isn't toast doesn't necessarily help.
> I'd suggest replicating (using ddrescue) that drive to the new one (when
> it arrives) as a first step. It's possible ddrescue will manage to read
> the data (it'll make several attempts, so can sometimes read data that
> fails initially), otherwise you'll end up with some missing data
> (possibly corrupt files, possibly corrupt filesystem metadata, possibly
> just a bit of extra noise in an audio/video file). Once that's done, you
> can do a proper check on sdc (e.g. a badblocks read/write test), which
> will either lead to sector actually being reallocated, or to clearing
> the pending reallocations. Unless you get a lot more reallocated sectors
> than are currently pending, you can put the drive back into use if you
> like (bearing in mind the reputation of these drives and weighing the
> replacement cost against the value of your data).

Read the linux raid wiki - the page about programming projects at the
bottom.

If ddrescue fails to do a complete, okay copy, then maybe you or someone
near you has the smarts to do that little project. Then you can stick
your newly copied drive back knowing that the raid at least has a chance
of reconstructing your data without error.

Cheers,
Wol
