From: Peter Chubb <peter@chubb.wattle.id.au>
Subject: Re: [Ext2-devel] Re: fsck out of memory
Date: Thu, 13 Feb 2003 14:30:27 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15947.4435.829168.530565@wombat.chubb.wattle.id.au>
References: <5250726@toto.iv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5250726@toto.iv>
To: "Stephen C. Tweedie" <sct@redhat.com>
Cc: Stephan van Hienen <raid@a2000.nu>, Andreas Dilger <adilger@clusterfs.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, ext2-devel@lists.sourceforge.net, Theodore Ts'o <tytso@mit.edu>, peter@chubb.wattle.id.au, tbm@a2000.nu
List-Id: linux-raid.ids

>>>>> "Stephen" == Stephen C Tweedie <sct@redhat.com> writes:

Stephen> Hi, On Tue, 2003-02-11 at 13:11, Stephan van Hienen wrote:

Stephen> I've no idea.  Ben has some lb patches up at

Stephen>   http://people.redhat.com/bcrl/lb/

Stephen> but there's nothing broken out against the latest lbd diffs.


Ben's patches are against a very old version of the kernel (2.4.6-pre8)
and require linking against libgcc to get 64-bit division.


The main issue is 64-bit division.  In the limited time I had I
couldn't convince myself that I could rely on all divisors being less
than 2^31 in the raid4/5 code.  If you can convince yourself of that,
then t's a straightforward but tedious task to make raid1, raid4 and
raid5 LBD-safe.

--
Dr Peter Chubb				    peterc@gelato.unsw.edu.au
You are lost in a maze of BitKeeper repositories, all almost the same.
