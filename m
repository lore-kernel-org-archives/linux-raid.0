From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: Recovery of failed RAID 6 and LVM
Date: Fri, 30 Sep 2011 15:47:06 -0600
Message-ID: <201109301547.06930.thomas@fjellstrom.ca>
References: <4E7EDE58.3000804@yazzy.org> <20110928091335.1df35f8e@notabene.brown> <4E862024.9090306@yazzy.org>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E862024.9090306@yazzy.org>
Sender: linux-raid-owner@vger.kernel.org
To: lists@yazzy.org
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On September 30, 2011, Marcin M. Jessa wrote:
> On 9/28/11 1:13 AM, NeilBrown wrote:
> > On Tue, 27 Sep 2011 21:12:58 +0200 "Marcin M. Jessa"<lists@yazzy.org>  
wrote:
> >> On 9/26/11 11:31 AM, NeilBrown wrote:
> >>> On Mon, 26 Sep 2011 11:05:38 +0200 "Marcin M. Jessa"<lists@yazzy.org>   
wrote:
> >>>> On 9/26/11 12:18 AM, NeilBrown wrote:
> >>>>> Do you remember what filesystem you had on 'storage'?  Was it ext3 or
> >>>>> ext4 or xfs or something else?
> >>>> 
> >>>> You're giving me some hope here and then silence :)
> >>>> Why did you ask about the file system? Should I run fsck on the LV ?
> >>> 
> >>> You already did run fsck on the LV.  It basically said that it didn't
> >>> recognise the filesystem at all.
> >>> I asked in case maybe it was XFS in which case a different tool would
> >>> be required.
> >> 
> >> Looks like I didn't remember correctly. I ran testdisk and it reported
> >> the file system to be XFS. What would you suggest now Neil?
> > 
> > Presumably
> > 
> >     xfs_check /dev/fridge/storage
> > 
> > and then maybe
> > 
> >     xfs_repair /dev/fridge/storage
> > 
> > but I have no experience with XFS - I'm just reading man pages.
> 
> That didn't work so I decided to give photorec a spin and so far it
> could find and recover lots of files [1].
> Why the heck is photorec able to do so but the normal file system fixing
> tools are just useless?


The file system metadata was trashed, and photorec looks at the data only, 
looking for file headers and trying to pull out contiguous files.

> 
> [1]:
> Disk /dev/dm-0 - 5368 GB / 5000 GiB (RO)
> Partition Start End Size in sectors
> No partition 0 10485759999 10485760000 [Whole disk]
> 
> 
> Pass 2 - Reading sector 1506591634/10485760000, 843 files found
> Elapsed time 10h16m59s - Estimated time for achievement 61h17m10
> txt: 445 recovered
> exe: 198 recovered
> mpg: 62 recovered
> swf: 33 recovered
> tx?: 33 recovered
> gif: 25 recovered
> gpg: 19 recovered
> bmp: 5 recovered
> gz: 4 recovered
> riff: 4 recovered
> others: 15 recovered


-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
