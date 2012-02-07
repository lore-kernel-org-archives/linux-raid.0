From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: using dd (or dd_rescue) to salvage array
Date: Mon, 06 Feb 2012 19:44:19 -0800
Message-ID: <j9j609x9a5.ln2@goaway.wombat.san-francisco.ca.us>
References: <8eekv8xpcn.ln2@goaway.wombat.san-francisco.ca.us>
 <kesmv8xc66.ln2@goaway.wombat.san-francisco.ca.us>
 <0cdtv8xv8f.ln2@goaway.wombat.san-francisco.ca.us>
 <4F2D7280.8020500@stud.tu-ilmenau.de>
 <8q0309x4kf.ln2@goaway.wombat.san-francisco.ca.us>
 <4F304822.8000102@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2012-02-06, Stefan *St0fF* Huebner <st0ff@gmx.net> wrote:
>
>  From the logical point of view those lost 8k would create bad data - 
> i.e. a filesystem problem OR simply corrupted data.  That depends on 
> which blocks exactly are bad.  If you were using lvm it could even be 
> worse, like broken metadata.

I am using LVM, so I'll just have to hope for the best.  I haven't yet
done an xfs_repair, but I will do that soon.  I just made my volume
active, and vgchange didn't complain, so I'm guessing that's a good
sign.

> It would be good if those 8k were "in a row" - that way at max 3 
> fs-blocks (when using 4k fs-blocksize) would be corrupted.

It was--it looks like it was really just that one spot on the drive.  So
I am hopeful that any errors that are a result of the lost 8k will be
reparable by xfs_repair.

--keith


-- 
kkeller@wombat.san-francisco.ca.us


