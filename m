From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Linear RAID Failure
Date: Tue, 4 May 2004 12:15:04 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16534.64680.849985.44451@cse.unsw.edu.au>
References: <40901AF9.90406@uiuc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Sharif Islam on Wednesday April 28
To: Sharif Islam <mislam@uiuc.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday April 28, mislam@uiuc.edu wrote:
> 
> Error reading block 175767553 (Attempt to read block from filesystem 
> resulted in short read) while reading inode and block bitmaps.  Ignore 
> error? yes
...
> 
> What should I do at this point?
> 
> I have the data backed up from yesterday. Should I replace the hdk and 
> hdl? Can I just do a remove from the linear raid and add the new disks? 
> Or I need to recreate the array.

It certainly appears that hdk and hdl are bad.  I suggest replacing
them.
You cannot just remove drives and add others.  That only works for
arrays that have redundancy, such as raid1, raid5, or raid6.
Linear is just like a single driver, only bigger.  If it fails you
have to restore from backups.

NeilBrown
