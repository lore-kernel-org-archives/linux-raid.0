From: Gregory Stark <stark@enterprisedb.com>
Subject: md has hard coded maximum number of drives?
Date: Tue, 04 Nov 2008 20:26:03 +0000
Message-ID: <87y6zz5jc4.fsf@oxford.xeocode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


# mdadm --create /dev/md0 --level 0 --raid-devices 60 `cat drives`
mdadm: invalid number of raid devices: 60

# mdadm --create /dev/md0 --level 0 --raid-devices 32 `cat drives`
mdadm: invalid number of raid devices: 32

# mdadm --create /dev/md0 --level 0 --raid-devices 33 `cat drives`
mdadm: invalid number of raid devices: 33



Firstly, "invalid number" is a terrible error message. 60 is a perfectly good
number. The error message gives no indication of why it doesn't find 60 to be
a "valid" number.


Secondly there's no mention in any documentation for mdadm or anywhere else
that I can find of any arbitrary maximum number of drives.


Thirdly, WTF?!


-- 
greg
