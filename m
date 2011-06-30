From: NeilBrown <neilb@suse.de>
Subject: Re: MDADM RAID5 listing active drives as spares
Date: Thu, 30 Jun 2011 12:50:14 +1000
Message-ID: <20110630125014.604c2236@notabene.brown>
References: <S1753465Ab1F2Neh/20110629133437Z+882@vger.kernel.org>
	<50550841-1FDC-4143-82E7-5F897B8B6E21@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50550841-1FDC-4143-82E7-5F897B8B6E21@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ian Whitton <boyfromthedwarf9@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 29 Jun 2011 09:55:30 -0400 Ian Whitton <boyfromthedwarf9@gmail.com>
wrote:

> I have a mdadm RAID5 of 6 sata drives that was working fine until about a week ago when it was getting slow reads, but wrote fine.  After some looking around, and help on IRC, we figured it was the sata card I had of the drives on.  When I plugged the new card in, it was working, and rebuilding.  I woke up this morning and it seems something happened and now 2 drives are listed as spares.  I did start the raid with --assemble --force after putting the new card in.

Presumably the drive got an IO error and we removed from the array.

kernel logs?


> 
> This is a pastebin of mdadm --examine --scan and mdadm --examine /dev/sd[bcdefg]1
> http://pastebin.com/ZR2cB46Q--

<rant>
Why do people like pastebin so much??  Why don't you just paste the text you
want to share directly into the email??? It is not like it is big or
anything....
</rant>

NeilBrown



> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

