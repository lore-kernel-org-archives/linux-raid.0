From: "John Stoffel" <john@stoffel.org>
Subject: Re: Can't mount /dev/md0 Raid5
Date: Wed, 11 Oct 2017 15:49:09 -0400
Message-ID: <23006.30133.937919.352598@quad.stoffel.home>
References: <59DDF18A.9060800@gmail.com>
        <8628ddba-8cec-24d8-e07a-195d47f579be@grumpydevil.homelinux.org>
        <59DDFD19.1040700@gmail.com>
        <e6566c4a-2476-4554-549a-12b6c90b152f@websitemanagers.com.au>
        <59DE0705.502@gmail.com>
        <alpine.DEB.2.20.1710111600210.31961@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.20.1710111600210.31961@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Joseba Ibarra <wajalotnet@gmail.com>, Adam Goryachev <adam@websitemanagers.com.au>, Rudy Zijlstra <rudy@grumpydevil.homelinux.org>, list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Mikael" == Mikael Abrahamsson <swmike@swm.pp.se> writes:

Mikael> On Wed, 11 Oct 2017, Joseba Ibarra wrote:
>> Now I see the RAID, however can't be mounted. So, I'm not sure how to backup 
>> the data. Gparted shows the partition /dev/md0p1 with the used and free 
>> space.

Mikael> Do you know what file system you had? Looks like next step is to try to 
Mikael> run fsck -n (read-only) on md0 and/or md0p1.

Mikael> What does /etc/fstab contain regarding md0?

Did you have the RAID5 setup as a PV inside a VG?  What does:

    vgscan

give you back when you run it as root?

