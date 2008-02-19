From: "Steve Fairbairn" <steve@fairbairn-family.com>
Subject: RE: How many drives are bad?
Date: Tue, 19 Feb 2008 19:44:45 -0000
Message-ID: <1bbd01c8732f$e115f970$0603a8c0@meanmachine>
References: <6b3a7f010802191125q3905d1abw2372ed5c7ab1eaf0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="windows-1250"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6b3a7f010802191125q3905d1abw2372ed5c7ab1eaf0@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Norman Elton' <normelton@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> 
> The box presents 48 drives, split across 6 SATA controllers. 
> So disks sda-sdh are on one controller, etc. In our 
> configuration, I run a RAID5 MD array for each controller, 
> then run LVM on top of these to form one large VolGroup.
> 

I might be missing something here, and I realise you'd lose 8 drives to
redundancy rather than 6, but wouldn't it have been better to have 8
arrays of 6 drives, each array using a single drive from each
controller?  That way a single controller failure (assuming no other HD
failures) wouldn't actually take any array down?  I do realise that 2
controller failures at the same time would lose everything.

Steve.

No virus found in this outgoing message.
Checked by AVG Free Edition. 
Version: 7.5.516 / Virus Database: 269.20.7/1286 - Release Date:
18/02/2008 18:49
 

