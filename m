From: "Caleb Crome" <linux-raid@crome.org>
Subject: Adding a mirror to a RAID1 Device
Date: Mon, 24 Nov 2003 22:19:44 -0800 (PST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <63168.209.233.26.53.1069741184.squirrel@sampson.crome.org>
References: <S262074AbTKYGHX/20031125060723Z+10693@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <S262074AbTKYGHX/20031125060723Z+10693@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello all, I've got a peculiar problem.  I added some new disk space to my
system (Linux 2.4.19, Mandrake), and created a RAID1 drive /dev/md0 with
only 1 active mirror because I didn't have enough space (yet) to put
everything on my new raid drive.  I had the intention of then addeding
another disk to the raid setup later so that it would just
auto-reconsctruct and be ready to go.

However, when I do raidhotadd, I doesn't seem to reconsctruct.


So, my /proc/mdstat looks like this:

Personalities : [raid1]
read_ahead 1024 sectors
md0 : active raid1 ide/host0/bus1/target0/lun0/part3[0]
      81920064 blocks [1/1] [U]


When I
   raidhotadd /dev/md0  /dev/ide/host0/bus0/target0/lun0/part3

I get the following /proc/mdstat:

Personalities : [raid1]
read_ahead 1024 sectors
md0 : active raid1 ide/host0/bus1/target0/lun0/part3[0] \ <contd.>
                   ide/host0/bus0/target0/lun0/part3[0]
      81920064 blocks [1/1] [U]

unused devices: <none>


It doesn't reconsctruct the drive from bus0 as I expected it to.  What do
I do to convince the kernel to do the reconstruction?

Thanks,
-Caleb





