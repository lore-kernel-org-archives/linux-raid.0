From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: raid 0 on different size devices?
Date: Thu, 20 Nov 2003 10:51:45 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16316.529.860479.5567@notabene.cse.unsw.edu.au>
References: <Pine.LNX.4.44.0311191154050.5855-100000@eglifamily.dnsalias.net>
	<1069268427.6956.21.camel@opus>
	<200311192018.14555.dusty@strike.wu-wien.ac.at>
	<1069269741.6952.33.camel@opus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from seth vidal on  November 19
To: seth vidal <skvidal@phy.duke.edu>
Cc: Hermann Himmelbauer <dusty@strike.wu-wien.ac.at>, Dan Egli <dan@eglifamily.dnsalias.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On  November 19, skvidal@phy.duke.edu wrote:
> 
> > AFAIK they have to be of equal size but as you can create a 27GB partition on 
> > the 40GB drive, you could at least get 54GB out of this configuration. 
> 
> No. I have a 120GB and a 60GB disk in a linear array working just fine.
> 
> it's not technically raid0, but it lets the person do what they're
> wanting to do.
> 

The 'md' driver will let you set up an 'raid0' array using these two
drives.  This will result in a 180GB array.

The first 120 Gb will be striped over the two drives.  The remaining
60Gb will simply be the end of the larger drive.

You can, ofcourse, also set up a linear array.

man md

(with mdadm installed).

NeilBrown
