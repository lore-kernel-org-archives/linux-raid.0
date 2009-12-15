From: stuart-b-uk <stuart.buckell@googlemail.com>
Subject: RAID-5 Degraded, Seemed to have lost files? Please help!
Date: Tue, 15 Dec 2009 02:26:13 -0800 (PST)
Message-ID: <26792453.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello,

We have a RAID-5  4x 250GB SATA running on an Intel SATA Hardware Raid
controller.

Yesterday a drive failed, which was replaced, however we did not have
another matching drive, therefore it didn't like what it saw and wouldn't
rebuild.

Someone accessed files over HTTP and for some reason the filesystem went
into readonly mode.

The system is now degradding to 3 drives Raid-5, and is at 20% after 12
hours.

The problem we have is a critical folder exists but has nothing inside it,
except a few question marks when the directory is listed via bash.

My question is:-

1) Is it likely after the raid has gone from 750GB to 495GB that we will
ever see these files again?
2) Can you recommend any recovery software which might be able to get these
files back?
3) Has anyone experienced random loss of files from a rebuild of RAID-5
before?

I appreciate the importance of backing up, unfortunately, this is the only
folder in the system that wasn't set up in the backup routine properly, and
yes, Murphy struck again...

Thanks to anyone who can help,

Regards,

Stuart
-- 
View this message in context: http://old.nabble.com/RAID-5-Degraded%2C-Seemed-to-have-lost-files--Please-help%21-tp26792453p26792453.html
Sent from the linux-raid mailing list archive at Nabble.com.

