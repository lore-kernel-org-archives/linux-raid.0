From: ross@jose.lug.udel.edu (Ross Vandegrift)
Subject: Re: raid1 mysteriously switching to read-only
Date: Sun, 11 Dec 2005 12:13:50 -0500
Message-ID: <20051211171350.GA18610@jose.lug.udel.edu>
References: <1051127234104.14937@suse.de> <ee0ae26a0512092241v3ee5e445r@mail.gmail.com> <17306.31969.240202.416327@cse.unsw.edu.au> <ee0ae26a0512092350k43b6dc8l@mail.gmail.com> <17306.35737.880103.939683@cse.unsw.edu.au> <ee0ae26a0512100010v4d93d107k@mail.gmail.com> <17306.50617.458648.8740@cse.unsw.edu.au> <ee0ae26a0512110504y63589bck@mail.gmail.com> <439C344F.9020408@ucolick.org> <ee0ae26a0512110629u24a32a2fw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ee0ae26a0512110629u24a32a2fw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yanggun <yang.geum.seok@gmail.com>
Cc: Patrik Jonsson <patrik@ucolick.org>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Dec 11, 2005 at 11:29:23PM +0900, Yanggun wrote:
> I did not find involved part with this in the document.
> 
> I am sorry, inform it is what section.

Basically, the md driver acts like another hard disk.  So a regular
setup looks like this:

---------------------------------
|				|
|	Applications (ls, cat)	|
|				|
---------------------------------
		|
		v
---------------------------------
|				|
|	Filesystem (ext3)	|
|				|
---------------------------------
		|
		v
---------------------------------
|				|
|	Block layer (sda1/sdb1)	|	
|				|
---------------------------------

and a software RAID setup looks like this:

---------------------------------
|				|
|	Applications (ls, cat)	|
|				|
---------------------------------
		|
		v
---------------------------------
|				|
|	Filesystem (ext3)	|
|				|
---------------------------------
		|
		v
---------------------------------
|				|
|	Block layer (md0)	|	
|				|
---------------------------------
		|
		v
---------------------------------
|				|
|	Block Layer (sda1/sdb1)	|
|				|
---------------------------------

The format of sda1/sdb1 is the RAID data that the md driver writes to
them.  It form a complete layer of abstraction between your
applications and the actual devices you are storing data on.

-- 
Ross Vandegrift
ross@lug.udel.edu

"The good Christian should beware of mathematicians, and all those who
make empty prophecies. The danger already exists that the mathematicians
have made a covenant with the devil to darken the spirit and to confine
man in the bonds of Hell."
	--St. Augustine, De Genesi ad Litteram, Book II, xviii, 37
