From: Jean-Luc Cooke <jlcooke@certainkey.com>
Subject: raidreconf on raid-5, SATA, inf. Write Errors
Date: Sat, 10 Dec 2005 16:27:28 -0500
Message-ID: <20051210212728.GB20215@certainkey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi team,

I've had a 7-disk RAID-5 system running for months on a 2.6 kernel it it's
been great.  I had a need to expand, so I bought 4 more disks and I'd
expanding using raidreconf from:
  http://unthought.net/raidreconf/

I saw the warnings and - you guesses it - it's happened.

My reconf is going very slowly because I keep getting write problems (however
it does *slowly* advance in progress) on 4 of my 11 disks.  The 4 disks in
question are all on the same SATA controller.

Some notes to point out:
 - I ran a test expansion of 4 /dev/loop[0-4] to /dev/loop[0-8] RAID-5 and it
   worked, so my steps *should* work
 - I ran SMARTCTL checks on all disks before doing this, all was clean
 - I copied over 1TB of data to or from all these disks before I started,
   so this seems to be a net-new since I started raidreconf
 - All the errors are coming from the same 4 disks which are on the same
   controller.
 - I'm still running raidreconf because if I stop it, I will lose everything

I know I took on this risk when I started my conversion.  But I'd like to get
any pointers I can since my honeymoon photos are on there (sentimental value
is priceless - insert divorce comments now).

Here are my questions:
 - Is there something I should be looking out for that may suddenly cause
   these errors to show up (static, improper grounding points on the disk
   drives? anything?)
 - Now that I'm seeing these messages show up every 5 sec or so, how can I
   reduce their frequency so it will not take 5 years to finish this
   expansion.

Any help would be hugely appreciated.

JLC
