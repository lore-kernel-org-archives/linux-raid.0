From: =?ISO-8859-2?Q?Micha=B3_Przy=B3uski?= <mikylie@gmail.com>
Subject: Re: Software, Raid 5, Different Size Drives.
Date: Mon, 17 Aug 2009 16:20:21 +0200
Message-ID: <6c4602af0908170720s237ad8aau46f94b92a08d496d@mail.gmail.com>
References: <47af6defcf34329212cd18ef65edad38.squirrel@neil.brown.name>
	 <25160.93380.qm@web51307.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <25160.93380.qm@web51307.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@ehardcastle.com
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

2009/8/17 Jon Hardcastle <jd_hardcastle@yahoo.com>:
> Any idea where i find out this 'industry standard'?
>
> My setup is build on drives that have a partition on them, so the finer points over the pro's and con's of this are moot for me.. until i come to replace the array. Perhaps someone can tell me tho. If I do use a partition on the 1TB drive, and it is is x blocks big. If i add another 1TB drive that is x +/- 10 blocks in size. Will the array just use the size of the smaller and grow accordingly?

You might want to check out that linux-raid thread,
http://www.issociate.de/board/post/497059/Adding_a_smaller_drive.html
. It seems to be one of IDEMA standards. I cannot say I've seen it
myself, but the list seems to be pretty confident about it. And, it
appears that standard defines *exact* block count. It would be
pointless if it was just a minimum, as you might've built an array
with "more than minimum" drives, and then couldn't replace them with
drives with exact block count.

On top of that, my personal opinion is that having a partition doesn't
change anything in that matter. You could still, theoretically
assuming there's no IDEMA standard, find a smaller drive, and make a
partition that is smaller than partitions on other drives.

Cheers,
Mike
