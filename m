From: Bruce Lowekamp <brucelowekamp@gmail.com>
Subject: Re: Bad blocks are killing us!
Date: Thu, 18 Nov 2004 11:03:12 -0500
Message-ID: <e9132f820411180803472424b2@mail.gmail.com>
References: <e9132f82041117135873807c77@mail.gmail.com>
	 <200411180147.iAI1l5N02116@www.watkins-home.com>
Reply-To: Bruce Lowekamp <brucelowekamp@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200411180147.iAI1l5N02116@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy Watkins <guy@watkins-home.com>
Cc: Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 17 Nov 2004 20:46:59 -0500, Guy Watkins <guy@watkins-home.com> wrote:
> 2 things about your comments:
> 
> 1.
>         You said:
>         "no one should be using md in an RT-critical application"
> 
> I am sorry to hear that!  What do recommend?  Windows 2000 maybe?

Very funny.  I would only use hardware raid if I had a safety-related
RT system.  (as much as I love md, and I do keep all of my project
data on a very large md raid5.)

> 
> 2.
>         You said:
>         "but the md-level
> approach might be better.  But I'm not sure I see the point of
> it---unless you have raid 6 with multiple parity blocks, if a disk
> actually has the wrong information recorded on it I don't think you
> can detect which drive is bad, just that one of them is."
> 
> If there is a parity block that does not match the data, true you do not
> know which device has the wrong data.  However, if you do not "correct" the
> parity, when a device fails, it will be constructed differently than it was
> before it failed.  This will just cause more corrupt data.  The parity must
> be made consistent with whatever data is on the data blocks to prevent this
> corrosion of data.  With RAID6 it should be possible to determine which
> block is wrong.  It would be a pain in the @$$, but I think it would be
> doable.  I will explain my theory if someone asks.

The question with a raid5 parity error is, how do you correct it? 
You're right that if a disk fails, the data changes, and that is bad. 
But, IMHO, I don't want the raid subsystem to guess what the correct
data is if it detects that there is that sort of an error.  Flag the
error and take the array offline.  That system needs some sort of
diagnosis to determine if data has actually been lost.  If it happened
with my /home partition, I would probably verify the data with
backups.  If it was a different partition, I might just run fsck on
it.  But I think the user needs to be involved if data loss was
detected.

I don't know enough about how the md raid6 implementation works, but a
naive approach of removing each drive and seeing when you find one
that disagrees with the parity of the n-1 other drives seems like it
would work.  Don't think I would want to code it.  Still, at least
then you can correct the data and notify the user level.  But no data
was lost, so continue as normal.  Of course, personally, if md told me
a drive had developed an undetected bit error, I would remove the
drive immediately for more diagnostics and let it switch to a spare,
and would probably rather that be the default behavior if there's a
hot spare.  But I'm a bit paranoid...

Bruce


-- 
Bruce Lowekamp  (lowekamp@cs.wm.edu)
Computer Science Dept, College of William and Mary
