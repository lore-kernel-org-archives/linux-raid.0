From: "Gravity IT Solutions" <info@egravity.net>
Subject: RAID-5: The following arrays have missing required members and cannot be configured
Date: Wed, 13 May 2015 16:28:41 +0500
Message-ID: <00c501d08d6f$f8c6aa80$ea53ff80$@egravity.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am developer so my System admin knowledge is basic. 

I have 3 Arrays in my system 1 for OS and 2 for data both data arrays are
Raid-5 and each was showing 1 bad drive, so i shutdown the system and
replaced both drives with a larger drives I checked in Adaptec Bios Array
and it was showing both arrays rebuilding when i was exiting the bios setup,
Array -1 was 2% and Array-2 was showing 1%, so i booted the system and after
few hours i checked the process was complete and i restarted to check the
status in the bois setup, there i was it was showing only 2 Arrays the 3rd
was missing, when i tried rebooting the system it gave me this message

The following arrays have missing required members and cannot be configured
:Array#2-RAID-5

Press <Enter> to accept the current configuration Press< Ctrl-A> to enter
Adaptec RAID Configuration Utility Press <Ctrl-H> to Pause Configuration
Messages (Default is not to accept if no valid key pressed in 30 seconds)
i selected the default to go on and boot, but system did not boot as it
could not find the array and ask me to fix it, so just commented the mount
in the fstab and booted
i can not see the drives in the /dev folder
can you please guide me on how to fix it?

 

Thanks

