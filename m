From: Neil Brown <neilb@suse.de>
Subject: Re: Cheap Clustered FS
Date: Tue, 11 Apr 2006 14:28:06 +1000
Message-ID: <17467.12374.986505.940379@cse.unsw.edu.au>
References: <589a24260604101424o4bbb193egcd21d639ec040322@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jon Miller on Monday April 10
Sender: linux-raid-owner@vger.kernel.org
To: Jon Miller <jonebird@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday April 10, jonebird@gmail.com wrote:
> I have two machines which have redundant paths to the same shared scsi
> disk. I've had no problem creating the multipath'ed device md0 to
> handle my redundant pathing. But now I'd like to use a simple FS, such
> as ext3, mounted rw on the first machine and ro on the second machine.
> The idea is that the second machine, mounting the FS ro, would be able
> to read any new data being written in the FS.
> Everything has been rather easy to setup, but anything being created
> on the FS is not seen on the other machine with the FS mounted ro.
> That is, I can create a file on the first machine and I never see that
> file from the second machine until I remount the FS.
> At this point, I am actually trying to avoid GFS, OCFS, veritas
> clustered FS options as well as NFS. If there was a simple hack, that
> I'm missing, to enable the updates to the FS to be seen in realtime,
> then I'd actually prefer that method.
> Any help would be appreciated.


Sorry, but it just ain't that easy.
You need some degree of synchronisation even when only one side is
writing. 
Both sides keep data in cache, and that needs to be managed some how.

NeilBrown
