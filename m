From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Crashing a software raid 5 partition ( disk trouble )
Date: Fri, 13 Jun 2003 15:31:19 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16105.24999.777594.40132@gargle.gargle.HOWL>
References: <007201c330b9$c316f310$3001a8c0@melkor>
	<16104.22045.492729.835610@gargle.gargle.HOWL>
	<16104.22361.508001.916567@gargle.gargle.HOWL>
	<00db01c330ca$5ae72290$3001a8c0@melkor>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Nicolas Meaux on Thursday June 12
To: Nicolas Meaux <nicolas.meaux@artabel.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday June 12, nicolas.meaux@artabel.net wrote:
> Thanks for you quick respond Neil  ;)
> 
> >    mdadm -A --force /dev/md2 /dev/sd[a-f]
> 
> So, i type this command :
> 
> # mdadm -A --force /dev/md2 /dev/sd[a-h]
> mdadm: /dev/md2 has been started with 7 drives.
> 
> ( i do a [a-h] , because i have 8 scsi disk )
> 
> I try too mount md2, it work fine, but :
> # ls -al
> ls: nohup.out: Input/output error
> ls: tape.sh: Input/output error
> ls: .viminfo: Input/output error
> ls: .bash_history: Input/output error
> ls: .bashrc~: Input/output error
> ls: .xauth: Input/output error

Looks like filesystem corruption, which isn't overly surprising.
I would 'fsck' at this point, then copy off the data that you need (if
it is there) and recreate the array, the filesystem, and restore from
backups.


NeilBrown
