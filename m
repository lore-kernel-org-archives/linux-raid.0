From: Janek Kozicki <janek_listy@wp.pl>
Subject: telling mdadm to use spare drive.
Date: Sun, 4 Nov 2007 17:05:02 +0100
Message-ID: <20071104170502.6db7fcb1@absurd>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I finished copying all data from old disc hdc to my shiny new
RAID5 array (/dev/hda3 /dev/sda3 missing). Next step is to create a
partition on hdc and add it to the array. And so I did this:

# mdadm --add /dev/md1 /dev/hdc3

But then I had a problem - the /dev/hdc3 was a spare, it didn't
resync automatically:

# mdadm -D /dev/md1
[....]
    Number   Major   Minor   RaidDevice State
       0       3        3        0      active sync   /dev/hda3
       1       8        3        1      active sync   /dev/sda3
       2       0        0        2      removed

       3      22        3        -      spare   /dev/hdc3


I wanted to tell mdadm to use the spare device, and I wasn't sure how
to do this, so I tried following:

# mdadm --stop /dev/md1
# mdadm --assemble --update=resync /dev/md1 /dev/hda3 /dev/sda3 /dev/hdc3

Now, 'mdadm -D /dev/md1' says:
[...]
    Number   Major   Minor   RaidDevice State
       0       3        3        0      active sync   /dev/hda3
       1       8        3        1      active sync   /dev/sda3
       3      22        3        2      spare rebuilding   /dev/hdc3


I'm writing here just because I want to be sure that I added this new
device correctly, I don't want to make any stupid mistake here...

# cat /proc/mdstat

md1 : active raid5 hda3[0] hdc3[3] sda3[1]
      966807296 blocks super 1.1 level 5, 128k chunk, algorithm 2 [3/2] [UU_]
      [=>...................]  recovery =  6.2% (30068096/483403648) finish=254.9min speed=29639K/sec
      bitmap: 8/8 pages [32KB], 32768KB chunk

Was there a better way to do this, is it OK?

-- 
Janek Kozicki                                                         |
