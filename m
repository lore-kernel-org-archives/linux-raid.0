From: Brad Campbell <brad@wasp.net.au>
Subject: Re: Two Drive Failure on RAID-5
Date: Tue, 20 May 2008 23:28:22 +0400
Message-ID: <48332656.1030401@wasp.net.au>
References: <loom.20080519T224713-779@post.gmane.org> <48327FC2.1010901@dgreaves.com> <loom.20080520T145950-804@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20080520T145950-804@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Cry <cry_regarder@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Cry wrote:
> 
> Supermicro SUPERMICRO CSE-M35T-1 Hot-Swapable SATA HDD Enclosure
> 
> http://www.supermicro.com/products/accessories/mobilerack/CSE-M35T-1.cfm
> 
> and building a raid-6 array.  I'll convert the surviving drives into a backup
> for the primary array.  Any feedback on the above?  Is there a suggestion on an
> inexpensive controller to give more SATA ports that is very software raid
> compatible?
> 

I've got 5 of those enclosures with Maxtor Maxline-II drives in them. I've had them all running 
between 3 & 4 years now and I've been *extremely* happy with the enclosures. The whole lot are 
running on 7 Promise SATA150TX4 cards. So I'd certainly be happy with the enclosures, however I tend 
to agree with what David said below about going for the higher grade drives. I paid a bit extra for 
the Maxline-II drives over the desktop grade disks, and I've got 27 of them with about 30,000 hours 
on them now. One early life failure (in the 1st 5 hours) and one recently replaced as it was growing 
defects.. but the 26 remaining drives are solid.

Oh, 15 drives are in a RAID-6 and 10 are in a RAID-5. I plan to replace the 10 drive RAID-5 with 10 
1TB drives in a RAID-6 in the not to distant future. I did have a dual drive failure on the RAID-6 
(not actually drive related, but a software glitch) and having the RAID-6 saved the data nicely.


Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
