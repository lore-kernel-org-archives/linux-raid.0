From: John Hendrikx <hjohn@xs4all.nl>
Subject: Resync dropping drive with read-errors
Date: Tue, 16 Dec 2008 18:39:22 +0100
Message-ID: <4947E7CA.9000504@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, I'm writing to tell about an experience I recently had with my raid 
5 array.  No data was lost, but the way I had to recover my data seemed 
a bit overly complicated.

Here's what happened:

1) 6 drive raid 5 array
2) one drive failed
3) I add a spare drive to the array, resync process starts
4) Resync process bugs out at 90% orso because one of the other drives 
had developed a read-error (since the array is big, such things are 
easily unnoticed).
5) Raid array drops out the drive with read-errors and is left in a 
broken state, the new drive was not fully resynced yet...

How I recovered it:

6) Re-add the drive with read-errors (need to stop array, re-assemble it 
with --force option, can't do it directly)
7) Copy everything on the array to some other array
8) When it bugged out again, I noted the file that caused problems, 
repeated step 6 and copied all the rest.

This seems to be a bit of a round-about way to do it.  I would much have 
preferred if I could force the resync process to continue despite some 
block being unreadable (and just log which blocks were causing problems 
if forced in such a way).  I could then proceed to figure out which 
files were affected, and replace the drive with read errors as well.

Perhaps I missed something... I was considering just using dd to 
overwrite the block causing problems (and hopefully get it to be 
remapped), but I'm not 100% sure how LBA block numbers reported by 
S.M.A.R.T. would related to block numbers dd uses.

If I could have handled it better, let me know :)

