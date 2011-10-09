From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: Thought about delayed sync
Date: Sun, 9 Oct 2011 09:44:54 -0400
Message-ID: <20111009134454.GA2831@animx.eu.org>
References: <20111008180309.GA14979@animx.eu.org>
 <201110081600.44112.thomas@fjellstrom.ca>
 <20111009120407.GB25344@animx.eu.org>
 <201110090634.57750.thomas@fjellstrom.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201110090634.57750.thomas@fjellstrom.ca>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thomas Fjellstrom wrote:
> On October 9, 2011, Wakko Warner wrote:
> > On another note, I used this feature to clean the dust out of my disk array
> > in another system.  Fail a drive, read the array to verify which drive I
> > physically failed, remove it, clean the dust off, add it back, wait for
> > resync to complete and then do another disk.  Resync on that was quick for
> > the 750gb member.  Without a bitmap, resync time on that system is 3 hours.
> 
> Try it on a 7 1TB drive raid5. fun times. I imagine its much worse with 2, 3 
> or 4 TB drives. (though not many people have a bunch of internal 4TB drives I 
> imagine).

Actually, I have, well sort of.  I have an 8 drive raid6 (2tb disks).  It
takes about the same time as a 4 drive raid5 with the same disks.

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
