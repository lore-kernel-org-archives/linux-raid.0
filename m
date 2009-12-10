From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: [Ocfs2-users] Combining OCFS2 with Linux software RAID-0?
Date: Thu, 10 Dec 2009 13:45:25 -0800
Message-ID: <20091210214525.GB23475@mail.oracle.com>
References: <23986fd90912091503r3c671448va4d8637edfab472b@mail.gmail.com>
 <4B214EBB.2060407@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B214EBB.2060407@oracle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sunil Mushran <sunil.mushran@oracle.com>
Cc: "Patrick J. LoPresti" <lopresti@gmail.com>, linux-raid@vger.kernel.org, ocfs2-users@oss.oracle.com
List-Id: linux-raid.ids

On Thu, Dec 10, 2009 at 11:40:43AM -0800, Sunil Mushran wrote:
> It should work. All ocfs2 needs is a stable shared storage that
> is consistent across all nodes all the time.

Patrick,
	What Sunil says is correct; your solution should work.  The big
issue with software RAID is that many forms of RAID can change the
storage topology automatically.  Think of failing one disk and adding a
hot-spare in its place.  If you had such a configuration, one node would
be running on the hot spare while all the other nodes would still be
using the original LUN.  Corruption!  So RAID 5, RAID 6, even RAID 1 -
anything where the RAID software can make an automatic decision that is
seen by one node and not the others - is ripe for data loss.
	RAID 0 and linear concatenation don't have this automatic
problem.  But they still can cause data loss if a fat-fingered admin
accidentally changes the topology on one node while another node is
still using it.  This is an easier mistake to make than you think.  You
have to be absolutely sure your procedures never let this happen.  This
is why our documents say "No Software RAID".
	Hardware RAID doesn't have this problem because it is invisible
to the nodes.  If you change the hardware, all nodes see the change at
the same time.  It looks like the same LUN as always.
	If somehow the software RAID code became cluster aware and
coordinated topology changes across the cluster, then ocfs2 would be
able to support it.  Until that time, we generally have to say "No
Software RAID"; when folks like you come along we say "You can do RAID
0, but caveat emptor!"

Joel

-- 

Life's Little Instruction Book #139

	"Never deprive someone of hope; it might be all they have."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
