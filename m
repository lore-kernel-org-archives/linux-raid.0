From: M K <maheshext3@yahoo.com>
Subject: Re: Raid 5: Lossless music archive server recommendations
Date: Tue, 1 Jun 2004 18:24:59 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040602012500.12304.qmail@web61004.mail.yahoo.com>
References: <002501c44837$64699a20$0201a8c0@windows>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <002501c44837$64699a20$0201a8c0@windows>
To: TJ Harrell <systemloc@earthlink.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

you can setup mdadm in the monitor mode and configure
it to send email alerts.

--- TJ Harrell <systemloc@earthlink.net> wrote:
> I'm aiming at a very similar setup as what you're
> talking about. Whether or
> not you put your root on the raid is up to you.
> Personally, I don't, and I
> have my raid mounted as /home. Anyways, your mobo
> should support two drives,
> and each additional controller should support two
> drives. Thus, with one
> addon controller, you can have 4 drives. With 200GB
> drives, that's 600GB of
> space doing RAID 5. In my experience, adding more
> drives to an array is
> extremely easy, but it is dangerous. It is possible
> to lose data even if you
> do follow the steps verbatim, although I've done it
> 3-4 times myself with no
> trouble. First, you must use raidreconf to grow the
> array onto the new disk,
> then you must use resize2fs to expand the filesystem
> to fill the array.
> Backing up during this process is highly
> recommended!
> 
> I personally don't use a hot spare, and I haven't
> had any trouble with drive
> failure since I got rid of all my IBM drives. I did
> have a run in with a WD
> drive that needed a firmware update else it dropped
> out of the array
> periodically, though. A hot spare is something to
> take into consideration.
> Also, you might look into some sort of monitoring
> script. If you don't
> monitor the array, you could lose one disk and go
> months without ever
> knowing. Something that would email you would be
> ideal.
> 
> 
> -
> To unsubscribe from this list: send the line
> "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at 
http://vger.kernel.org/majordomo-info.html



	
		
__________________________________
Do you Yahoo!?
Friends.  Fun.  Try the all-new Yahoo! Messenger.
http://messenger.yahoo.com/ 
