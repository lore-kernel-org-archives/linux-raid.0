From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: "Global spare" with mdadm
Date: Tue, 1 Mar 2005 09:12:56 +1100
Message-ID: <16931.38760.582760.803244@cse.unsw.edu.au>
References: <013701c51da9$feb6d280$020aa8c0@llnx7pzaq0g0w3>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
In-Reply-To: message from Slawomir Socha on Monday February 28
Sender: linux-raid-owner@vger.kernel.org
To: Slawomir Socha <socha_s@tlen.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday February 28, socha_s@tlen.pl wrote:
> Hello!
> 
> Does anyone know if it is possible to assign a single spare drive to
> multiple RAID sets using mdadm?
> 
> For example:  a system with 2 x RAID5 would generally have a single spare
> drive.. the first RAID5 to fail grabs it and utilizes it.

Sure is.  Have you read the man page?

Check out "--monitor" mode and the "spare-group=" option in the config
file.

If you find the man page doesn't make it clear enough, I would be
happy to receive suggestions on how to improve it.

NeilBrown
