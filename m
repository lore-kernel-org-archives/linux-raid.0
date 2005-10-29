From: Sean Puttergill <puttergi@yahoo.ca>
Subject: Superblock updates to failed spare
Date: Fri, 28 Oct 2005 21:43:03 -0400 (EDT)
Message-ID: <20051029014303.43297.qmail@web32812.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If I create a raid array with a hot spare, put a
filesystem on the array, mount it, then physically
remove the spare (SATA) drive (simulating a failure of
the spare), I get infinite, periodic superblock update
failures to the spare like this:

"
scsi2 (0:0): rejecting I/O to dead device

md: write_disk_sb failed for device sdc

md: errors occurred during superblock update,
repeating

[repeated many times and then eventually ...]

md: excessive errors occurred during superblock
update, exiting
"

This repeats every few seconds.

I understand that the superblock on the spare is being
periodically updated along with the superblocks on the
active drives, but md should recognize that the spare
is bad and kick it out of the array.  If the spare
were to actually fail you would end up with your logs
being clogged with the above messages.

On a related note, has any work been done to modify md
such that it doesn't update the superblock on the
spare?  This would allow the spare to remain asleep
until it is really needed for a rebuild (preserving
the health of the spare).

I am running kernel 2.6.11


Cheers,
Sean





	

	
		
__________________________________________________________ 
Find your next car at http://autos.yahoo.ca
