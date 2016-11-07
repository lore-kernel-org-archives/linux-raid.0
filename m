From: Wols Lists <antlists@youngman.org.uk>
Subject: Re:
Date: Mon, 7 Nov 2016 16:50:56 +0000
Message-ID: <5820B0F0.2050306@youngman.org.uk>
References: <CAGELip+rb=Ztv2K8jPdn608Li_RakEq9Gp5Jyof9eC_bO5QMrQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGELip+rb=Ztv2K8jPdn608Li_RakEq9Gp5Jyof9eC_bO5QMrQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dennis Dataopslag <dennisdataopslag@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/11/16 21:00, Dennis Dataopslag wrote:
> Help wanted very much!

Quick response ...
> 
> My setup:
> Thecus N5550 NAS with 5 1TB drives installed.
> 
> MD0: RAID 5 config of 4 drives (SD[ABCD]2)
> MD10: RAID 1 config of all 5 drives (SD..1), system generated array
> MD50: RAID 1 config of 4 drives (SD[ABCD]3), system generated array
> 
> 1 drive (SDE) set as global hot spare.
> 
Bit late now, but you would probably have been better with raid-6.
> 
> What happened:
> This weekend I thought it might be a good idea to do a SMART test for
> the drives in my NAS.
> I started the test on 1 drive and after it ran for a while I started
> the other ones.
> While the test was running drive 3 failed. I got a message the RAID
> was degraded and started rebuilding. (My assumption is that at this
> moment the global hot spare will automatically be added to the array)
> 
> I stopped the SMART tests of all drives at this moment since it seemed
> logical to me the SMART test (or the outcomes) made the drive fail.
> In stopping the tests, drive 1 also failed!!
> I let it for a little but the admin interface kept telling me it was
> degraded, did not seem to take any actions to start rebuilding.

It can't - there's no spare drive to rebuild on, and there aren't enough
drives to build a working array.

> At this point I started googling and found I should remove and reseat
> the drives. This is also what I did but nothing seemd to happen.
> The turned up as new drives in the admin interface and I re-added them
> to the array, they were added as spares.
> Even after adding them the array didn't start rebuilding.
> I checked stat in mdadm and it told me clean FAILED opposed to the
> degraded in the admin interface.

Yup. You've only got two drives of a four-drive raid 5.

Where did you google? Did you read the linux raid wiki?

https://raid.wiki.kernel.org/index.php/Linux_Raid
> 
> I rebooted the NAS since it didn't seem to be doing anything I might interrupt.
> after rebooting it seemed as if the entire array had disappeared!!
> I started looking for options in MDADM and tried every "normal"option
> to rebuild the array (--assemble --scan for example)
> Unfortunately I cannot produce a complete list since I cannot find how
> to get it from the logging.
> 
> Finally I mdadm --create a new array with the original 4 drives with
> all the right settings. (Got them from 1 of the original volumes)

OUCH OUCH OUCH!

Are you sure you've got the right settings? A lot of "hidden" settings
have changed their values over the years. Do you know which mdadm was
used to create the array in the first place?

> The creation worked but after creation it doesn't seem to have a valid
> partition table. This is the point where I realized I probably fucked
> it up big-time and should call in the help squad!!!
> What I think went wrong is that I re-created an array with the
> original 4 drives from before the first failure but the hot-spare was
> already added?

Nope. You've probably used a newer version of mdadm. That's assuming the
array is still all the original drives. If some of them have been
replaced you've got a still messier problem.
> 
> The most important data from the array is saved in an offline backup
> luckily but I would very much like it if there is any way I could
> restore the data from the array.
> 
> Is there any way I could get it back online?

You're looking at a big forensic job. I've moved the relevant page to
the archaeology area - probably a bit too soon - but you need to read
the following page

https://raid.wiki.kernel.org/index.php/Reconstruction

Especially the bit about overlays. And wait for the experts to chime in
about how to do a hexdump and work out the values you need to pass to
mdadm to get the array back. It's a lot of work and you could be looking
at a week what with the delays as you wait for replies.

I think it's recoverable. Is it worth it?

Cheers,
Wol
