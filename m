From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: recover data from linear raid
Date: Tue, 27 Jun 2006 01:23:34 -0600
Message-ID: <20060627072334.GA5817@schatzie.adilger.int>
References: <Pine.LNX.4.64.0606242233000.32322@tassadar.physics.auth.gr>
	<17566.13544.15613.709664@cse.unsw.edu.au>
	<Pine.LNX.4.64.0606261640330.16450@tassadar.physics.auth.gr>
	<Pine.LNX.4.64.0606261818510.18573@tassadar.physics.auth.gr>
	<Pine.LNX.4.64.0606261835040.18573@tassadar.physics.auth.gr>
	<17568.34942.243102.778519@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <ext3-users-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <17568.34942.243102.778519@cse.unsw.edu.au>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/ext3-users>,
	<mailto:ext3-users-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/ext3-users>
List-Post: <mailto:ext3-users@redhat.com>
List-Help: <mailto:ext3-users-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/ext3-users>,
	<mailto:ext3-users-request@redhat.com?subject=subscribe>
Sender: ext3-users-bounces@redhat.com
Errors-To: ext3-users-bounces@redhat.com
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org, Dimitris Zilaskos <dzila@tassadar.physics.auth.gr>, ext3-users@redhat.com
List-Id: linux-raid.ids

On Jun 27, 2006  11:23 +1000, Neil Brown wrote:
> You could try hunting for ext3 superblocks on the device.  There might
> be an easier way but
> 
>   od -x /dev/hdb | grep '^.....60 .... .... .... .... ef53 '

Compile the "findsuper" tool from e2fsprogs - it was made for this.  Also
possible to use "gpart".

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
