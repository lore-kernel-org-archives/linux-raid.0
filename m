From: "Wilson, Jonathan" <piercing_male@hotmail.com>
Subject: Re: moving arrays from MBR part table install to GPT? Possible?
Date: Mon, 17 Aug 2015 16:50:15 +0100
Message-ID: <BLU437-SMTP2394605D5BD58011CF86C898790@phx.gbl>
References: <55D02E2E.1080909@suddenlinkmail.com>
	 <55D081C3.4090604@youngman.org.uk> <55D17EF7.8000203@suddenlinkmail.com>
	 <55D1F07A.7090709@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55D1F07A.7090709@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: "David C. Rankin" <drankinatty@suddenlinkmail.com>, mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 2015-08-17 at 15:32 +0100, Wols Lists wrote:
> On 17/08/15 07:28, David C. Rankin wrote:
> > On 08/16/2015 07:27 AM, Wols Lists wrote:
> >> If you want to add new drives, you can use GPT on them, as I say, if
> >> they're large disks, you'll need to use GPT.
> >>
> >> Sounds like it's a small system, a home system? If you get new drives,
> >> make sure they're proper raid drives, like WD Red. I've got Seagate
> >> Barracudas, which was a mistake ...
> > 
> > Thank you for your response. It is my office server, but it runs on 2 1T
> > drives (Carvair Black) Have had good experiences with them. I toss at
> > least 1 barracuda in the trash every 3-4 months.
> 
> Well, my experience with Barracudas has been good - they were my
> preferred choice of drive ...
> 
> You saying Black rang alarm bells for me, and I've just looked on my
> favourite sales site - it says they are DESKTOP drives!
> 
> YOU NEED TO CHECK THEM OUT WITH SMARTCTL!
> 
> Check if they support ERC etc. The Barracudas I know don't, the Reds
> various people have said they do. If the blacks don't support it, then
> they'll let you down when you need it. You really don't want to go raid
> 5 or 6 with drives that don't support it. I want to go raid 5, which is
> why I'm gutted to discover I'll have to replace my Barracudas. imho
> they're decent serviceable drives ...

Thats not strictly true....

With a non TLER drive if a problem is found the drive might take a long
time to fix them internally and the device layer time out might be
exceeded.

With TLER the drive will always respond within, usually, 7 seconds.

I have the following embedded in a bash script:
> for x in /sys/block/sd[a-z] ; do echo 360 > $x/device/timeout ; echo -n "$x/device/timeout : " ; cat $x/device/timeout ; done
which is "/sys/block/sdX/device/timeout"

Now if the drive is TLER it will still respond in 7 seconds (either with
data, or an error - no change there), but if I should have any non-TLER
drives the device layer will now wait 360 seconds before timing out. (I
know, a long time which in most cases would cause frozen I/O, seemingly
hung... but hey, who knows the drive might eventually fix its self!)

This time out is just as true for non-raid as raid... if a non raid disk
takes longer to respond than the time out, you potentially lose the
drive... or you've just killed the last I/O commands to it and done a
hard reset. (That said, I think its up to the file system to then deal
with a timed out disk? should mdadm sit on top of the disk its
processing is "disk timed out, kick it".)




> > 
> > I'll stick with MBR and see how it goes. In that case I'll just boot the
> > install media and assemble the arrays and see what I end up with.
> > 
> > 
> Yup. No real point going gpt until you get to 3 and 4TB drives. Once you
> can get linux running, it shouldn't care what sort of drives you have,
> but if you read the gentoo wiki pages about installing on raid
> (disclaimer, I wrote a decent chunk of it), you'll see what a pig it can
> be getting as far as loading linux ...
> 
> Cheers,
> Wol
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


