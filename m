From: Asif Iqbal <vadud3@gmail.com>
Subject: remove one md and add its disk to the other md
Date: Wed, 8 Feb 2012 17:21:39 -0500
Message-ID: <CAOHBbgWzHUUMeQSeXDGJv1+Na=8oM3iB1VN7mMUvhHqgLaU1dw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All

I have two raid10s

md3 : active raid10 sdh2[3] sdf2[1] sdg2[2] sde2[0]
      143371392 blocks 64K chunks 2 near-copies [4/4] [UUUU]

md2 : active raid10 sdg1[4] sdc1[0] sdd1[1] sdh1[5] sdf1[3] sde1[2]
      214684224 blocks 64K chunks 2 near-copies [6/6] [UUUUUU]


I like to remove md3 and add its slices to md2. All the slices are of
same sizes.

Then I like to make sure PV recognizes the size increase.

root@apa-splunk-02:~# pvdisplay /dev/md2
  --- Physical volume ---
  PV Name               /dev/md2
  VG Name               splunk
  PV Size               204.74 GiB / not usable 576.00 KiB
  Allocatable           yes
  PE Size               4.00 MiB
  Total PE              52413
  Free PE               1213
  Allocated PE          51200
  PV UUID               S3QuJK-dSU5-cjZZ-mcHe-dyux-V3Qo-YIe2oO

What is recommended way to do it? I am using ubuntu lucid server lts 64bit

Thanks for your help


-- 
Asif Iqbal
PGP Key: 0xE62693C5 KeyServer: pgp.mit.edu
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
