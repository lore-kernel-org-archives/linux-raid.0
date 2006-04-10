From: "Jon Miller" <jonebird@gmail.com>
Subject: Cheap Clustered FS
Date: Mon, 10 Apr 2006 17:24:34 -0400
Message-ID: <589a24260604101424o4bbb193egcd21d639ec040322@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have two machines which have redundant paths to the same shared scsi
disk. I've had no problem creating the multipath'ed device md0 to
handle my redundant pathing. But now I'd like to use a simple FS, such
as ext3, mounted rw on the first machine and ro on the second machine.
The idea is that the second machine, mounting the FS ro, would be able
to read any new data being written in the FS.
Everything has been rather easy to setup, but anything being created
on the FS is not seen on the other machine with the FS mounted ro.
That is, I can create a file on the first machine and I never see that
file from the second machine until I remount the FS.
At this point, I am actually trying to avoid GFS, OCFS, veritas
clustered FS options as well as NFS. If there was a simple hack, that
I'm missing, to enable the updates to the FS to be seen in realtime,
then I'd actually prefer that method.
Any help would be appreciated.
--
Thanks,
Jon Miller
