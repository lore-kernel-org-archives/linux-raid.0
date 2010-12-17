From: Neil Brown <neilb@suse.de>
Subject: Re: integrity verification on raid-5?
Date: Sat, 18 Dec 2010 08:17:45 +1100
Message-ID: <20101218081745.63b05bc2@notabene.brown>
References: <4D0BD140.6040205@feystorm.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D0BD140.6040205@feystorm.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Patrick H." <linux-raid@feystorm.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 17 Dec 2010 14:08:16 -0700 "Patrick H." <linux-raid@feystorm.net>
wrote:

> Is there a way to do integrity verification on a raid-5 array? I'm 
> working on building a storage system on SSDs under raid-5 and want to be 
> able to perform periodic integrity checks. Basically just check the 
> drives to make sure that they match what the parity drive has.
> After a bit of googling I saw other people wanting the same thing but 
> nobody with any result. I dont see why this cant be done, but is there 
> any tool to do so?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

% man 4 md

search for 'check'.

NeilBrown
