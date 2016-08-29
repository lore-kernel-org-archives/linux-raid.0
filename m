From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: Raid settings
Date: Mon, 29 Aug 2016 14:18:52 +0800
Message-ID: <e1718332-9fb7-a0f5-53d7-8dc5776c1c69@fnarfbargle.com>
References: <CAPpdf5_T=JjjUw2H5pAShmj4V6b5U8aALxDsiZvjyTUYy58DmQ@mail.gmail.com>
 <57C35ED0.2030107@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57C35ED0.2030107@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 29/08/16 05:59, Wols Lists wrote:

> For my home system I've got 2 x 3TB in a raid1 config. I had intended to
> add a 3rd drive and go raid5, but with two Barracudas I'd be an idiot
> :-( If I want to go that route, I need three new proper raid drives :-(
> I want maximum disk capacity with some redundancy, so raid 5 or 6 makes
> most sense for me.
>

I'll get roasted for suggesting this, but for a home RAID where 
potential response times in cases of errors are not an issue those 
Barracudas will be fine. Just make sure you set the appropriate 
timeouts. It's not like the drives are going to explode in a ball of 
flames because they don't support ERC, they just won't play nice with 
the default linux stack timeouts.

Sure, if you are buying new drives spend the extra 20 bucks and get 
drives that do support ERC, but if what you have works then just keep on 
keeping on. Add another drive, stretch it out to RAID5 and be happy.

I don't do RAID5 anymore, but for 3 disks with the right configuration 
it's not awful.

I have a couple of RAID10 here and a couple of RAID6. The RAID10 is an 
interesting case, because it'll survive a double drive failure some of 
the time. If the wrong pair fails though it's toast, whereas a RAID6 
will survive a double drive failure *all* of the time.

I like your "most suitable for the circumstances" quote though.

I saw some pretty interesting configurations on Sun X4500's a few years 
ago. 48 drives in varying configurations depending entirely on the 
projected workload. No right tool for every job.

