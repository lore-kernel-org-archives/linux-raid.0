From: "NeilBrown" <neilb@suse.de>
Subject: Re: Software, Raid 5, Different Size Drives.
Date: Tue, 18 Aug 2009 08:11:52 +1000 (EST)
Message-ID: <60c6680b56086d74292cd847ca212ea6.squirrel@neil.brown.name>
References: <25160.93380.qm@web51307.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <25160.93380.qm@web51307.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, August 18, 2009 12:07 am, Jon Hardcastle wrote:
> My setup is build on drives that have a partition on them, so the finer
> points over the pro's and con's of this are moot for me.. until i come to
> replace the array. Perhaps someone can tell me tho. If I do use a
> partition on the 1TB drive, and it is is x blocks big. If i add another
> 1TB drive that is x +/- 10 blocks in size. Will the array just use the
> size of the smaller and grow accordingly?

The effective size of the drive is rounded to the chunk size
which defaults to 64K.

If you try to add a drive or partition to an array and it does not
have enough space for the data plus metadata, then md will not
accept the drive.
If you add a drive or partition that has more space than is needed,
the extra will simple not be used.
If you eventually replace all drives with drives that have more space,
then every drive will have space on it that is unused.
You can, if you choose, then expand the array to use that extra space
with --grow --size=max.

I hope that answers your question.

NeilBrown

