From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: replacing drives
Date: Fri, 26 Apr 2013 08:42:32 -0700
Message-ID: <8sjq4axofq.ln2@goaway.wombat.san-francisco.ca.us>
References: <517A8EB5.8080100@supsi.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2013-04-26, Roberto Nunnari <roberto.nunnari@supsi.ch> wrote:
>
> I'd like to replace two hd in raid1 with larger ones.
>
> I could just add the new drives in raid1 and mount it on /opt after a 
> dump/restore, but I'd prefer to just have to drives instead of four.. 
> less noise and less power consumption and noise.
>
> The question is: what whould be the best way to go?

I've never tried it, but mdadm supports growing arrays.  If you replace
each drive in your RAID1 and do a rebuild, when the second rebuild is
complete, you can use the --grow -z max option to tell md to resize the
array to use the new space.  Then you will need to resize the filesystem
using FS tools like resize2fs or xfs_growfs.

--keith

-- 
kkeller@wombat.san-francisco.ca.us


