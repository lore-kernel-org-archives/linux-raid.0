From: Dimitris Zilaskos <dzila@tassadar.physics.auth.gr>
Subject: Re: recover data from linear raid
Date: Tue, 27 Jun 2006 16:49:55 +0300 (EEST)
Message-ID: <Pine.LNX.4.64.0606271640520.17191@tassadar.physics.auth.gr>
References: <Pine.LNX.4.64.0606242233000.32322@tassadar.physics.auth.gr>
	<17566.13544.15613.709664@cse.unsw.edu.au>
	<Pine.LNX.4.64.0606261640330.16450@tassadar.physics.auth.gr>
	<Pine.LNX.4.64.0606261818510.18573@tassadar.physics.auth.gr>
	<Pine.LNX.4.64.0606261835040.18573@tassadar.physics.auth.gr>
	<17568.34942.243102.778519@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <ext3-users-bounces@redhat.com>
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
Cc: linux-raid@vger.kernel.org, ext3-users@redhat.com
List-Id: linux-raid.ids



On Tue, 27 Jun 2006, Neil Brown wrote:

> On Monday June 26, dzila@tassadar.physics.auth.gr wrote:
>>
>>  	This is what I get now, after creating with fdisk /dev/hdb1 and
>> /dev/hdc1 as linux raid autodetect partitions
>
> So I'm totally confused now.
>
> You said it was 'linear', but the boot log showed 'raid0'.


 	You aire absolutely right. Me bad

> The drives didn't have a partition table on them, yet it is clear from
> the old boot log that the did.  Are you sure they are the same drives,
> 'cause it doesn't seem like it.

 	That's the root of my problem...when I moved the disks to the new 
system the disks showed up as unpartitioned.

> You could try hunting for ext3 superblocks on the device.  There might
> be an easier way but
>
>  od -x /dev/hdb | grep '^.....60 .... .... .... .... ef53 '
>
> should find them.  Once you have this information we might be able to
> make something work.  But I feel the chances are dwindling.
>


 	Me too. In any case the data was not that critical, so I will play 
around a little more before I give up.


 	Thank you all for your help:)

--
============================================================================

Dimitris Zilaskos

Department of Physics @ Aristotle University of Thessaloniki , Greece
PGP key : http://tassadar.physics.auth.gr/~dzila/pgp_public_key.asc
 	  http://egnatia.ee.auth.gr/~dzila/pgp_public_key.asc
MD5sum  : de2bd8f73d545f0e4caf3096894ad83f  pgp_public_key.asc
============================================================================
