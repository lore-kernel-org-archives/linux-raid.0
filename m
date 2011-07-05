From: "Tyler J. Wagner" <tyler@tolaris.com>
Subject: Re: advanced partition format, mdadm, and raw disks
Date: Tue, 05 Jul 2011 05:28:50 +0100
Message-ID: <1309840130.2865.5.camel@baal>
References: <1309796133.2766.63.camel@baal>
	 <20110705103030.401066f6@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110705103030.401066f6@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2011-07-05 at 10:30 +1000, NeilBrown wrote:
> No "super" is mentioned here so it must be using 0.90 metadata.

Ah. Damn that old Debian package.

I'm concerned that this means the filesystem isn't aligned to the 4K
sector, and is therefore less efficient. Is 0.90 metadata at the
beginning or end of the disk? Is it a multiple of 4K in size?

Regards,
Tyler

-- 
"I respect you too much to respect your ridiculous ideas."
   -- Johann Hari

