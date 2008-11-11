From: "Igor Podlesny" <for.poige+linux@gmail.com>
Subject: How about reversed (or offset) disk components?
Date: Wed, 12 Nov 2008 01:40:52 +0700
Message-ID: <43d009740811111040x5e610582n9f9bd4354682ca16@mail.gmail.com>
Reply-To: for.poige+linux@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids

	Hi!

	And I have one more idea: How about reversed (or offset) disk
components? -- It's known that linear read speed is decreasing when
reading from the beginning to end of HDD, thus leading to situation
when reading from RAID is good at its beginning and rather poor at its
ending. My suggestion (possibly) would make that speed almost constant
in despite of reading position. Examples:
	
	RAID5:

	disk1: 0123456789
	disk2: 3456789012
	disk3: 6789012345

	i. .e, the disk1's chunks aren't offseted at all, and disks' 2 and 3 are.
	
	RAID0:
	
	disk1: 0123456789
	disk2: 9876543210

	Any drawbacks?

-- 
End of message. Next message?
