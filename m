From: Rik Herrin <rikherrin@yahoo.com>
Subject: Controlling Reading and Writing in RAID 1 configuration
Date: Tue, 25 Apr 2006 05:58:14 -0700 (PDT)
Message-ID: <20060425125814.6366.qmail@web52907.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
  I have a setup where I want to use RAID 1 to mirror
my data over the LAN.  I am exposing 2x500 GB-sized
devices via iSCSI and was wondering if I could
configure the RAID 1 to write to both members of the
RAID 1 configuration but only read from one as one
link is 1GbE while the other is lower but sufficient
for writing.  Is this possible? Thanks for your help.

Regards,
  Rik Herrin

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
