From: Ninti Systems <office@ninti.com.au>
Subject: /boot RAID1
Date: 31 Mar 2004 12:04:00 +0930
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1080700439.10119.10.camel@localhost>
Reply-To: office@ninti.com.au
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I've set up everything to switch my fresh Slackware 9.1 install on
/dev/hda over to RAID1 devices set up on /dev/hda (currently 'missing')
and /dev/hdc.

Before I switch, I need to check one thing which isn't clear to me from
the Software RAID HowTo:

I currently have a separate partition (/dev/hda1) for /boot. Can this
partition also be switched over to RAID1 (on /dev/md1) or must the /boot
partition always be on a non-RAID device? 

RAID1 support appears to compiled into the Slackware bare.i kernel I am
using. Autodetection on boot is working.

Thanks
Mick


