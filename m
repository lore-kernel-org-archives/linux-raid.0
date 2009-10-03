From: Igor Podlesny <for.poige+linux@gmail.com>
Subject: Shifting 0xFD partition's end boundary && 0.90 format superblock ==
	Bad Idea(?)
Date: Sat, 3 Oct 2009 15:54:51 +0800
Message-ID: <43d009740910030054l77b53dcdufa9d57f8339d16bb@mail.gmail.com>
Reply-To: for.poige+linux@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

	It looks like. :-)
	
	I have disk layout where RAID's partition is followed by non-RAID's.
I was pretty sure that having deleted those non-RAID's partitions, and
shifted RAID's partition end to occupy the whole disk would be a
simple step, but having read man md(4) I figured out that 0.9 format
superblock is located at the end of device. So, it seems the only way
to follow is kicking partitions from the array, change theirs size,
add them again (resyncing!) and all that for each RAID's component.
Then Grow. Amen.
	
	Correct?
	
	Would using of version-1 (1.1 / 1.2) superblock made it simpler (just
move partition end and run grow)?
	
	Are there some gotchas with version-1? Would kernel RAID autodetect work?

-- 
End of message. Next message?
