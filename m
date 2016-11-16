From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: recovering failed raid5
Date: Wed, 16 Nov 2016 15:35:31 +0000
Message-ID: <582C7CC3.40901@youngman.org.uk>
References: <CAM97BgQLPUN=t7VKHaVG-=SrJmS_tvaxGDbo3yqMwHm8B-do_Q@mail.gmail.com>
 <20161027160400.GA21042@metamorpher.de>
 <715b259f-1e56-9606-edc4-3e5c4d57744b@shenkin.org>
 <20161028133626.GA27462@cthulhu.home.robinhill.me.uk>
 <194ae464-2d19-cefd-055f-6f4a33676ab2@shenkin.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <194ae464-2d19-cefd-055f-6f4a33676ab2@shenkin.org>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Shenkin <al@shenkin.org>, linux-raid@vger.kernel.org, rm@romanrm.net, robin@robinhill.me.uk
List-Id: linux-raid.ids

On 16/11/16 09:04, Alexander Shenkin wrote:
> Hello all,
> 
> As a quick reminder, my sdb failed in a 4-disk RAID5, and then sdc
> failed when trying to replace sdb.  I'm now trying to recover sdc with
> ddrescue.
> 
> After much back and forth, I've finally got ddrescue running to
> replicate my apparently-faulty sdc.  I'm ddrescue'ing from a seagate 3TB
> to a toshiba 3TB drive, and I'm getting a 'No space left on device
> error'.  Any thoughts?
> 
> One further question: should I also try to ddrescue my original failed
> sdb in the hopes that anything lost on sdc would be covered by the
> recovered sdb?

Depends how badly out of sync the event counts are. However, I note that
your ddrescue copy appeared to run without any errors (apart from
falling off the end of the drive :-) ?

In which case, you haven't lost anything on sdc. Which is why the wiki
says don't mount your array writeable while you're trying to recover it
- you're not going to muck up your data and have user-space provoke
further errors.

If the array barfs while it's rebuilding, it's hopefully just a
transient, and do another assemble with --force to get it back again.

Once you've got the array properly back up again :-

1) make sure that the timeout script is run EVERY BOOT to fix the kernel
defaults for your remaining barracudas.

2) make sure smarts are enabled EVERY BOOT because barracudas forget
their settings on power-off.

3) You've now got a spare drive. If a smart self-check comes back pretty
clean and it looks like a transient problem not a dud drive, then put it
back in and convert the array to raid 6.

4) MONITOR MONITOR MONITOR

You've seen the comments elsewhere about the 3TB barracudas? Barracudas
in general aren't bad drives, but the 3TB model has a reputation for
dying early and quickly. You can then plan to replace the drives at your
leisure, knowing that provided you catch any failure, you've still got
redundancy with one dead drive in a raid-6. Even better, get another
Toshiba and go raid-6+spare. And don't say you haven't got enough sata
ports - an add-in card is about £20 :-)

Cheers,
Wol
